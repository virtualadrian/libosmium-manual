
# Introduction

*This format is preliminary, it might change. Please send feedback if you use this format!*

The OPL ("Object Per Line") format was created to allow easy access to and
manipulation of OSM data with typical UNIX command line tools such as `grep`,
`sed`, and `awk`. Each object is on its own line with a linefeed at the end.

This makes some ad-hoc OSM data manipulation easy to do, but it is not as fast
as some specialized tool.

OPL files are only about half the size of OSM XML files, when compressed (with
gzip or bzip2) they are about the same size.

Osmium currently can write OPL files, but not read them.

Each line of the file contains one OSM object (a node, way, or relation) or an
OSM changeset. Fields are separated by a space character, lines by a newline
character. Fields always appear in the same order and are always present, each
field is introduced by a specific character:

One of these fields is always the first:

    n - Node ID (nodes only)
    w - Way ID (ways only)
    r - Relation ID (relations only)
    c - Changeset ID (changesets only)

Then for OSM objects in the given order:

    v - Version
    d - Deleted flag ('V' - visible or 'D' - deleted)
    c - Changeset ID
    t - Timestamp (ISO Format)
    i - User ID
    u - Username
    T - Tags
    x - Longitude (nodes only)
    y - Latitude (nodes only)
    N - Nodes (ways only)
    M - Members (relations only)

If the file was written without metadata (using the option `add_metadata=false`
in Osmium), the fields `v`, `d`, `c`, `t`, `i`, and `u` are missing.

The N, M, and T fields can be empty. If the user is anonymous, the 'User ID'
will be 0 and the 'Username' field will be empty: `... i0 u ...`. If the
node is deleted, the 'Longitude' and 'Latitude' fields are empty. All other
fields always contain data.

The 'Deleted flag' shows whether an object version has been deleted (`dD`) or
is visible (`dV`). For normal OSM data files this is always `dV`, but change
files and osm history files can contain deleted objects.

For changesets the fields are different:

    k - num_changes
    s - created_at (start) timestamp (ISO Format)
    e - closed_at (end) timestamp (ISO Format)
    i - User ID
    u - Username
    x - Longitude (left bottom corner, min_lon)
    y - Latitude (left bottom corner, min_lat)
    X - Longitude (right top corner, max_lon)
    Y - Latitude (right top corner, max_lat)
    T - Tags

The field `e` is empty when the changeset is not closed yet. The fields `x`,
`y`, `X`, `Y` can be empty when no bounding box could be derived. The field `k`
can be 0.

