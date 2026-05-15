# parsley

Lightweight part-of-speech tagger written purely in AWK, with cross-distro packaging (deb, rpm, XBPS, PKGBUILD, Homebrew) and CI/CD via GitHub Actions.

## Overview

**parsley** is a command-line tool that parses sentences and categorizes each word as a part of speech: nouns, verbs, adjectives, adverbs, pronouns, prepositions, conjunctions, and more. It is written entirely in `awk`, with no external runtime dependencies, making it fast, portable, and easy to embed in scripts or pipelines.

This tool exists as a pushback against the growing habit of reaching for AI to solve problems that do not warrant it. Tasks like part-of-speech tagging are well-understood, deterministic, and cheap to implement with the right tool. Offloading them to large language models wastes compute, energy, and infrastructure that could be directed at genuinely hard problems. parsley is a reminder that clever, purpose-built solutions still matter.

## Features

- Identifies parts of speech: nouns, verbs, adjectives, adverbs, pronouns, conjunctions, prepositions, articles, and interjections
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
parsley [OPTIONS] [FILE | -]
```

### Examples

```sh
# Analyze a sentence from stdin
echo "The quick brown fox jumps over the lazy dog" | parsley

# Analyze a text file
parsley input.txt

# Output in verbose mode
parsley -v input.txt
```

### Sample Output

```
The       article
quick     adjective
brown     adjective
fox       noun
jumps     verb
over      preposition
the       article
lazy      adjective
dog       noun
```

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
- `gawk` (for linting only)

### Build

```sh
make build
```

### Install

```sh
make install
```

### Uninstall

```sh
make uninstall
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

| Target           | Description                               |
|------------------|-------------------------------------------|
| `make build`     | Prepares the AWK script for distribution |
| `make install`   | Installs parsley to `/usr/local/bin`     |
| `make uninstall` | Removes parsley from the system          |
| `make man`       | Converts the Markdown man page to roff   |
| `make test`      | Runs the full test suite                 |
| `make clean`     | Removes build artifacts                  |
| `make lint`      | Lints the AWK source with `gawk`         |
| `make deb`       | Builds a `.deb` package                  |
| `make rpm`       | Builds an `.rpm` package                 |

## CI/CD

Releases and packages are built and published automatically via **GitHub Actions**.

| Workflow               | Trigger       | Description                       |
|------------------------|---------------|-----------------------------------|
| `test.yml`             | Push or PR    | Runs the full test suite          |
| `release.yml`          | Tag push `v*` | Creates a GitHub Release          |
| `package-deb.yml`      | Tag push `v*` | Builds and uploads `.deb` package |
| `package-rpm.yml`      | Tag push `v*` | Builds and uploads `.rpm` package |
| `homebrew-release.yml` | Tag push `v*` | Updates the Homebrew formula      |

## Project Structure

```
parsley/
    parsley.awk         Core AWK source
    parsley.1.md        Man page source (Markdown)
    parsley.1           Generated man page (roff)
    Makefile            Build, install, test, and package targets
    tests/              Bash test scripts
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
