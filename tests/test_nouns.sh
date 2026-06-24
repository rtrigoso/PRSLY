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

assert_noun() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "noun"'; then
        echo "PASS: $description"
        ((pass++))
    else
        echo "FAIL: $description"
        echo "  Expected: $word -> noun"
        echo "  Got:      $output"
        ((fail++))
    fi
}

assert_not_noun() {
    local description="$1"
    local word="$2"
    local output
    output=$("$RUN_POS" "$word")
    if echo "$output" | grep -q '"pos": "noun"'; then
        echo "FAIL: $description (should not be tagged as noun)"
        echo "  Got: $output"
        ((fail++))
    else
        echo "PASS: $description"
        ((pass++))
    fi
}

# -tion/-sion suffix
assert_noun "nation is a noun"      "nation"
assert_noun "tension is a noun"     "tension"
assert_noun "solution is a noun"    "solution"

# -ness suffix
assert_noun "happiness is a noun"   "happiness"
assert_noun "darkness is a noun"    "darkness"

# -ment suffix
assert_noun "movement is a noun"    "movement"
assert_noun "statement is a noun"   "statement"

# -ity/-ty suffix
assert_noun "equality is a noun"    "equality"
assert_noun "ability is a noun"     "ability"

# -ance/-ence suffix
assert_noun "distance is a noun"    "distance"
assert_noun "presence is a noun"    "presence"

# -ism/-ist suffix
assert_noun "tourism is a noun"     "tourism"
assert_noun "artist is a noun"      "artist"

# -hood/-ship/-dom suffix
assert_noun "childhood is a noun"   "childhood"
assert_noun "friendship is a noun"  "friendship"
assert_noun "freedom is a noun"     "freedom"

# From "the tree felt quickly into the ground"
assert_pos "tree is a noun in 'the tree felt quickly into the ground'" \
    "the tree felt quickly into the ground" "tree" "noun"
assert_pos "ground is a noun in 'the tree felt quickly into the ground'" \
    "the tree felt quickly into the ground" "ground" "noun"

# From "Moby Dick is a classic story about challenges and obsession."
assert_pos "story is a noun in 'Moby Dick is a classic story about challenges and obsession.'" \
    "Moby Dick is a classic story about challenges and obsession." "story" "noun"
assert_pos "challenges is a noun in 'Moby Dick is a classic story about challenges and obsession.'" \
    "Moby Dick is a classic story about challenges and obsession." "challenges" "noun"
assert_pos "obsession is a noun in 'Moby Dick is a classic story about challenges and obsession.'" \
    "Moby Dick is a classic story about challenges and obsession." "obsession" "noun"

# From "The only person you are destined to become is the person you decide to be."
assert_pos "person is a noun in 'The only person you are destined to become is the person you decide to be.'" \
    "The only person you are destined to become is the person you decide to be." "person" "noun"

# From "I love how sparkling water makes my tongue tingle."
assert_pos "water is a noun in 'I love how sparkling water makes my tongue tingle.'" \
    "I love how sparkling water makes my tongue tingle." "water" "noun"
assert_pos "tongue is a noun in 'I love how sparkling water makes my tongue tingle.'" \
    "I love how sparkling water makes my tongue tingle." "tongue" "noun"

# From "Welcome to the Progress Report for Dolphin Release 2606"
assert_pos "Progress is a noun in 'Welcome to the Progress Report for Dolphin Release 2606'" \
    "Welcome to the Progress Report for Dolphin Release 2606" "Progress" "noun"
assert_pos "Dolphin is a noun in 'Welcome to the Progress Report for Dolphin Release 2606'" \
    "Welcome to the Progress Report for Dolphin Release 2606" "Dolphin" "noun"

# Non-nouns
assert_not_noun "quickly is not a noun"  "quickly"
assert_not_noun "and is not a noun"      "and"

echo ""
echo "Results - Nouns: $pass passed, $fail failed"
[ $fail -eq 0 ]
