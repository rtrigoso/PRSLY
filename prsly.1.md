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

Classification runs in three stages. A bootstrap pass scores each word left-to-right using only left-context labels. A bidirectional convergence loop then alternates forward and backward sweeps, updating any word whose certainty improves or whose label was unknown, until labels stabilise. A final output pass re-scores each word with its fully resolved neighbours to produce the JSON result.

Each word is scored across nine categories using the Wilson score lower bound for a Bernoulli parameter. The category with the highest score wins. Auxiliary verbs bypass scoring and are assigned directly with certainty 1.0.

Output is a JSON array, one object per word, printed to standard output.

# OUTPUT FORMAT

Each element of the JSON array contains three fields:

**word**
: The token after stripping trailing punctuation (`.`, `!`, `?`, etc.).

**pos**
: The assigned part of speech. One of: *noun*, *pronoun*, *verb*, *auxiliary*, *adjective*, *adverb*, *preposition*, *conjunction*, *interjection*, *determiner*, or *unknown*.

**certainty**
: The Wilson score lower bound for the winning category, in the range [0, 1]. Higher values indicate stronger morphological or positional evidence.

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
  {"word": "She", "pos": "pronoun", "certainty": 0.5101},
  {"word": "quietly", "pos": "adverb", "certainty": 0.5655},
  {"word": "reads", "pos": "verb", "certainty": 0.6457},
  {"word": "every", "pos": "noun", "certainty": 0.4385},
  {"word": "morning", "pos": "verb", "certainty": 0.6457}
]
```

# EXIT STATUS

**0**
: Classification completed successfully.

**1**
: No input was provided (no arguments and nothing on standard input).

# AUTHOR

Renzo Trigoso
