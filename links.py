from csv import reader
from lua import *
import sparse
import meta

FILES = {"quests": ["exd/journalgenre.exh_en.csv", 3], "items": ["exd/itemuicategory.exh_en.csv", 1]}
OUTPUT = "lua/links.lua"
TEST = False

# Write all links generated from FILES.
def print_links():
    meta.report_metadata("links")
    with open(OUTPUT, 'w') as f:
        f.write("return {")
        
    for name, v in FILES.items():
        i = -1 # Set to 0 to skip the first row
        exh = v[0]
        loc = v[1]
        if name == "items":
            i = 0
        with open(exh, 'r') as f:
            print("Reading from " + exh + "...")
            csv_list = list(reader(f))

        lst = []
        for genre in csv_list:
            if "Index" in genre[0]:
                continue
            elif i == 0:
                i = -1
                continue
            else:
                lst.append("        \"List of Final Fantasy XIV " + name + "/" + genre[loc] + "\"")
    
        if TEST:
            print(wlts(name, lst))
        else:
            with open(OUTPUT, 'ab') as f:
                print("Writing to " + OUTPUT)
                wltw(f, name, lst)

    with open(OUTPUT, 'a') as f:
        f.write("}")

    clean_file(OUTPUT)
