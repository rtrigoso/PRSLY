#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AWK_SCRIPT="$SCRIPT_DIR/../app/conjunctions.awk"

pass=0
fail=0

assert_conjunction() {
    local description="$1"
    local word="$2"
    local output
    output=$(echo "$word" | awk -f "$AWK_SCRIPT")
    if echo "$output" | grep -q "^${word}[[:space:]]*conjunction"; then
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
    output=$(echo "$word" | awk -f "$AWK_SCRIPT")
    if echo "$output" | grep -q "^${word}[[:space:]]*conjunction"; then
        echo "FAIL: $description (should not be tagged as conjunction)"
        echo "  Got: $output"
        ((fail++))
    else
        echo "PASS: $description"
        ((pass++))
    fi
}

# Coordinating conjunctions (FANBOYS)
assert_conjunction "for is a conjunction"     "for"
assert_conjunction "and is a conjunction"     "and"
assert_conjunction "nor is a conjunction"     "nor"
assert_conjunction "but is a conjunction"     "but"
assert_conjunction "or is a conjunction"      "or"
assert_conjunction "yet is a conjunction"     "yet"
assert_conjunction "so is a conjunction"      "so"

# Subordinating conjunctions
assert_conjunction "although is a conjunction"  "although"
assert_conjunction "because is a conjunction"   "because"
assert_conjunction "since is a conjunction"     "since"
assert_conjunction "unless is a conjunction"    "unless"
assert_conjunction "until is a conjunction"     "until"
assert_conjunction "while is a conjunction"     "while"
assert_conjunction "after is a conjunction"     "after"
assert_conjunction "before is a conjunction"    "before"
assert_conjunction "if is a conjunction"        "if"
assert_conjunction "though is a conjunction"    "though"
assert_conjunction "whether is a conjunction"   "whether"
assert_conjunction "as is a conjunction"        "as"
assert_conjunction "once is a conjunction"      "once"
assert_conjunction "when is a conjunction"      "when"
assert_conjunction "where is a conjunction"     "where"
assert_conjunction "than is a conjunction"      "than"
assert_conjunction "lest is a conjunction"      "lest"

# Correlative conjunctions
assert_conjunction "both is a conjunction"      "both"
assert_conjunction "either is a conjunction"    "either"
assert_conjunction "neither is a conjunction"   "neither"
assert_conjunction "not is a conjunction"       "not"

# Non-conjunctions
assert_not_conjunction "dog is not a conjunction"   "dog"
assert_not_conjunction "run is not a conjunction"   "run"
assert_not_conjunction "quick is not a conjunction" "quick"

echo ""
echo "Results: $pass passed, $fail failed"
[ $fail -eq 0 ]
