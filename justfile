# variables
input := "slides.md"
output := "index.html"
options := "defaults.yaml"
target := "website"
theme := "theme.css"
template := "template.html"
home_dir := env_var('HOME')
pandoc_dir := join(home_dir, ".local/share/pandoc")
release_url := "https://github.com/pandoc/lua-filters/releases/latest"

# Construct slide from markdown
build:
  mkdir -p {{target}}
  rsync --archive --verbose --checksum fonts {{target}}/
  rsync --archive --verbose --checksum images {{target}}/
  rsync --archive --verbose --checksum theme.css {{target}}/
  pandoc \
    --defaults {{options}} \
    --output {{target}}/{{output}} \
    {{input}}

watch:
  fswatch -0 --one-per-batch --recursive --latency 5 {{input}} {{options}} {{theme}} {{template}} justfile fonts images | xargs -0 -I {} just build

install_filters:
  curl -LSs {{release_url}}/download/lua-filters.tar.gz | tar --strip-components=1 --one-top-level={{pandoc_dir}} -zvxf -

install:
  asdf install
  just install_filters

clean:
  rm -fr website