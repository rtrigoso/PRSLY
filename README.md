# parsley

Lightweight part-of-speech tagger written purely in AWK, with cross-distro packaging (deb, rpm, XBPS, PKGBUILD, Homebrew) and CI/CD via GitHub Actions.

## Overview

**parsley** is a command-line tool that parses sentences and categorizes each word as a part of speech: nouns, verbs, adjectives, adverbs, pronouns, prepositions, conjunctions, and more. It is written entirely in `awk`, with no external runtime dependencies, making it fast, portable, and easy to embed in scripts or pipelines.

This tool exists as a pushback against the growing habit of reaching for AI to solve problems that do not warrant it. Tasks like part-of-speech tagging are well-understood, deterministic, and cheap to implement with the right tool. Offloading them to large language models wastes compute, energy, and infrastructure that could be directed at genuinely hard problems. parsley is a reminder that clever, purpose-built solutions still matter.

## Features

- Identifies parts of speech: nouns, verbs, adjectives, adverbs, pronouns, conjunctions, prepositions, determiners, auxiliaries, and interjections
- Multi-pass classification using left and right neighbour context
- Written in pure AWK with no interpreter, no runtime, and no dependencies
- Distributed as native packages for major Linux distros and macOS
- Bash-based test suite
- Makefile-driven workflow for building, testing, and installing

## Installation

### macOS via Homebrew

```sh
brew tap your-username/parsley
brew install parsley
```

### Debian and Ubuntu

```sh
sudo dpkg -i parsley_<version>_amd64.deb
```

### Fedora and RHEL

```sh
sudo rpm -i parsley-<version>.x86_64.rpm
```

### Void Linux via XBPS

```sh
sudo xbps-install parsley
```

### Arch Linux via PKGBUILD

```sh
git clone https://aur.archlinux.org/parsley.git
cd parsley
makepkg -si
```

## Usage

```sh
parsley [WORD ...]
```

Pass the sentence as arguments. If no arguments are given, input is read from stdin.

### Examples

```sh
# Analyze a sentence
parsley The quick brown fox jumps over the lazy dog

# Single word lookup
parsley running

# Pipe input
echo "she runs quickly" | parsley
```

### Sample Output

```json
[
  {"word": "The", "pos": "determiner", "score": 0.5101, "certainty": 100},
  {"word": "quick", "pos": "adjective", "score": 0.3660, "certainty": 69},
  {"word": "brown", "pos": "adjective", "score": 0.3660, "certainty": 69},
  {"word": "fox", "pos": "noun", "score": 0.5101, "certainty": 57},
  {"word": "jumps", "pos": "verb", "score": 0.6306, "certainty": 80},
  {"word": "over", "pos": "preposition", "score": 0.7575, "certainty": 55},
  {"word": "the", "pos": "determiner", "score": 0.5101, "certainty": 100},
  {"word": "lazy", "pos": "adjective", "score": 0.3660, "certainty": 69},
  {"word": "dog", "pos": "noun", "score": 0.5101, "certainty": 100}
]
```

Each entry includes:
- `word` — the original token
- `pos` — the assigned part of speech
- `score` — the Wilson score lower bound for this classification (see below)
- `certainty` — the winning score as a percentage of the sum of all Wilson scores

## How It Works

Classification runs in three passes over the input words:

1. **Pass 1** — score each word using only left-context labels (previous one or two words)
2. **Pass 2** — re-score any `unknown` words using the nearest resolved left and right neighbours from pass 1
3. **Pass 3** — re-score any remaining unknowns using pass-2 resolved neighbours
4. **Output pass** — re-run final scoring with fully resolved neighbour labels to produce display output

### Scoring with the Wilson Score Interval

Each part-of-speech category accumulates two counters as rules fire against a word: positive evidence (signals that support that category) and negative evidence (signals that argue against it). The final score for each category is the **lower bound of the Wilson score confidence interval** for a Bernoulli parameter:

```
p̂ = pos / (pos + neg)
score = (p̂ + z²/2n − z·√(p̂(1−p̂)/n + z²/4n²)) / (1 + z²/n)
```

where `n = pos + neg` and `z = 1.96` (95% confidence). The result is a value in [0, 1].

The Wilson lower bound gives more meaningful scores than a raw net sum because it accounts for how much evidence exists, not just which side leads. A category supported by four strong signals and opposed by none scores higher than one supported by a single signal with no opposition — even if both have the same net count. Words with little evidence (few matching rules) receive a lower floor, which naturally expresses uncertainty rather than false confidence.

The category with the highest Wilson score wins and is assigned as `pos`. Auxiliaries (`is`, `was`, `will`, etc.) bypass scoring entirely and are assigned with `score: 1.0000, certainty: 100`.

## Manual

The man page is written in Markdown and converted to `roff` format using [pandoc](https://pandoc.org):

```sh
make man
```

To view it locally:

```sh
man ./parsley.1
```

## Building from Source

### Prerequisites

- `awk`
- `make`
- `pandoc` (for man page generation)

### Build

```sh
make build
```

## Testing

Tests are written as Bash scripts located in the `tests/` directory.

```sh
make test
```

Individual test files can be run directly:

```sh
bash tests/test_nouns.sh
bash tests/test_verbs.sh
```

## Makefile Targets

| Target       | Description                               |
|--------------|-------------------------------------------|
| `make build` | Prepares the AWK script for distribution |
| `make man`   | Converts the Markdown man page to roff   |
| `make test`  | Runs the full test suite                 |
| `make clean` | Removes build artifacts                  |
| `make lint`  | Lints the AWK source                     |
| `make deb`   | Builds a `.deb` package                  |
| `make rpm`   | Builds an `.rpm` package                 |

## CI/CD

Releases and packages are built and published automatically via **GitHub Actions**.

| Workflow      | Trigger                    | Description                                              |
|---------------|----------------------------|----------------------------------------------------------|
| `test.yml`    | Push or PR                 | Runs the full test suite                                 |
| `release.yml` | Tag push `v*`              | Creates a GitHub Release, builds and uploads `.deb` and `.rpm` packages |
| `deploy.yml`  | After `release.yml` passes | Deploys to APT, Fedora COPR, Homebrew, and XBPS         |

## Project Structure

```
parsley/
    parsley.awk         Core AWK source (installed as `parsley`)
    parsley.1.md        Man page source (Markdown)
    parsley.1           Generated man page (roff)
    Makefile            Build, install, test, and package targets
    app/
        pos_classifier.awk  Scoring rules for all parts of speech
        run_pos.awk         Multi-pass sentence classifier (executable)
    tests/              Bash test scripts
        test_pronouns.sh
        test_conjunctions.sh
        test_prepositions.sh
        test_nouns.sh
        test_verbs.sh
    packaging/
        deb/            Debian packaging files
        rpm/            RPM spec file
        PKGBUILD        Arch Linux package script
        xbps/           Void Linux template
    .github/
        workflows/      GitHub Actions CI/CD workflows
```

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-change`
3. Commit your changes: `git commit -m 'Add my change'`
4. Push the branch: `git push origin feature/my-change`
5. Open a pull request

## License

MIT License. See [LICENSE](./LICENSE) for details.
