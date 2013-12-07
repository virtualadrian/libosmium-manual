# OSM Entities

Osmium works with the four basic types of OSM entities: Nodes, Ways, and
Relations (which are all [Objects]) and Changesets.

These OSM entities can not be created like any normal C++ object, but they
need a buffer to live in. See the next chapter for details. Accessing existing
OSM entities on the other hand is easy and straightforward.

## Objects

Class: `osmium::Object`

Include: `<osmium/osm/object.hpp>`

The `osmium::Object` class is the base class for nodes, ways, and relations.
it has accessors for the usual OSM attributes:

    osmium::Object& obj = ...
    std::cout << "id=" << obj.id()
              << " version=" << obj.version()
              << " timestamp=" << obj.timestamp()
              << " visible=" << (obj.visible() ? "true" : "false"
              << " changeset=" << obj.changeset()
              << " uid=" << obj.uid()
              << " user=" << obj.user() << "\n";

The `changeset()` and `uid()` accessor functions return the IDs of the changeset
that created this object version and the User ID of the user creating this version
of the object, respectively. They do not link to an object of that type.

The `visible` flag will always be true for normal OSM data, but for history data
or change files it shows whether an object version has been deleted.

In addition each object has a list of tags attached:

    osmium::TagList& tags = obj.tags();

You can iterate over all tags:

    for (osmium::Tag& tag : obj.tags()) {
        std::cout << tag.key() << "=" << tag.value() << "\n";
    }

Or you can find specific tags:

    const char* highway = obj.tags().get_value_by_key("highway");
    if (highway && !strcmp(highway, "primary") {
        ...
    }


## Nodes

Class: `osmium::Node`

Include: `<osmium/osm/node.hpp>`

A `Node` is a kind of `Object`. In addition to the things you can do with any
Object, the Node has a Location.

    osmium::Node& node = ...
    double longitude = node.location().lon();

## Ways

Classes: `osmium::Way`, `osmium::WayNode`, `osmium::WayNodeList`

Include: `<osmium/osm/way.hpp>`

A `Way` is a kind of `Object`. In addition to the things you can do with any
Object, a Way has a list of way nodes:

    osmium::Way& way = ...
    for (osmium::WayNode& wn : way.nodes()) {
        std::cout << "ref=" << wn.ref() << " location=" << wn.location() << "\n";
    }

## Relations

Classes: `osmium::Relation`, `osmium::RelationMember`, `osmium::RelationMemberList`

Include: `<osmium/osm/relation.hpp>`

A `Relation` is a kind of `Object`. In addition to the things you can do with any
Object, a Relation has a list of members:

    osmium::Relation& relation = ...
    osmium::RelationMemberList& rml = way.members();
    for (osmium::RelationMember& rm : rml) {
        std::cout << rm.type() << rm.ref() << " (role=" << rm.role() << ")\n";
    }

## Areas

*not yet implemented*

## Changesets

Class: `osmium:Changeset`

Include: `<osmium/osm/changeset.hpp>`

Changesets contain the metadata for a set of changes to OSM data.

    osmium::Changeset


