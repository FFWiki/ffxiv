import csv
import sys
import os
import meta

# Needs cleanup and modernization!

FILE = "exd/item.exh_en.csv"
ARMS = "lua/arms.lua"
TOOLS = "lua/tools.lua"
ARMOR = "lua/armor.lua"
ACC = "lua/accessories.lua"
MNM = "lua/medicinesandmeals.lua"
MATS = "lua/materials.lua"

def print_items():
    meta.report_metadata('item')

with open(file, 'rb') as csvfile:
    print("Reading from " + file + ".")
    reader = csv.DictReader(csvfile)
    typeset = [""]
    for i in xrange(0,94):
        typeset.append("")
    print("Printing item data to LuaData/*.lua.")
    for row in reader:
        if row['name']:
            typeset[int(row['itemUIindex'])] += row['name'] + "; "
            icon = row['iconID']
            src = ""
            if int(icon) < 10:
                src = "ui/icon/00000" + icon + ".tex.png"
            elif int(icon) < 100:
                src = "ui/icon/0000" + icon + ".tex.png"
            elif int(icon) < 1000:
                src = "ui/icon/000" + icon + ".tex.png"
            elif int(icon) < 10000:
                src = "ui/icon/00" + icon + ".tex.png"
                print("So far so good.")
            elif int(icon) < 100000:
                src = "ui/icon/0" + icon + ".tex.png"
            elif int(icon) < 1000000:
                src = "ui/icon/" + icon + ".tex.png"
            else:
                print("No icon for " + row['name'] + "!")
                with open('logs/error.log','ab') as errlog:
                    errlog.write("No icon for " + row['name'] + "!")
            if src:
                try:
                    os.rename(src, "filesToUpload/FFXIV " + row['name'] + " Icon.png")
                    icons += "[" + icon + "]=\""File:FFXIV " + row['Name'] + " Icon.png"\","
                except WindowsError:
                    with open('error.log','ab') as errlog:
                        errlog.write("No icon for " + row['name'] + "!")
            written = "[\"" + row['name'] + "\"]={"
            written += "id=" + row['itemID'] + ","
            written += "typ=" + row['itemUIindex'] + ","
            written += "ico=" + icon + ","
            if row['equipcategory'] and row['equipcategory'] != "0":
                written += "job=" + row['equipcategory'] + ","
            if row['characterlevel'] and row['characterlevel'] != "0":
                written += "lv=" + row['characterlevel'] + ","
            if row['itemlevel'] and row['itemlevel'] != "0":
                written += "ilv=" + row['itemlevel'] + ","
            if row['flavortext']:
                written += "flv=\"" + row['flavortext'] + "\","
            if row['r88GC'] and row['r88GC'] != "0":
                written += "gc=" + row['r88GC'] + ","
            if row['male'] == "false" and row['female'] != "false":
                written += "gen=2,"
            if row['female'] == "false" and row['male'] != "false":
                written += "gen=1,"
            if row['hyur'] == "true" and row['elezen'] == "false":
                written += "race=1,"
            elif row['elezen'] == "true" and row['hyur'] == "false":
                written += "race=2,"
            elif row['miqote'] == "true" and row['hyur'] == "false":
                written += "race=3,"
            elif row['roe'] == "true" and row['hyur'] == "false":
                written += "race=4,"
            elif row['aura'] == "true" and row['hyur'] == "false":
                written += "race=5,"
            if row['PhysicalDamage'] and row['PhysicalDamage'] != "0":
                written += "pdm=" + row['PhysicalDamage'] + ","
            if row['MagicalDamage'] and row['MagicalDamage'] != "0":
                written += "mdm=" + row['MagicalDamage'] + ","
            if row['autoattackdelay(ms)'] and row['autoattackdelay(ms)'] != "0":
                written += "aad=" + row['autoattackdelay(ms)'] + ","
            if row['blockrate'] and row['blockrate'] != "0":
                written += "blkr=" + row['blockrate'] + ","
            if row['block'] and row['block'] != "0":
                written += "blks=" + row['block'] + ","
            if row['pdef'] and row['pdef'] != "0":
                written += "pdf=" + row['pdef'] + ","
            if row['mdef'] and row['mdef'] != "0":
                written += "mdf=" + row['mdef'] + ","
            if row['cooldown'] and row['cooldown'] != "0":
                written += "cld=" + row['cooldown'] + ","
            if row['PvPrank'] and row['PvPrank'] != "0":
                written += "pvp=" + row['PvPrank'] + ","
            if row['statname1'] and row['statname1'] != "0":
                written += "s={"
                written += "[" + row['statname1'] + "]=" + row['statvalue1'] + ","
                if row['statname2'] and row['statname2'] != "0":
                    written += "[" + row['statname2'] + "]=" + row['statvalue2'] + ","
                if row['statname3'] and row['statname3'] != "0":
                    written += "[" + row['statname3'] + "]=" + row['statvalue3'] + ","
                if row['statname4'] and row['statname4'] != "0":
                    written += "[" + row['statname4'] + "]=" + row['statvalue4'] + ","
                if row['statname5'] and row['statname5'] != "0":
                    written += "[" + row['statname5'] + "]=" + row['statvalue5'] + ","
                if row['statname6'] and row['statname6'] != "0":
                    written += "[" + row['statname6'] + "]=" + row['statvalue6'] + ","
                written += "},"
            hqtest = int(row['HQstatbonus1']) + int(row['HQstatbonus2']) + int(row['HQstatbonus3']) + int(row['HQstatbonus4']) + int(row['primehqaddition2']) + int(row['primehqaddition4'])
            if hqtest > 0:
                written += "hq={"
                if row['HQstatbonus1'] != "0":
                    written += "[" + row['HQstatbonus2'] + "]=" + row['HQstatbonus2'] + ","
                if row['HQstat2'] != "0":
                    written += "[" + row['HQstatbonus2'] + "]=" + row['HQstatbonus2'] + ","
                if row['HQstat3'] != "0":
                    written += "[" + row['HQstatbonus3'] + "]=" + row['HQstatbonus3'] + ","
                if row['HQstat4'] != "0":
                    written += "[" + row['HQstatbonus4'] + "]=" + row['HQstatbonus4'] + ","
                if row['primehqaddition2'] != "0":
                    written += "[" + row['primehqaddition1'] + "]=" + row['primehqaddition2'] + ","
                if row['primehqaddition4'] != "0":
                    written += "[" + row['primehqaddition3'] + "]=" + row['primehqaddition4'] + ","
                written += "},"
            if row['nondisposable'] and row['nondisposable'] == "true":
                written += "ndis=1,"
            if row['unique'] and row['unique'] == "true":
                written += "uniq=1,"
            if row['untradable'] and row['untradable'] == "true":
                written += "untr=1,"
            if row['candye'] and row['candye'] == "true":
                written += "dye=1,"
            if row['cancrest'] and row['cancrest'] == "true":
                written += "crs=1,"
            if row['stainindex'] and row['stainindex'] != "0":
                written += "stn=" + row['stainindex'] + ","
            if row['repairjob'] and row['repairjob'] != "0":
                written += "rjob=" + row['repairjob'] + ","
            if row['repairdarkmatter'] and row['repairjob'] != "0":
                written += "dmat=" + row['repairdarkmatter'] + ","
            if row['desynth'] and row['desynth'] != "0":
                written += "dsyn=" + row['desynth'] + ","
            if row['collectible'] and row['collectible'] != "0":
                written += "col=" + row['collectible'] + ","
            written += "},\n"
            typ = int(row['itemUIindex'])
            if (typ > 0 and typ < 11) or (typ == 84) or (typ > 86 and typ < 90):
                with open('LuaData/arms.lua','ab') as f: f.write(written)
            elif typ > 11 and typ < 33:
                with open('LuaData/tools.lua','ab') as f: f.write(written)
            elif typ == 11 or (typ > 33 and typ < 40):
                with open('LuaData/armor.lua','ab') as f: f.write(written)
            elif typ == 62 or (typ > 39 and typ < 44):
                with open('LuaData/accessories.lua','ab') as f: f.write(written)
            elif typ == 44 or typ == 46:
                with open('LuaData/medicinesandmeals.lua','ab') as f: f.write(written)
            elif typ == 45 or (typ > 46 and typ < 57):
                with open('LuaData/materials.lua','ab') as f: f.write(written)
            else:
                with open('LuaData/other.lua','ab') as f: f.write(written)
                
print("Printing item sets to Wikitext/itemsets.py.")
with open('Wikitext/itemsets.py','ab') as f: f.write(str(typeset))
print("Printing icon list to sets to LuaData/icons.lua")
with open('LuaData/icons.lua','ab') as f: f.write(icons)
