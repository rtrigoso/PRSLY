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

# Predicate adjective after auxiliary: "is green"
assert_pos "green is an adjective in 'my favorite color is green'" \
    "my favorite color is green" "green" "adjective"

# Attributive adjective between possessive pronoun and noun
assert_pos "favorite is an adjective in 'my favorite color is green'" \
    "my favorite color is green" "favorite" "adjective"

# Adverb -ly should not be misclassified as adjective -ly
assert_pos "quickly is an adverb in 'the tree felt quickly into the ground'" \
    "the tree felt quickly into the ground" "quickly" "adverb"

# Morphological adjective suffixes
assert_pos "beautiful is an adjective in 'she is beautiful'"  "she is beautiful"  "beautiful"  "adjective"
assert_pos "careful is an adjective in 'he is careful'"       "he is careful"     "careful"    "adjective"
assert_pos "helpless is an adjective in 'it is helpless'"     "it is helpless"    "helpless"   "adjective"
assert_pos "famous is an adjective in 'she is famous'"        "she is famous"     "famous"     "adjective"

# From "The only person you are destined to become is the person you decide to be."
assert_pos "only is an adjective in 'The only person you are destined to become is the person you decide to be.'" \
    "The only person you are destined to become is the person you decide to be." "only" "adjective"

# From "Moby Dick is a classic story about challenges and obsession."
assert_pos "classic is an adjective in 'Moby Dick is a classic story about challenges and obsession.'" \
    "Moby Dick is a classic story about challenges and obsession." "classic" "adjective"

# From "I love how sparkling water makes my tongue tingle."
assert_pos "sparkling is an adjective in 'I love how sparkling water makes my tongue tingle.'" \
    "I love how sparkling water makes my tongue tingle." "sparkling" "adjective"
assert_pos "how is an adverb in 'I love how sparkling water makes my tongue tingle.'" \
    "I love how sparkling water makes my tongue tingle." "how" "adverb"

echo ""
echo "Results - Adjectives: $pass passed, $fail failed"
[ $fail -eq 0 ]
