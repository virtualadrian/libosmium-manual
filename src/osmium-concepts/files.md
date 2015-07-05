
# OSM files

Osmium supports the following formats:

**XML**
:   The original XML-based OSM format. This format is rather verbose and
    working with it is slow, but it is still used often and in some
    cases there is no alternative. The main OSM database API also returns
    its data in this format. More information about this format on the
    [OSM Wiki](http://wiki.openstreetmap.org/wiki/OSM_XML).

**PBF**
:   The binary format based on the Protobuf library. This is the most compact
    format. More information on the [OSM Wiki](http://wiki.openstreetmap.org/wiki/PBF_Format).

**OPL**
:   A simple format similar to CSV-files with one OSM entity per line. This
    format is intended for easy use with standard UNIX command line tools such
    as `grep`, `cut`, and `awk`.

