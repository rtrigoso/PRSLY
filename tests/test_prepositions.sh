#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_POS="$SCRIPT_DIR/../app/run_pos.awk"

pass=0
fail=0

assert_preposition() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "preposition"'; then
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
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "preposition"'; then
        echo "FAIL: $description (should not be tagged as preposition)"
        echo "  Got: $output"
        ((fail++))
    else
        echo "PASS: $description"
        ((pass++))
    fi
}

assert_pos() {
    local description="$1"
    local sentence="$2"
    local word="$3"
    local expected_pos="$4"
    local output
    output=$(awk -v CLASSIFIER="$SCRIPT_DIR/../app/pos_classifier.awk" -f "$RUN_POS" "$sentence")
    local got_pos
    got_pos=$(echo "$output" | awk -v w="\"$word\"" '$0 ~ "\"word\": " w { gsub(/.*"pos": "/, ""); gsub(/".*/, ""); print; exit }')
    if [ "$got_pos" = "$expected_pos" ]; then
        echo "PASS: $description"
        ((pass++))
    else
        echo "FAIL: $description"
        echo "  Expected: $word -> $expected_pos"
        echo "  Got:      $word -> $got_pos"
        echo "  Full:     $output"
        ((fail++))
    fi
}

# Simple prepositions
assert_preposition "at is a preposition"    "at"
assert_preposition "by is a preposition"    "by"
assert_preposition "for is a preposition"   "for"
assert_preposition "in is a preposition"    "in"
assert_preposition "of is a preposition"    "of"
assert_preposition "on is a preposition"    "on"
assert_preposition "to is a preposition"    "to"
assert_preposition "up is a preposition"    "up"
assert_preposition "with is a preposition"  "with"

# Location/direction prepositions
assert_preposition "about is a preposition"   "about"
assert_preposition "above is a preposition"   "above"
assert_preposition "across is a preposition"  "across"
assert_preposition "after is a preposition"   "after"
assert_preposition "along is a preposition"   "along"
assert_preposition "before is a preposition"  "before"
assert_preposition "behind is a preposition"  "behind"
assert_preposition "below is a preposition"   "below"
assert_preposition "beside is a preposition"  "beside"
assert_preposition "between is a preposition" "between"
assert_preposition "down is a preposition"    "down"
assert_preposition "from is a preposition"    "from"
assert_preposition "into is a preposition"    "into"
assert_preposition "near is a preposition"    "near"
assert_preposition "off is a preposition"     "off"
assert_preposition "onto is a preposition"    "onto"
assert_preposition "over is a preposition"    "over"
assert_preposition "past is a preposition"    "past"
assert_preposition "through is a preposition" "through"
assert_preposition "toward is a preposition"  "toward"
assert_preposition "towards is a preposition" "towards"
assert_preposition "under is a preposition"   "under"
assert_preposition "within is a preposition"  "within"

# Other prepositions
assert_preposition "despite is a preposition"  "despite"
assert_preposition "during is a preposition"   "during"
assert_preposition "except is a preposition"   "except"
assert_preposition "since is a preposition"    "since"
assert_preposition "until is a preposition"    "until"
assert_preposition "via is a preposition"      "via"

# From "The only person you are destined to become is the person you decide to be."
assert_pos "to is a preposition in 'The only person you are destined to become is the person you decide to be.'" \
    "The only person you are destined to become is the person you decide to be." "to" "preposition"

# From "Moby Dick is a classic story about challenges and obsession."
assert_pos "about is a preposition after noun in 'Moby Dick is a classic story about challenges and obsession.'" \
    "Moby Dick is a classic story about challenges and obsession." "about" "preposition"

# Non-prepositions
assert_not_preposition "dog is not a preposition"   "dog"
assert_not_preposition "run is not a preposition"   "run"
assert_not_preposition "quick is not a preposition" "quick"

echo ""
echo "Results - Prepositions: $pass passed, $fail failed"
[ $fail -eq 0 ]
