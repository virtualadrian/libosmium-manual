
# Osmium Library Manual

http://osmcode.org/libosmium-manual/

This is the manual for the [Osmium Library](http://osmcode.org/libosmium/). It
contains a more high level overview and tutorial style documentation. For the
details you should also look at the API documentation generated automatically
from the source code with Doxygen.

The manual is written using an extended version of the Markdown syntax as
understood by the Pandoc tool. It can be converted into HTML, PDF, Docbook and
other formats.

## Requirements

    Pandoc
    http://johnmacfarlane.net/pandoc/
    Debian/Ubuntu package: pandoc

## Building

A Makefile is provided that creates different versions of the manual.

Makefile targets:

* html: One HTML file for each chapter in the 'html' directory.
  There are no links between chapters in this version.
* singlehtml: A single HTML file 'out/libosmium-manual.html'.
* pdf: One self-contained PDF file 'out/libosmium-manual.pdf'.
* epub: One self-contained EPUB file 'out/libosmium-manual.epub'.
* docbookhtml: One HTML page per chapter with links between
  chapters.

## Docbook

Pandoc can generate a Docbook version of the manual that can then be
transformed into lots of different formats.

To build the 'docbookhtml' version, you need some components:

Debian packages: xmlto xmllint docbook5-xml docbook-xsl-ns

## License

This manual is available under the Creative Commons Attribution-ShareAlike
License version 4.0 (http://creativecommons.org/licenses/by-sa/4.0/).

## Author

Jochen Topf (jochen@topf.org)

