# Indexes

Osmium is built around the idea that a lot of the things you want to do
with OSM data can be done one OSM object at the time without having all
(or large parts of) the OSM data in memory or in some kind of database.
But there are many things you can not do this way. You do need some kind
of storage to hold the data and some indexes to access it efficiently.
Osmium provides several class templates that implement several different
types of indexes.

## Index Types

Osmium provides indexes modelled after the STL map and multimap
classes, respectively. These classes are to be found in the
osmium::index::map and osmium::index::multimap namespaces.

### Map Index

Often we need some small, fixed amount of data stored for each OSM
object. Read and write access is by ID only. Typical use cases
include...

* storage of node locations where for each node ID we store the longitude and
  latitude of that node.
* storing the offset of an OSM object in a buffer.
* a lookup table that gives you for each node ID all IDs of the way (or ways)
  that include this node.

### Storage types

There are different strategies of storing this data efficiently and
there are several sub-classes of the Map and Multimap classes that
use different
strategies. It is important that you understand the differences and
use the class thats most appropriate for your case.

The differences can be understood along different axes:

First, the question is whether the ID space is dense or not. If you
are using the full planet data or large portions (such as entire
continents) thereof, your ID space is dense, ie most of the possible
IDs are actually present in the index. If you are only using
small extracts (even with whole countries in them), you ID space is
sparse, ie most of the possible IDs are not present in the index.
For dense indexes data is often best stored in a kind of array
indexed by the ID. For sparse indexes there are several other
possibilities.

The second question is whether you have enought RAM to hold all
the data in the index. Of course it is more efficient to keep the
index in RAM, but if you don't have enough you need to use a disk-based
index.

    handler-example.cpp
        
#### List of map index classes

see also: table in spreadsheet
dummy
based on vector: with stl vector, with mmap_anon, with mmap_file 
other: stl map, google sparsetable

#### List of multimap index classes

based on vector: with stl vector, with mmap_anon, with mmap_file 
other: stl multimap, hybrid

