# String parser for FFWiki Lua.
import re

# Strips XML tags from a string.
def remove_xml(s):
    return re.sub('<.*?>', '', s)

# Strips unprintable characters from a string.
def remove_special(s):
    import string
    printable = set(string.printable)
    return ''.join(filter(lambda x: x in printable, s))

# Runs all string parse functions on a string.
def parse(s):
    return remove_special(remove_xml(s))
