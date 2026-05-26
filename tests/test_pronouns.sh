#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_POS="$SCRIPT_DIR/../app/run_pos.awk"

pass=0
fail=0

assert_pronoun() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "pronoun"'; then
        echo "PASS: $description"
        ((pass++))
    else
        echo "FAIL: $description"
        echo "  Expected: $word -> pronoun"
        echo "  Got:      $output"
        ((fail++))
    fi
}

assert_not_pronoun() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "pronoun"'; then
        echo "FAIL: $description (should not be tagged as pronoun)"
        echo "  Got: $output"
        ((fail++))
    else
        echo "PASS: $description"
        ((pass++))
    fi
}

# Personal pronouns (subject)
assert_pronoun "I is a pronoun"    "I"
assert_pronoun "he is a pronoun"   "he"
assert_pronoun "she is a pronoun"  "she"
assert_pronoun "it is a pronoun"   "it"
assert_pronoun "we is a pronoun"   "we"
assert_pronoun "they is a pronoun" "they"
assert_pronoun "you is a pronoun"  "you"

# Personal pronouns (object)
assert_pronoun "me is a pronoun"   "me"
assert_pronoun "him is a pronoun"  "him"
assert_pronoun "her is a pronoun"  "her"
assert_pronoun "us is a pronoun"   "us"
assert_pronoun "them is a pronoun" "them"

# Possessive pronouns (adjective form)
assert_pronoun "my is a pronoun"    "my"
assert_pronoun "your is a pronoun"  "your"
assert_pronoun "his is a pronoun"   "his"
assert_pronoun "its is a pronoun"   "its"
assert_pronoun "our is a pronoun"   "our"
assert_pronoun "their is a pronoun" "their"

# Reflexive pronouns
assert_pronoun "myself is a pronoun"     "myself"
assert_pronoun "yourself is a pronoun"   "yourself"
assert_pronoun "himself is a pronoun"    "himself"
assert_pronoun "herself is a pronoun"    "herself"
assert_pronoun "itself is a pronoun"     "itself"
assert_pronoun "ourselves is a pronoun"  "ourselves"
assert_pronoun "themselves is a pronoun" "themselves"

# Relative/interrogative pronouns
assert_pronoun "who is a pronoun"   "who"
assert_pronoun "whom is a pronoun"  "whom"
assert_pronoun "whose is a pronoun" "whose"
assert_pronoun "which is a pronoun" "which"
assert_pronoun "that is a pronoun"  "that"

# Non-pronouns
assert_not_pronoun "dog is not a pronoun"   "dog"
assert_not_pronoun "run is not a pronoun"   "run"
assert_not_pronoun "quick is not a pronoun" "quick"

echo ""
echo "Results: $pass passed, $fail failed"
[ $fail -eq 0 ]
