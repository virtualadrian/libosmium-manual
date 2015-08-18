
# OSM Files

Most programs using OSM data will need to read from OSM files and/or write to
OSM files. Osmium supports several different OSM file formats:

**XML**
:   The original XML-based OSM format. This format is rather verbose and
    working with it is slow, but it is still used often and in some
    cases there is no alternative. The main OSM database API also returns
    its data in this format. More information about this format on the
    [OSM Wiki](http://wiki.openstreetmap.org/wiki/OSM_XML).

**PBF**
:   The binary format based on the Protobuf library. This is the most compact
    format. More information on the
    [OSM Wiki](http://wiki.openstreetmap.org/wiki/PBF_Format).

**OPL**
:   A simple format similar to CSV-files with one OSM entity per line. This
    format is intended for easy use with standard UNIX command line tools such
    as `grep`, `cut`, and `awk`. See the [OPL File Format
    Manual](http://docs.osmcode.org/opl-file-format-manual/) for details.

**DEBUG**
:   A nicely formatted text-based format that is easier to read for a human
    than the XML or OPL formats. As the name implies this is intended for
    debugging. The format can only be written by Osmium, not read.

See below for more detailed descriptions.

## Accessing Files

Usally Osmium-based programs will allow you to tell them the _name_ of an
input or output file and, optionally a _format description_. Osmium detects
the format of a file from the file name suffix, so usually you do not have
to set the format manually.

Osmium knows about the following suffixes:

Format  Suffix    Description
------- -------   ------------
XML     .osm      Normal XML file, but can also be one with history
XML     .osh      XML with history
XML     .osc      XML change file
PBF     .pbf      PBF
OPL     .opl      OPL
DEBUG   .debug    DEBUG

You can stack formats: `.osm.pbf` is the same as `.pbf`, `.osh.pbf` is a
history file in PBF format.

The change file format (`.osc`) is only available in the XML version, use
`.osh` instead for other formats.

Osmium supports compression and decompression of XML, OPL, and DEBUG files
internally using the GZIP and BZIP2 formats. As usual, these files have an
additional suffix `.gz`, or `.bz2`.

So a typical PBF file will be named `planet.pbf`, a packed history file could
be named `history.osh.bz2`.

If the file name does not end in the suffix needed for autodetection, you
have to supply a format string to Osmium describing the format. Just use
the suffix the file name would have as a format string:

File name: `foobar`, Format: `.osm.opl`

This is needed most often when referring to STDIN or STDOUT. To refer to
STDIN or STDOUT use an empty filename or a single hyphen (`-`).

File name: `-`, Format: `.osm.pbf`

## File Format Options

Some file formats allow different options to be set. Options follow in a
comma-separated list after the file name format. So, for instance, the PBF
format allows two different ways of writing nodes to the file, by default
the _dense_ format is used, but you can disable it like this:

File name: `foo.pbf`, Format: `.pbf,pbf_dense_nodes=false`

Note that, if a format is given, it always must start with the format
description, even if the file name has the correct suffix.

Here is a list of optional settings currently supported:

Format  Option             Default  Description
------- -------            -------- ------------
PBF     pbf_dense_nodes    true     Use DenseNodes (more space efficient)
PBF     pbf_compression    gzip     Compress blocks using gzip (use "none" to disable)
XML     xml_change_format  false    Set change format, can also be set by using `osc` instead of `osm` suffix
XML     force_visible_flag false    Write out `visible` flag on each object, also set if `osh` instead of `osm` suffix used
all     add_metadata       true     Add metadata (version, timestamp, etc. to objects)


## XML

There are several different XML formats in use in the OSM project. The main
formats are the one used for planet files, extracts, and API responses (suffix
`.osm`), the format used for change files (suffix `.osc`) and the history
format (suffixes `.osm` or `.osh`).

Some variants are also used, such as the JOSM format which is similiar to the
normal OSM format but has some additions. Support for the features of these
formats varies.

When reading, the OSM change format (`.osc`) is detected automatically. When
writing, you have to set it using the format specifier `osc` or the format
parameter `xml_change_format=true`.


### PBF

The [PBF](http://wiki.openstreetmap.org/wiki/PBF_Format) file format is based
on the [Google Protocol Buffers library](http://code.google.com/p/protobuf/).
PBF files are very space efficient and faster to use than XML files. PBF files
can contain normal OSM data or OSM history data, but there is no equivalent to
the XML .osc format.

Osmium supports reading and writing of nodes in *DenseNodes* and non-*DenseNodes*
formats. Default is *DenseNodes*, as this is much more space-efficient. Add the
format parameter `pbf_dense_nodes=false` to disable *DenseNodes*.

Osmium usually will compress PBF blocks using zlib. To disable this, use the
format parameter `pbf_compression=none`.

PBF files contain a string table in each data block. Some programs sort this
string table for slightly better compression. Osmium does not do this to make
writing of PBF files faster.

Usually PBF files contain all the metadata for objects such as changeset id,
username, etc. To save some space you can disable writing of metatdata with the
format option `add_metadata=false`.


### OPL ("Object Per Line") Format

See the [OPL File Format Manual](http://docs.osmcode.org/opl-file-format-manual/).


### DEBUG Format

