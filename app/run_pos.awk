#!/usr/bin/awk -f

function shell_quote(s) { gsub(/'/, "'\\''", s); return "'" s "'" }

function _run(word, prev1, prev2, next1, pw1) {
    return "printf '%s\\n' " shell_quote(word) \
           " | awk -v CURRENT_WORD=" shell_quote(word) \
           " -v prev1_label=" shell_quote(prev1) \
           " -v prev2_label=" shell_quote(prev2) \
           " -v next1_label=" shell_quote(next1) \
           " -v prev1_word=" shell_quote(pw1) \
           " -f " CLASSIFIER
}

function classify(word, prev1, prev2, next1, pw1,    cmd, line, label) {
    label = "unknown"
    _last_certainty = 0
    cmd = _run(word, prev1, prev2, next1, pw1)
    while ((cmd | getline line) > 0) {
        if (match(line, /"pos": "[a-z]+"/))
            label = substr(line, RSTART + 8, RLENGTH - 9)
        if (match(line, /"certainty": [0-9]+/))
            _last_certainty = substr(line, RSTART + 13, RLENGTH - 13) + 0
    }
    close(cmd)
    return label
}

function format_word(word, prev1, prev2, next1, pw1,    cmd, line, out) {
    cmd = _run(word, prev1, prev2, next1, pw1)
    out = ""
    while ((cmd | getline line) > 0) out = line
    close(cmd)
    return out
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

    CTXT_THRESHOLD = 60

    n = split(sentence, words, " ")
    for (i = 1; i <= n; i++) {
        sent_end[i] = (words[i] ~ /[.!?]+$/)
        gsub(/[^a-zA-Z0-9'-]$/, "", words[i])
    }

    # ── PASS 1 : classify with left context only ──────────────────────────────
    for (i = 1; i <= n; i++) {
        p1  = (i >= 2 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? pass1[i-1] : ""
        pw1 = (i >= 2 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? words[i-1] : ""
        p2  = (i >= 3 && !sent_end[i-1] && !sent_end[i-2] && certainty[i-2] >= CTXT_THRESHOLD) ? pass1[i-2] : ""
        pass1[i] = classify(words[i], p1, p2, "", pw1)
        certainty[i] = _last_certainty
    }

    for (i = 1; i <= n; i++) final[i] = pass1[i]

    # ── PASS 2 : re-classify unknowns using pass-1 neighbours ────────────────
    for (i = 1; i <= n; i++) {
        if (final[i] != "unknown") continue
        p1 = ""; pw1 = ""; p2 = ""
        for (j = i-1; j >= 1; j--) {
            if (sent_end[j]) break
            if (pass1[j] != "unknown" && certainty[j] >= CTXT_THRESHOLD) {
                if (p1 == "") { p1 = pass1[j]; pw1 = words[j] }
                else          { p2 = pass1[j]; break }
            }
        }
        next1 = ""
        for (j = i+1; j <= n; j++) {
            if (sent_end[i]) break
            if (pass1[j] != "unknown") { next1 = pass1[j]; break }
        }
        final[i] = classify(words[i], p1, p2, next1, pw1)
        certainty[i] = _last_certainty
    }

    # ── PASS 3 : re-classify still-unknown using pass-2 resolved neighbours ───
    for (i = 1; i <= n; i++) {
        if (final[i] != "unknown" && final[i] != "") continue
        p1 = ""; pw1 = ""; p2 = ""
        for (j = i-1; j >= 1; j--) {
            if (sent_end[j]) break
            if (final[j] != "unknown" && final[j] != "" && certainty[j] >= CTXT_THRESHOLD) {
                if (p1 == "") { p1 = final[j]; pw1 = words[j] }
                else          { p2 = final[j]; break }
            }
        }
        next1 = ""
        for (j = i+1; j <= n; j++) {
            if (sent_end[i]) break
            if (final[j] != "unknown" && final[j] != "") { next1 = final[j]; break }
        }
        final[i] = classify(words[i], p1, p2, next1, pw1)
        certainty[i] = _last_certainty
    }

    # ── PASS 4 : re-classify low-certainty words with fully-resolved neighbours
    THRESHOLD = 65
    for (i = 1; i <= n; i++) {
        if (certainty[i] >= THRESHOLD) continue
        p1    = (i > 1 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? final[i-1] : ""
        pw1   = (i > 1 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? words[i-1] : ""
        p2    = (i > 2 && !sent_end[i-1] && !sent_end[i-2] && certainty[i-2] >= CTXT_THRESHOLD) ? final[i-2] : ""
        next1 = (i < n && !sent_end[i]) ? final[i+1] : ""
        new_label = classify(words[i], p1, p2, next1, pw1)
        if (_last_certainty > certainty[i]) {
            final[i] = new_label
            certainty[i] = _last_certainty
        }
    }

    # ── PASS 4b : second sweep to propagate corrections from pass 4 ──────────
    for (i = 1; i <= n; i++) {
        p1    = (i > 1 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? final[i-1] : ""
        pw1   = (i > 1 && !sent_end[i-1] && certainty[i-1] >= CTXT_THRESHOLD) ? words[i-1] : ""
        p2    = (i > 2 && !sent_end[i-1] && !sent_end[i-2] && certainty[i-2] >= CTXT_THRESHOLD) ? final[i-2] : ""
        next1 = (i < n && !sent_end[i]) ? final[i+1] : ""
        new_label = classify(words[i], p1, p2, next1, pw1)
        if (_last_certainty > certainty[i]) {
            final[i] = new_label
            certainty[i] = _last_certainty
        }
    }

    # ── OUTPUT : re-run each word with final resolved neighbours for display ──
    print "["
    for (i = 1; i <= n; i++) {
        p1    = (i > 1 && !sent_end[i-1]) ? final[i-1] : ""
        pw1   = (i > 1 && !sent_end[i-1]) ? words[i-1] : ""
        p2    = (i > 2 && !sent_end[i-1] && !sent_end[i-2]) ? final[i-2] : ""
        next1 = (i < n && !sent_end[i]) ? final[i+1] : ""
        printf "%s", format_word(words[i], p1, p2, next1, pw1)
        if (i < n) print ","
        else       print ""
    }
    print "]"
}
