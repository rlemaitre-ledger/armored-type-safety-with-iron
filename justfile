build:
  pandoc \
    -t revealjs \
    -s \
    -L revealjs-codeblock.lua \
    --template template.html \
    --variable width:1920 \
    --variable height:1080 \
    --variable highlightjs \
    --variable highlightjs-theme:zenburn \
    --variable navigationMode:linear \
    -o index.html \
    slides.md

watch:
  fswatch --one-per-batch --recursive --latency 5 . | xargs -n1 -I {} just build