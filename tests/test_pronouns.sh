#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AWK_SCRIPT="$SCRIPT_DIR/../app/pronouns.awk"

pass=0
fail=0

assert_pronoun() {
    local description="$1"
    local word="$2"
    local output
    output=$(echo "$word" | awk -f "$AWK_SCRIPT")
    if echo "$output" | grep -q "^${word}[[:space:]]*pronoun"; then
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
    output=$(echo "$word" | awk -f "$AWK_SCRIPT")
    if echo "$output" | grep -q "^${word}[[:space:]]*pronoun"; then
        echo "FAIL: $description (should not be tagged as pronoun)"
        echo "  Got: $output"
        ((fail++))
    else
        echo "PASS: $description"
        ((pass++))
    fi
}

# Personal pronouns
assert_pronoun "I is a pronoun"         "I"
assert_pronoun "me is a pronoun"        "me"
assert_pronoun "she is a pronoun"       "she"
assert_pronoun "he is a pronoun"        "he"
assert_pronoun "her is a pronoun"       "her"
assert_pronoun "him is a pronoun"       "him"
assert_pronoun "they is a pronoun"      "they"
assert_pronoun "them is a pronoun"      "them"
assert_pronoun "we is a pronoun"        "we"
assert_pronoun "us is a pronoun"        "us"
assert_pronoun "it is a pronoun"        "it"
assert_pronoun "you is a pronoun"       "you"

# Possessive pronouns
assert_pronoun "my is a pronoun"        "my"
assert_pronoun "mine is a pronoun"      "mine"
assert_pronoun "your is a pronoun"      "your"
assert_pronoun "yours is a pronoun"     "yours"
assert_pronoun "his is a pronoun"       "his"
assert_pronoun "hers is a pronoun"      "hers"
assert_pronoun "its is a pronoun"       "its"
assert_pronoun "our is a pronoun"       "our"
assert_pronoun "ours is a pronoun"      "ours"
assert_pronoun "their is a pronoun"     "their"
assert_pronoun "theirs is a pronoun"    "theirs"

# Reflexive pronouns
assert_pronoun "myself is a pronoun"    "myself"
assert_pronoun "yourself is a pronoun"  "yourself"
assert_pronoun "himself is a pronoun"   "himself"
assert_pronoun "herself is a pronoun"   "herself"
assert_pronoun "itself is a pronoun"    "itself"
assert_pronoun "ourselves is a pronoun" "ourselves"
assert_pronoun "themselves is a pronoun" "themselves"

# Relative/interrogative pronouns
assert_pronoun "who is a pronoun"       "who"
assert_pronoun "whom is a pronoun"      "whom"
assert_pronoun "whose is a pronoun"     "whose"
assert_pronoun "which is a pronoun"     "which"
assert_pronoun "that is a pronoun"      "that"

# Indefinite pronouns
assert_pronoun "everyone is a pronoun"  "everyone"
assert_pronoun "nobody is a pronoun"    "nobody"
assert_pronoun "someone is a pronoun"   "someone"
assert_pronoun "anyone is a pronoun"    "anyone"
assert_pronoun "somebody is a pronoun"  "somebody"
assert_pronoun "everybody is a pronoun" "everybody"
assert_pronoun "anything is a pronoun"  "anything"
assert_pronoun "something is a pronoun" "something"
assert_pronoun "everything is a pronoun" "everything"
assert_pronoun "nothing is a pronoun"   "nothing"
assert_pronoun "each is a pronoun"      "each"
assert_pronoun "either is a pronoun"    "either"
assert_pronoun "neither is a pronoun"   "neither"
assert_pronoun "both is a pronoun"      "both"
assert_pronoun "few is a pronoun"       "few"
assert_pronoun "many is a pronoun"      "many"
assert_pronoun "one is a pronoun"       "one"

# Non-pronouns
assert_not_pronoun "dog is not a pronoun"   "dog"
assert_not_pronoun "run is not a pronoun"   "run"
assert_not_pronoun "quick is not a pronoun" "quick"

echo ""
echo "Results: $pass passed, $fail failed"
[ $fail -eq 0 ]
