from lua import *

METADATA = "lua/meta.lua"
PATCH = 3.51

def report_metadata(typ):
    with open(METADATA, 'ab') as f:
        print("Reporting metadata to " + METADATA + "...")
        wvtw(f, typ + "Patch", PATCH)

def clean_metadata():
    with open(METADATA, 'w') as f:
        print("Cleaning metadata file...")
        f.write('return {')

def finalize_metadata():
    remove_commas(METADATA)
    with open(METADATA, 'a') as f:
        print("Closing metadata file...")
        f.write('}')
