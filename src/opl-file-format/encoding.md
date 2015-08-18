
# Encoding

User names, tags, and relation member roles can contain any valid Unicode
character. Any characters that have special meaning in OPL files (' ' (space),
'\n' (linefeed), ',' (comma), '=' (equals) and '@') have to be escaped as well
as any non-printing characters.

Escaped characters are written as `%xxxx%`, ie a percent sign followed by the
hex code of the Unicode code point followed by another percent sign. The
number of digits in the hex code is not fixed, but must be between 1 and 6,
because all Unicode code points can be expressed in not more than 6 hex digits.

Any code reading OPL files has to cope with encoded and non-encoded characters
(except that characters used in the OPL file with special meaning will always
be escaped).

_Currently there is a hard-coded list in the Osmium code of all the characters
that don't need escaping. This list is incomplete and subject to change.
Currently two hex digits are used for code points less than 256 and at least
four hex digits for numbers above that._

