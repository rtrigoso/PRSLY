#!/usr/bin/awk -f

function shell_quote(s) { gsub(/'/, "'\\''", s); return "'" s "'" }

function _run(word, prev1, prev2, next1, pw1, is_end) {
    return "printf '%s\\n' " shell_quote(word) \
           " | awk -v CURRENT_WORD=" shell_quote(word) \
           " -v prev1_label=" shell_quote(prev1) \
           " -v prev2_label=" shell_quote(prev2) \
           " -v next1_label=" shell_quote(next1) \
           " -v prev1_word=" shell_quote(pw1) \
           " -v IS_SENT_END=" is_end \
           " -f " CLASSIFIER
}

function classify(word, prev1, prev2, next1, pw1, is_end,    cmd, line, label) {
    label = "unknown"
    _last_certainty = 0
    cmd = _run(word, prev1, prev2, next1, pw1, is_end)
    while ((cmd | getline line) > 0) {
        if (match(line, /"pos": "[a-z]+"/))
            label = substr(line, RSTART + 8, RLENGTH - 9)
        if (match(line, /"certainty": [0-9.]+/))
            _last_certainty = substr(line, RSTART + 13, RLENGTH - 13) + 0
    }
    close(cmd)
    return label
}

function format_word(word, prev1, prev2, next1, pw1, is_end,    cmd, line, out) {
    cmd = _run(word, prev1, prev2, next1, pw1, is_end)
    out = ""
    while ((cmd | getline line) > 0) out = line
    close(cmd)
    return out
}

# Sets _p1, _pw1, _p2 — certainty-gated left context for position i.
function resolve_left_ctx(i) {
    _p1  = (i > 1 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? final[i-1] : ""
    _pw1 = (i > 1 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? words[i-1] : ""
    _p2  = (i > 2 && !sent_end[i-1] && !sent_end[i-2] && certainty[i-2] >= CTXT_THRESHOLD) ? final[i-2] : ""
}

# Returns the right-context label for position i.
function resolve_right_ctx(i) {
    return (i < n && !sent_end[i]) ? final[i+1] : ""
}

# Reclassifies word i with full bidirectional context; updates final[] and
# certainty[] when certainty improves or the label was unknown.
# Returns 1 if either the label or certainty changed.
function try_update(i,    new_label, did_change) {
    resolve_left_ctx(i)
    new_label = classify(words[i], _p1, _p2, resolve_right_ctx(i), _pw1, sent_end[i]+0)
    if (_last_certainty > certainty[i] || final[i] == "unknown") {
        did_change = (final[i] != new_label || certainty[i] != _last_certainty)
        final[i]    = new_label
        certainty[i] = _last_certainty
        return did_change
    }
    return 0
}

# Seeds final[] with a left-to-right pass using no right context.
function bootstrap_labels(    i, p1, pw1, p2) {
    for (i = 1; i <= n; i++) {
        p1  = (i > 1 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? final[i-1] : ""
        pw1 = (i > 1 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? words[i-1] : ""
        p2  = (i > 2 && !sent_end[i-1] && !sent_end[i-2] && certainty[i-2] >= CTXT_THRESHOLD) ? final[i-2] : ""
        final[i]    = classify(words[i], p1, p2, "", pw1, sent_end[i]+0)
        certainty[i] = _last_certainty
    }
}

# One left-to-right sweep. Returns the count of words whose state changed.
function forward_pass(    i, changed) {
    changed = 0
    for (i = 1; i <= n; i++) changed += try_update(i)
    return changed
}

# One right-to-left sweep. Returns the count of words whose state changed.
function backward_pass(    i, changed) {
    changed = 0
    for (i = n; i >= 1; i--) changed += try_update(i)
    return changed
}

# Alternates forward and backward passes until labels stabilise or MAX_ITER is reached.
function iterate_until_convergence(    iter) {
    for (iter = 1; iter <= MAX_ITER; iter++)
        if (forward_pass() + backward_pass() == 0) break
}

# Emits the final JSON array, re-running each word with its resolved neighbours.
function print_results(    i, p1, pw1, p2, next1) {
    print "["
    for (i = 1; i <= n; i++) {
        p1    = (i > 1 && !sent_end[i-1]) ? final[i-1] : ""
        pw1   = (i > 1 && !sent_end[i-1]) ? words[i-1] : ""
        p2    = (i > 2 && !sent_end[i-1] && !sent_end[i-2]) ? final[i-2] : ""
        next1 = (i < n && !sent_end[i]) ? final[i+1] : ""
        printf "%s", format_word(words[i], p1, p2, next1, pw1, sent_end[i]+0)
        if (i < n) print ","
        else       print ""
    }
    print "]"
}

BEGIN {
    if (CLASSIFIER == "") CLASSIFIER = "app/pos_classifier.awk"

    if (ARGC > 1) {
        sentence = ARGV[1]
        for (i = 2; i < ARGC; i++) sentence = sentence " " ARGV[i]
        for (i = 1; i < ARGC; i++) ARGV[i] = ""
    } else if ((getline sentence < "/dev/stdin") <= 0) {
        print "error: no input provided" > "/dev/stderr"
        exit 1
    }

    CTXT_THRESHOLD = 0.50
    MAX_ITER       = 10

    n = split(sentence, words, " ")
    for (i = 1; i <= n; i++) {
        sent_end[i] = (words[i] ~ /[.!?]+$/)
        gsub(/[^a-zA-Z0-9'-]$/, "", words[i])
    }

    bootstrap_labels()
    iterate_until_convergence()
    print_results()
}
