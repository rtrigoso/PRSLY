#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_POS="$SCRIPT_DIR/../app/run_pos.awk"

pass=0
fail=0

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

assert_verb() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "verb"'; then
        echo "PASS: $description"
        ((pass++))
    else
        echo "FAIL: $description"
        echo "  Expected: $word -> verb"
        echo "  Got:      $output"
        ((fail++))
    fi
}

assert_not_verb() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "verb"'; then
        echo "FAIL: $description (should not be tagged as verb)"
        echo "  Got: $output"
        ((fail++))
    else
        echo "PASS: $description"
        ((pass++))
    fi
}

# -ing suffix
assert_verb "running is a verb"     "running"
assert_verb "jumping is a verb"     "jumping"
assert_verb "eating is a verb"      "eating"

# -ed suffix
assert_verb "jumped is a verb"      "jumped"
assert_verb "walked is a verb"      "walked"
assert_verb "painted is a verb"     "painted"

# -ize/-ise suffix
assert_verb "organize is a verb"    "organize"
assert_verb "realise is a verb"     "realise"

# -ify suffix
assert_verb "simplify is a verb"    "simplify"
assert_verb "clarify is a verb"     "clarify"

# re- prefix
assert_verb "rebuild is a verb"     "rebuild"
assert_verb "restart is a verb"     "restart"

# From "the tree felt quickly into the ground"
assert_pos "felt is a verb in 'the tree felt quickly into the ground'" \
    "the tree felt quickly into the ground" "felt" "verb"

# From "Moby Dick is a classic story about challenges and obsession."
assert_pos "about is not a verb after noun in 'Moby Dick is a classic story about challenges and obsession.'" \
    "Moby Dick is a classic story about challenges and obsession." "about" "preposition"

# -ing word following a verb
assert_pos "-ing word after verb in 'keep running'" \
    "keep running" "running" "verb"
assert_pos "-ing word after verb in 'start eating'" \
    "start eating" "eating" "verb"

# From "The only person you are destined to become is the person you decide to be."
assert_pos "are is a verb in 'The only person you are destined to become is the person you decide to be.'" \
    "The only person you are destined to become is the person you decide to be." "are" "verb"
assert_pos "decide is a verb in 'The only person you are destined to become is the person you decide to be.'" \
    "The only person you are destined to become is the person you decide to be." "decide" "verb"
assert_pos "become is a verb in 'The only person you are destined to become is the person you decide to be.'" \
    "The only person you are destined to become is the person you decide to be." "become" "verb"
assert_pos "be is a verb in 'The only person you are destined to become is the person you decide to be.'" \
    "The only person you are destined to become is the person you decide to be." "be" "verb"

# Non-verbs
assert_not_verb "and is not a verb"      "and"
assert_not_verb "quickly is not a verb"  "quickly"
assert_not_verb "freedom is not a verb"  "freedom"

echo ""
echo "Results Verbs: $pass passed, $fail failed"
[ $fail -eq 0 ]
