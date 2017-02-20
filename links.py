from csv import reader
from lua import *
import sparse
import meta

print("FFXIV Links Generator")
print("Written by Catuse167 of FFWiki - Ver 0.9\n")

FILES = {"quests": ["exd/journalgenre.exh_en.csv", 3], "items": ["exd/itemuicategory.exh_en.csv", 1]}
OUTPUT = "lua/links.lua"
TEST = False

meta.report_metadata("links")

def print_links():
    with open(OUTPUT, 'w') as f:
        f.write("return {")
        
    for name, v in FILES.items():
        exh = v[0]
        loc = v[1]
        with open(exh, 'r') as f:
            print("Reading from " + exh + "...")
            csv_list = list(reader(f))

        lst = []
        for genre in csv_list:
            if "Index" in genre[0] or "0" in genre[0]:
                continue
            lst.append("        \"List of Final Fantasy XIV " + name + "/" + genre[loc] + "\"")
    
        if TEST:
            print(wlts(name, lst))
        else:
            with open(OUTPUT, 'ab') as f:
                print("Writing to " + OUTPUT)
                wltw(f, name, lst)

    with open(OUTPUT, 'a') as f:
        f.write("}")

print_links()
