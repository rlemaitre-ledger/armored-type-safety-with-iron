# armored-type-safety-with-iron

## Installation

1. Clone this repository
```bash
git clone git@github.com:rlemaitre-ledger/armored-type-safety-with-iron.git
```
2. Install dependencies
```bash
asdf plugin add pandoc https://github.com/Fbrisset/asdf-pandoc.git
asdf install
```
or
```bash
brew install pandoc just
```
You will also need `fswatch` that is not (yet) managed by `asdf`.

On Mac:
```bash
brew install fswatch
```
On ubuntu:
```bash
apt-get install fswatch
```
3. Before the first build
```bash
just install
```
4. Run
```bash
just build
```
To build at each changes on this directory:
```bash
just watch
```

The slides will be in the target directory (`website` by default)
