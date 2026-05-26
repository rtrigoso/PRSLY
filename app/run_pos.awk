#!/usr/bin/awk -f

function shell_quote(s) { gsub(/'/, "'\\''", s); return "'" s "'" }

function _run(word, prev1, prev2, next1) {
    return "printf '%s\\n' " shell_quote(word) \
           " | awk -v CURRENT_WORD=" shell_quote(word) \
           " -v prev1_label=" shell_quote(prev1) \
           " -v prev2_label=" shell_quote(prev2) \
           " -v next1_label=" shell_quote(next1) \
           " -f " CLASSIFIER
}

function classify(word, prev1, prev2, next1,    cmd, line, label) {
    label = "unknown"
    _last_certainty = 0
    cmd = _run(word, prev1, prev2, next1)
    while ((cmd | getline line) > 0) {
        if (match(line, /"pos": "[a-z]+"/))
            label = substr(line, RSTART + 8, RLENGTH - 9)
        if (match(line, /"certainty": [0-9]+/))
            _last_certainty = substr(line, RSTART + 13, RLENGTH - 13) + 0
    }
    close(cmd)
    return label
}

function format_word(word, prev1, prev2, next1,    cmd, line, out) {
    cmd = _run(word, prev1, prev2, next1)
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

    n = split(sentence, words, " ")

    # ── PASS 1 : classify with left context only ──────────────────────────────
    for (i = 1; i <= n; i++) {
        p1 = (i >= 2) ? pass1[i-1] : ""
        p2 = (i >= 3) ? pass1[i-2] : ""
        pass1[i] = classify(words[i], p1, p2, "")
        certainty[i] = _last_certainty
    }

    for (i = 1; i <= n; i++) final[i] = pass1[i]

    # ── PASS 2 : re-classify unknowns using pass-1 neighbours ────────────────
    for (i = 1; i <= n; i++) {
        if (final[i] != "unknown") continue
        p1 = ""; p2 = ""
        for (j = i-1; j >= 1; j--) {
            if (pass1[j] != "unknown") {
                if (p1 == "") p1 = pass1[j]
                else          { p2 = pass1[j]; break }
            }
        }
        next1 = ""
        for (j = i+1; j <= n; j++) {
            if (pass1[j] != "unknown") { next1 = pass1[j]; break }
        }
        final[i] = classify(words[i], p1, p2, next1)
        certainty[i] = _last_certainty
    }

    # ── PASS 3 : re-classify still-unknown using pass-2 resolved neighbours ───
    for (i = 1; i <= n; i++) {
        if (final[i] != "unknown" && final[i] != "") continue
        p1 = ""; p2 = ""
        for (j = i-1; j >= 1; j--) {
            if (final[j] != "unknown" && final[j] != "") {
                if (p1 == "") p1 = final[j]
                else          { p2 = final[j]; break }
            }
        }
        next1 = ""
        for (j = i+1; j <= n; j++) {
            if (final[j] != "unknown" && final[j] != "") { next1 = final[j]; break }
        }
        final[i] = classify(words[i], p1, p2, next1)
        certainty[i] = _last_certainty
    }

    # ── PASS 4 : re-classify low-certainty words with fully-resolved neighbours
    THRESHOLD = 65
    for (i = 1; i <= n; i++) {
        if (certainty[i] >= THRESHOLD) continue
        p1    = (i > 1) ? final[i-1] : ""
        p2    = (i > 2) ? final[i-2] : ""
        next1 = (i < n) ? final[i+1] : ""
        new_label = classify(words[i], p1, p2, next1)
        if (_last_certainty > certainty[i]) {
            final[i] = new_label
            certainty[i] = _last_certainty
        }
    }

    # ── OUTPUT : re-run each word with final resolved neighbours for display ──
    print "["
    for (i = 1; i <= n; i++) {
        p1    = (i > 1) ? final[i-1] : ""
        p2    = (i > 2) ? final[i-2] : ""
        next1 = (i < n) ? final[i+1] : ""
        printf "%s", format_word(words[i], p1, p2, next1)
        if (i < n) print ","
        else       print ""
    }
    print "]"
}
