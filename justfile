# variables
input := "slides.md"
output := "index.html"
options := "defaults.yaml"
pandoc_dir := "~/.local/share/pandoc"
release_url := "https://github.com/pandoc/lua-filters/releases/latest"

# Construct slide from markdown
build:
  pandoc \
    --defaults {{options}} \
    --output {{output}} \
    {{input}}

watch:
  fswatch --one-per-batch --recursive --latency 5 . | xargs -n1 -I {} just build

install:
  asdf install
  curl -LSs {{release_url}}/download/lua-filters.tar.gz | tar --strip-components=1 --one-top-level={{pandoc_dir}} -zvxf -
