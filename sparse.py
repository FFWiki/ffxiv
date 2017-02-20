import re

def remove_xml(s):
    return re.sub('<.*?>', '', s)

def remove_special(s):
    import string
    printable = set(string.printable)
    return ''.join(filter(lambda x: x in printable, s))

def parse(s):
    return remove_special(remove_xml(s))
