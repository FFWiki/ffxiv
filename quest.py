from csv import reader
from lua import *
import sparse
import meta

print("FFXIV Quest Database Generator")
print("Written by Catuse167 of FFWiki - Ver 0.9\n")

FILE = "exd/quest.exh_en.csv"
QUESTFILE = "exd/quest"
OUTPUT = "lua/quest.lua"

TEST = True
DIALOGUE = True

meta.report_metadata('quest')

def print_quests():
    with open(FILE, 'r') as f:
        print("Reading from " + FILE + "...")
        csv_list = list(reader(f))
    
    for quest in csv_list:
        if quest[1] == "" or "dfghjkl" in quest[1] or "[0x0]" in quest[1]:
            continue
        lst = [wvts("id", quest[0], False), # ID
            wvts("lvl", quest[5], False), # Level
            wvts("typ", quest[1479], False), # Type
            wvts("ico", quest[1480], False), # Icon
            wvts("gil", quest[1414], False)] # Gil
    
        prereqs,unlocks = [],[]
        for n in range(11, 15): # Prereqs
            if int(quest[n]) > 255:
                prereqs.append(quest[n])
        lst.append(wlts("prereqs", prereqs, False))
        for q in csv_list: # Unlocks
            if q[11] == quest[0]:
                unlocks.append(q[0])
        lst.append(wlts("unlocks", unlocks, False))
    
        drops,optdrops,needed = [],[],[]
        for n in range(106,110): # Needed item
            if int(quest[n]) in range(255,1000000):
                needed.append(quest[n])
        lst.append(wlts("needed", needed, False))
        lst.append(wvts("action", quest[1466], False)) # Action unlock
        for n in range(1424,1429): # Item drops
            if int(quest[n]) > 0:
                drops.append(quest[n])
        lst.append(wlts("drops", drops, False))
        for n in range(1445,1450): # Optional drops
            if int(quest[n]) > 0:
                optdrops.append(quest[n])
        lst.append(wlts("optdrops", optdrops, False))
    
        # If you're adding more non-textual data, do it HERE!
    
        for root,dirs,files in os.walk(QUESTFILE): # Textual data
            for name in files:
                if quest[2].lower() in name and "exh_en" in name:
                    with open(os.path.join(root,name), 'r') as f:
                        text_csv_list = list(reader(f))
                    break
        journal,walkthrough,dialogue = [],[],[]
        for line in text_csv_list:
            if line[0] == "Index" or line[2] == "dummy" or line[2] == "Dummy" or not line[2]:
                continue
            i = int(line[0])
            l = "\"" + sparse.parse(line[2]) + "\""
            if i == 0:
                lst.append(wvts("desc", l, False)) # Quest description
            elif i < 24:
                journal.append(l + ",")
            elif i < 48:
                walkthrough.append(l + ",")
            elif DIALOGUE:
                dialogue.append("{\"" + line[1].split("_")[3].lower().capitalize() + "\"," + l + "},")
        lst.append(wlts("journ", journal, False)) # Journal
        lst.append(wlts("walkthr", walkthrough, False)) # Walkthrough
        lst.append(wlts("dialogue", dialogue, False)) # Dialogue
    
        if TEST:
            print(wlts(quest[1], lst, False))
            if int(quest[0]) > 65558:
                break
        else:
            with open(OUTPUT, 'ab') as f:
                wltw(f, quest[1], lst)

print_quests()
