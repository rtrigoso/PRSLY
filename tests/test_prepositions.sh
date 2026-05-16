#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AWK_SCRIPT="$SCRIPT_DIR/../app/prepositions.awk"

pass=0
fail=0

assert_preposition() {
    local description="$1"
    local word="$2"
    local output
    output=$(echo "$word" | awk -f "$AWK_SCRIPT")
    if echo "$output" | grep -q "^${word}[[:space:]]*preposition"; then
        echo "PASS: $description"
        ((pass++))
    else
        echo "FAIL: $description"
        echo "  Expected: $word -> preposition"
        echo "  Got:      $output"
        ((fail++))
    fi
}

assert_not_preposition() {
    local description="$1"
    local word="$2"
    local output
    output=$(echo "$word" | awk -f "$AWK_SCRIPT")
    if echo "$output" | grep -q "^${word}[[:space:]]*preposition"; then
        echo "FAIL: $description (should not be tagged as preposition)"
        echo "  Got: $output"
        ((fail++))
    else
        echo "PASS: $description"
        ((pass++))
    fi
}

# Simple prepositions
assert_preposition "at is a preposition"    "at"
assert_preposition "by is a preposition"    "by"
assert_preposition "in is a preposition"    "in"
assert_preposition "of is a preposition"    "of"
assert_preposition "on is a preposition"    "on"
assert_preposition "to is a preposition"    "to"

# Location/direction prepositions
assert_preposition "aboard is a preposition"      "aboard"
assert_preposition "about is a preposition"       "about"
assert_preposition "above is a preposition"       "above"
assert_preposition "across is a preposition"      "across"
assert_preposition "against is a preposition"     "against"
assert_preposition "along is a preposition"       "along"
assert_preposition "alongside is a preposition"   "alongside"
assert_preposition "amid is a preposition"        "amid"
assert_preposition "amidst is a preposition"      "amidst"
assert_preposition "among is a preposition"       "among"
assert_preposition "amongst is a preposition"     "amongst"
assert_preposition "around is a preposition"      "around"
assert_preposition "atop is a preposition"        "atop"
assert_preposition "behind is a preposition"      "behind"
assert_preposition "below is a preposition"       "below"
assert_preposition "beneath is a preposition"     "beneath"
assert_preposition "beside is a preposition"      "beside"
assert_preposition "besides is a preposition"     "besides"
assert_preposition "between is a preposition"     "between"
assert_preposition "beyond is a preposition"      "beyond"
assert_preposition "down is a preposition"        "down"
assert_preposition "inside is a preposition"      "inside"
assert_preposition "into is a preposition"        "into"
assert_preposition "near is a preposition"        "near"
assert_preposition "off is a preposition"         "off"
assert_preposition "onto is a preposition"        "onto"
assert_preposition "outside is a preposition"     "outside"
assert_preposition "over is a preposition"        "over"
assert_preposition "through is a preposition"     "through"
assert_preposition "throughout is a preposition"  "throughout"
assert_preposition "toward is a preposition"      "toward"
assert_preposition "towards is a preposition"     "towards"
assert_preposition "under is a preposition"       "under"
assert_preposition "underneath is a preposition"  "underneath"
assert_preposition "upon is a preposition"        "upon"
assert_preposition "within is a preposition"      "within"
assert_preposition "without is a preposition"     "without"

# Other prepositions
assert_preposition "circa is a preposition"           "circa"
assert_preposition "despite is a preposition"         "despite"
assert_preposition "during is a preposition"          "during"
assert_preposition "from is a preposition"            "from"
assert_preposition "notwithstanding is a preposition" "notwithstanding"
assert_preposition "per is a preposition"             "per"
assert_preposition "regarding is a preposition"       "regarding"
assert_preposition "until is a preposition"           "until"
assert_preposition "via is a preposition"             "via"
assert_preposition "with is a preposition"            "with"

# Non-prepositions
assert_not_preposition "dog is not a preposition"   "dog"
assert_not_preposition "run is not a preposition"   "run"
assert_not_preposition "quick is not a preposition" "quick"

echo ""
echo "Results: $pass passed, $fail failed"
[ $fail -eq 0 ]
