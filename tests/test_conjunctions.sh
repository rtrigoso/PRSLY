#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_POS="$SCRIPT_DIR/../app/run_pos.awk"

pass=0
fail=0

assert_conjunction() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "conjunction"'; then
        echo "PASS: $description"
        ((pass++))
    else
        echo "FAIL: $description"
        echo "  Expected: $word -> conjunction"
        echo "  Got:      $output"
        ((fail++))
    fi
}

assert_not_conjunction() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "conjunction"'; then
        echo "FAIL: $description (should not be tagged as conjunction)"
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

# Coordinating conjunctions
assert_conjunction "and is a conjunction"     "and"
assert_conjunction "but is a conjunction"     "but"
assert_conjunction "or is a conjunction"      "or"
assert_conjunction "nor is a conjunction"     "nor"
assert_conjunction "yet is a conjunction"     "yet"
assert_conjunction "so is a conjunction"      "so"

# Subordinating conjunctions
assert_conjunction "although is a conjunction"    "although"
assert_conjunction "because is a conjunction"     "because"
assert_conjunction "unless is a conjunction"      "unless"
assert_conjunction "while is a conjunction"       "while"
assert_conjunction "if is a conjunction"          "if"
assert_conjunction "when is a conjunction"        "when"

# Conjunctive adverbs
assert_conjunction "however is a conjunction"     "however"
assert_conjunction "therefore is a conjunction"   "therefore"
assert_conjunction "moreover is a conjunction"    "moreover"
assert_conjunction "nevertheless is a conjunction" "nevertheless"
assert_conjunction "furthermore is a conjunction" "furthermore"
assert_conjunction "thus is a conjunction"        "thus"
assert_conjunction "hence is a conjunction"       "hence"

# Correlative conjunctions
assert_conjunction "either is a conjunction"  "either"
assert_conjunction "both is a conjunction"    "both"

# From "The only person you are destined to become is the person you decide to be."
assert_pos "decide is not a conjunction in 'The only person you are destined to become is the person you decide to be.'" \
    "The only person you are destined to become is the person you decide to be." "decide" "verb"

# From "Moby Dick is a classic story about challenges and obsession."
assert_pos "and is a conjunction in 'Moby Dick is a classic story about challenges and obsession.'" \
    "Moby Dick is a classic story about challenges and obsession." "and" "conjunction"

# Non-conjunctions
assert_not_conjunction "dog is not a conjunction"   "dog"
assert_not_conjunction "run is not a conjunction"   "run"
assert_not_conjunction "quick is not a conjunction" "quick"

echo ""
echo "Results Conjunctions: $pass passed, $fail failed"
[ $fail -eq 0 ]
