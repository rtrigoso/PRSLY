---
title: PRSLY
section: 1
header: User Commands
footer: prsly
date: June 2026
---

# NAME

prsly - part-of-speech tagger written in AWK

# SYNOPSIS

**prsly** [*WORD* ...]

# DESCRIPTION

**prsly** reads a sentence and assigns each word a part-of-speech label. Words may be supplied as command-line arguments or as a single line on standard input.

Classification runs in four passes. The first pass scores each word using only left-context labels. Subsequent passes re-score unresolved words using neighbours resolved in earlier passes. A final pass re-scores low-certainty words once all neighbours are settled.

Each word is scored across nine categories using the Wilson score lower bound for a Bernoulli parameter. The category with the highest score wins. Auxiliary verbs bypass scoring and are assigned directly with a score of 1.0.

Output is a JSON array, one object per word, printed to standard output.

# OUTPUT FORMAT

Each element of the JSON array contains four fields:

**word**
: The token after stripping trailing punctuation (`.`, `!`, `?`, etc.).

**pos**
: The assigned part of speech. One of: *noun*, *pronoun*, *verb*, *auxiliary*, *adjective*, *adverb*, *preposition*, *conjunction*, *interjection*, *determiner*, or *unknown*.

**score**
: The Wilson score lower bound for the winning category, in the range [0, 1]. Higher values indicate stronger morphological or positional evidence.

**certainty**
: The winning score expressed as a percentage of the sum of all category scores. Ranges from 0 to 100.

# EXAMPLES

Analyse a sentence passed as arguments:

```
prsly the dog barked loudly
```

Read a sentence from standard input:

```
echo "She quietly reads every morning" | prsly
```

Look up a single word:

```
prsly running
```

Sample output:

```json
[
  {"word": "the", "pos": "determiner", "score": 0.5101, "certainty": 100},
  {"word": "dog", "pos": "noun", "score": 0.5101, "certainty": 53},
  {"word": "barked", "pos": "verb", "score": 0.7008, "certainty": 100},
  {"word": "loudly", "pos": "adverb", "score": 0.6097, "certainty": 100}
]
```

# EXIT STATUS

**0**
: Classification completed successfully.

**1**
: No input was provided (no arguments and nothing on standard input).

# AUTHOR

Renzo Trigoso
