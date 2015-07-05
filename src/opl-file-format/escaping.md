
# Escaping

User names, tags, and relation member roles can contain any valid Unicode
character. Any characters that have special meaning in OPL files (' ' (space),
',' (comma), '=' (equals) and '@') have to be escaped as well as any
non-printing characters.

Escaped characters are written as `%xxxx`, ie a percent sign followed by the
4-digit hex code of the Unicode code point.

Currently there is a hard-coded list in the Osmium code of all the characters
that don't need escaping. This list is incomplete and subject to change.

