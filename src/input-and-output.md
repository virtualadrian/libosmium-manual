# Input and Output

Most programs using OSM data will need to read from OSM files and/or write to
OSM files. Osmium supports several different OSM file formats and has many
different ways of accessing the data in convenient ways.

## File Formats

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

See [Output Formats] for more details about these formats.

## Compression

Osmium supports compression and decompression of XML and OPL files internally
using the GZIP and BZIP2 formats. If you want to use compression you have
to include the right header files and link to the `libz` and `libbz2` libraries,
respectively.

## Headers

Whenever you want to use Osmium to access OSM files you need to include the
right header files and link your program to the right libraries. If you want
to support all the different formats you add

    #include <osmmium/io/any_input.hpp>

and/or

    #include <osmmium/io/any_output.hpp>

to your C++ files. These headers will pull in all the file formats and all
the compression types for input and output, respectively. Usually this is
what you want to use. But if you are sure you don't need all formats or if
you don't have all the libraries needed for all the formats, you can pick
and choose formats and compression types.

If you only need some file formats, you can include any combinations of the
following headers:

    #include <osmmium/io/pbf_input.hpp>
    #include <osmmium/io/xml_input.hpp>

    #include <osmmium/io/pbf_output.hpp>
    #include <osmmium/io/opl_output.hpp>
    #include <osmmium/io/xml_output.hpp>

If you want compression support, you have to add the includes for the different
compression algorithms:

    #include <osmmium/io/gzip_compression.hpp>
    #include <osmmium/io/bzip2_compression.hpp>

Or, if you want both anyway, you can just use the shortcut:

    #include <osmmium/io/any_compression.hpp>

## Output Formats

### XML

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

For read support you need the expat parser library. Link with:

    -lexpat

For write support no special library is needed.

### PBF

The [PBF](http://wiki.openstreetmap.org/wiki/PBF_Format) file format is based
on the [Google Protocol Buffers library](http://code.google.com/p/protobuf/).
PBF files are very space efficient and faster to use than XML files. PBF files
can contain normal OSM data or OSM history data, but there is no equivalent to
the XML .osc format.

The OSM PBF format is defined in [libosmpbf](https://github.com/scrosby/OSM-binary),
you'll probably have to compile and install this yourself before using it in
Osmium.

To build with PBF support, several libraries are needed: libprotobuf-lite contains
the Protocol Buffers library itself which also needs libpthreads, for compression libz
is needed. Those are all standard libraries that should be available on most systems.

To summarize, you need to link with:

    -pthread -lprotobuf-lite -losmpbf -lz

The Google Protocol Buffers library allocates some global buffer memory
which is never freed. You can call the following function in your
code to free these buffers:

    google::protobuf::ShutdownProtobufLibrary();

You do not have to do this, the function is not necessary for the
correct functioning of your program. But if you are using a memory
checker like Valgrind you will get error messages otherwise.

Osmium supports reading and writing of nodes in *DenseNodes* and non-*DenseNodes*
formats. Default is *DenseNodes*, as this is much more space-efficient. Add the
format parameter `pbf_dense_nodes=false` to disable *DenseNodes*.

Osmium usually will compress PBF blocks using zlib. To disable this, use the
format parameter `pbf_compression=none`.

Usually PBF files contain all the metadata for objects such as changeset id,
username, etc. To save some space you can disable writing of metatdata with the
format parameter `pbf_add_metadata=false`.

### OPL Support



## Reading and Writing OSM Files with Osmium

### The osmium::io::File class

Before reading from or writing to an OSM file, you have to instantiate an
object of class osmium::io::File. It encapsulates the file name as well as
any information about the format of the file. In the simplest case the
File class can derive the file format from the file name:

~~~{.cpp}
osmium::io::File input_file("planet.osm.pbf") // PBF format
osmium::io::File input_file("planet.osm.bz2") // XML with bzip2 compression
osmium::io::File input_file("planet.osc.gz")  // XML change file, gzip2 compression
~~~

The constructor of the File class has a second, optional argument giving the
format of the file, which can be used if the format can't be deduced from the
file name. In the simplest form the format argument looks the same as the
usual file suffixes:

~~~{.cpp}
osmium::io::File input_file("somefile", "osm.bz2");
~~~

This setting of the format is often needed when reading from STDIN or
writing to STDOUT. Both an empty string and a single dash as filename
signify STDIN/STDOUT:

~~~{.cpp}
osmium::io::File input_file("-", "osm.bz2");
osmium::io::File output_file("", "pbf");
~~~

The format string can also take optional arguments separated by commas.

~~~{.cpp}
osmium::io::File output_file("out.osm.pbf", "pbf,pbf_dense_nodes=false");
~~~

Here is a list of optional arguments:

Format  Option             Default  Description
------- -------            -------- ------------
PBF     pbf_dense_nodes    true     Use DenseNodes (more space efficient)
PBF     pbf_compression    gzip     Compress blocks using gzip (use "none" to disable)
PBF     pbf_add_metadata   true     Add metadata (version, timestamp, etc. to objects)
XML     xml_change_format  false    Set change format, can also be set by using `osc` instead of `osm` suffix
XML     force_visible_flag false    Write out `visible` flag on each object, also set if `osh` instead of `osm` suffix used

It is also possible to change the format after creating a File object using the accessor functions:

~~~{.cpp}
osmium::io::File input_file("some_file.osm");
input_file.format(osmium::io::file_format_pbf);
~~~

### Reading a File

After you have a File object you can instantiate a Reader object to open the file for reading:

~~~{.cpp}
osmium::io::File input_file("input.osm.pbf");
osmium::io::Reader reader(input_file);
~~~

As a shortcut you can just give a file name to the Reader if you are relying
on the automatic file format detection and don't want to do any special format
handling:

~~~{.cpp}
osmium::io::Reader reader("input.osm.pbf");
~~~

Optionally you can add a second argument to the Reader constructor giving the
types of OSM entities you are interested in. Sometimes you only need, say, the
ways from the file, but not the nodes and relations. If you tell the Reader
about it, it might be able to read the file more efficiently by skipping those
parts you are not interested in:

~~~{.cpp}
osmium::io::Reader reader("input.osm.pbf", osmium::osm_entity::flags::way);
~~~

You can set the following flags:

Flag                                   Description
-----                                  -------------
`osmium::osm_entity::flags::nothing`   Do not ready any entities at all (useful if you are only interested in the file header)
`osmium::osm_entity::flags::node`      Read nodes
`osmium::osm_entity::flags::way`       Read ways
`osmium::osm_entity::flags::relation`  Read relations
`osmium::osm_entity::flags::changeset` Read changesets
`osmium::osm_entity::flags::all`       Read all of the above

You can also "or" several flags together if needed.

You can get the header information from the file using the `header()` function:

~~~{.cpp}
osmium::io::Header header = reader.header();
~~~

You read the OSM entities from the file using the `read()` which returns a
buffer with the data:

~~~{.cpp}
while (osmium::memory::Buffer buffer = reader.read()) {
    ...
}
~~~

At the end of the file an invalid buffer is returned which evaluates to false
in boolean context.

You can close the file at any time. It will also be automatically closed when
the Reader object goes out of scope.

~~~{.cpp}
reader.close();
~~~

In most cases you do not want to work with the buffers, but with the OSM
entities within them. See the [Iterators] chapter and the [Visitors and Handlers]
chapter for more convenient methods of working with open files.


### The Header

Format  Option           Default        Description
------- -------          --------       ------------
all     generator        Osmium/VERSION
XML     xml_josm_upload  not set        Set `upload` attribute in header to given value (`true` or `false`) for use in JOSM

