#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_POS="$SCRIPT_DIR/../app/run_pos.awk"

pass=0
fail=0

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

# Non-verbs
assert_not_verb "and is not a verb"      "and"
assert_not_verb "quickly is not a verb"  "quickly"
assert_not_verb "freedom is not a verb"  "freedom"

echo ""
echo "Results Verbs: $pass passed, $fail failed"
[ $fail -eq 0 ]
