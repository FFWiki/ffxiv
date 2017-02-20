from lua import *

print("FFXIV Metadata Generator")
print("Written by Catuse167 of FFWiki - Ver 0.9\n")

METADATA = "lua/meta.lua"
PATCH = 3.51

def report_metadata(typ):
    with open(METADATA, 'ab') as f:
        print("Reporting metadata to  " + METADATA + "...")
        wvtw(f, typ + "Patch", PATCH)