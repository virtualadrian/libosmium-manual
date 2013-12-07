#
#  Makefile for Osmium manual.
#

PANDOC := pandoc

MD_FILES := \
    src/introduction.md \
    src/compiling.md \
    src/basic-types.md \
    src/osm-objects.md \
    src/buffers.md \
    src/input-and-output.md	\
    src/iterators.md \
    src/visitors-and-handlers.md \
    src/storage.md

HTML_FILES := $(patsubst src/%.md,html/%.html,$(MD_FILES))

all: html singlehtml

# -----------------------------------------------------

.PHONY: docbook docbookhtml epub html singlehtml pdf

docbook: tmp/libosmium-manual.xml

docbookhtml: docbookhtml/index.html docbookhtml/manual.css

epub: out/libosmium-manual.epub

html: $(HTML_FILES) html/manual.css

singlehtml: out/libosmium-manual.html out/manual.css

pdf: out/libosmium-manual.pdf

# -----------------------------------------------------

# Concatenation of all markdown files
tmp/libosmium-manual.md: header.md $(MD_FILES)
	mkdir -p tmp
	cat header.md $(MD_FILES) >$@

# PDF version
out/libosmium-manual.pdf: tmp/libosmium-manual.md
	mkdir -p out
	$(PANDOC) --number-sections --toc --standalone -V geometry:margin=1.5cm -o $@ $<

# EPUB version
out/libosmium-manual.epub: tmp/libosmium-manual.md
	mkdir -p out
	$(PANDOC) --number-sections --toc --standalone --epub-metadata=metadata.xml -o $@ $<

# Docbook version
tmp/libosmium-manual.xml: tmp/libosmium-manual.md
	mkdir -p tmp
	$(PANDOC) --standalone -t docbook -o $@ $<

# Single HTML file
out/libosmium-manual.html: tmp/libosmium-manual.md
	mkdir -p out
	$(PANDOC) --number-sections --standalone --toc --css=manual.css -o $@ $<

# Chunked HTML via Docbook
docbookhtml/index.html: tmp/libosmium-manual.xml
	mkdir -p docbookhtml
	xmlto xhtml -m custom-html-chunk.xsl $< -o docbookhtml/

docbookhtml/manual.css: docbookhtml.css
	mkdir -p docbookhtml
	cp $< $@

# Multiple HTML files
html/%.html: src/%.md
	mkdir -p html
	$(PANDOC) --standalone --css=manual.css -o $@ $<

html/manual.css: manual.css
	mkdir -p html
	cp $< $@

out/manual.css: manual.css
	mkdir -p html
	cp $< $@

clean:
	rm -f docbookhtml/* html/* out/* tmp/*

