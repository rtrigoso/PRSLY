# PRSLY

Lightweight part-of-speech tagger written purely in AWK, with cross-distro packaging (deb, rpm, XBPS, PKGBUILD, Homebrew) and CI/CD via GitHub Actions.

## Overview

**prsly** is a command-line tool that parses sentences and categorizes each word as a part of speech: nouns, verbs, adjectives, adverbs, pronouns, prepositions, conjunctions, and more. It is written entirely in `awk`, with no external runtime dependencies, making it fast, portable, and easy to embed in scripts or pipelines.

This tool exists as a pushback against the growing habit of reaching for AI to solve problems that do not warrant it. Tasks like part-of-speech tagging are well-understood, deterministic, and cheap to implement with the right tool. Offloading them to large language models wastes compute, energy, and infrastructure that could be directed at genuinely hard problems. prsly is a reminder that clever, purpose-built solutions still matter.

## Features

- Identifies parts of speech: nouns, verbs, adjectives, adverbs, pronouns, conjunctions, prepositions, determiners, auxiliaries, and interjections
- Bidirectional iterative classification that converges on stable labels
- Written in pure AWK with no interpreter, no runtime, and no dependencies
- Distributed as native packages for major Linux distros and macOS
- Bash-based test suite
- Makefile-driven workflow for building, testing, and installing

## Installation

### macOS via Homebrew

```sh
brew tap your-username/prsly
brew install prsly
```

### Debian and Ubuntu

```sh
sudo dpkg -i prsly_<version>_amd64.deb
```

### Fedora and RHEL

```sh
sudo rpm -i prsly-<version>.x86_64.rpm
```

### Void Linux via XBPS

```sh
sudo xbps-install prsly
```

### Arch Linux via PKGBUILD

```sh
git clone https://aur.archlinux.org/prsly.git
cd prsly
makepkg -si
```

## Usage

```sh
prsly [WORD ...]
```

Pass the sentence as arguments. If no arguments are given, input is read from stdin.

### Examples

```sh
# Analyze a sentence
prsly the dog barked loudly

# Single word lookup
prsly running

# Pipe input
echo "She quietly reads every morning" | prsly
```

### Sample Output

```json
[
  {"word": "She", "pos": "pronoun", "certainty": 0.5101},
  {"word": "quietly", "pos": "adverb", "certainty": 0.5655},
  {"word": "reads", "pos": "verb", "certainty": 0.6457},
  {"word": "every", "pos": "noun", "certainty": 0.4385},
  {"word": "morning", "pos": "verb", "certainty": 0.6457}
]
```

Each entry includes:
- `word` — the original token
- `pos` — the assigned part of speech
- `certainty` — the Wilson score lower bound for the winning category, in the range [0, 1]

## How It Works

Classification runs in three stages:

1. **Bootstrap pass** — score each word left-to-right using only left-context labels (previous one or two words), establishing initial labels with no right-context bias
2. **Bidirectional convergence loop** — alternate a forward (left-to-right) and backward (right-to-left) sweep, updating any word whose certainty improves or whose label was `unknown`, until no labels change or a maximum of 10 iterations is reached
3. **Output pass** — re-run each word with its fully resolved neighbours to produce the final JSON output

Trailing punctuation (`.`, `!`, `?`) is stripped from each token before classification. Sentence-ending punctuation also resets context so the following word is not influenced by the previous sentence.

### Scoring with the Wilson Score Interval

Each part-of-speech category accumulates two counters as rules fire against a word: positive evidence (signals that support that category) and negative evidence (signals that argue against it). The final score for each category is the **lower bound of the Wilson score confidence interval** for a Bernoulli parameter:

```
p̂ = pos / (pos + neg)
score = (p̂ + z²/2n − z·√(p̂(1−p̂)/n + z²/4n²)) / (1 + z²/n)
```

where `n = pos + neg` and `z = 1.96` (95% confidence). The result is a value in [0, 1].

The Wilson lower bound gives more meaningful scores than a raw net sum because it accounts for how much evidence exists, not just which side leads. A category supported by four strong signals and opposed by none scores higher than one supported by a single signal with no opposition — even if both have the same net count. Words with little evidence (few matching rules) receive a lower floor, which naturally expresses uncertainty rather than false confidence.

The category with the highest Wilson score wins and is assigned as `pos`. Auxiliaries (`is`, `was`, `will`, etc.) bypass scoring entirely and are assigned with `certainty: 1.0000`.

## Manual

The man page is written in Markdown and converted to `roff` format using [pandoc](https://pandoc.org):

```sh
make man
```

To view it locally:

```sh
man ./prsly.1
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
| `make build` | Bundles the AWK source into the binary   |
| `make man`   | Converts the Markdown man page to roff   |
| `make test`  | Runs the full test suite                 |
| `make clean` | Removes build artifacts                  |
| `make lint`  | Lints the AWK source                     |

## CI/CD

Releases and packages are built and published automatically via **GitHub Actions**.

| Workflow      | Trigger                    | Description                                              |
|---------------|----------------------------|----------------------------------------------------------|
| `test.yml`    | Push or PR                 | Runs the full test suite                                 |
| `release.yml` | Tag push `v*`              | Creates a GitHub Release, builds and uploads `.deb` and `.rpm` packages |
| `deploy.yml`  | After `release.yml` passes | Deploys to APT, Fedora COPR, Homebrew, and XBPS         |

## Project Structure

```
prsly/
    prsly.awk         Core AWK source (installed as `prsly`)
    prsly.1.md        Man page source (Markdown)
    prsly.1           Generated man page (roff)
    Makefile            Build, install, test, and package targets
    app/
        pos_classifier.awk  Scoring rules for all parts of speech
        run_pos.awk         Bidirectional iterative sentence classifier (executable)
    tests/              Bash test scripts
        test_pronouns.sh
        test_conjunctions.sh
        test_prepositions.sh
        test_nouns.sh
        test_verbs.sh
        test_adjectives.sh
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
