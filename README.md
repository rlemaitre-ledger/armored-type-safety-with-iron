# armored-type-safety-with-iron

## Installation

1. Clone this repository
```bash
git clone git@github.com:rlemaitre-ledger/armored-type-safety-with-iron.git
```
2. Install pandoc
```bash
asdf plugin add pandoc https://github.com/Fbrisset/asdf-pandoc.git
asdf pandoc install latest
```
ro
```bash
brew install pandoc
```
3. Run
```bash
pandoc -t revealjs -s -o index.html slides.md -V revealjs-url=https://unpkg.com/reveal.js/ --include-in-header=slides.css -V theme=black
```