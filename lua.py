def strip(s):
	"Removes non-ASCII characters from a string."
	return ''.join(c for c in str(s) if 0 < ord(c) < 127)

def wvts(vname, vdata, nline=True, comma=True):
	"Write a variable to a string."	
	if vdata == "":
		return ""
	vname = strip(vname)
	vdata = strip(vdata)
	if " " in vname:
		vname = "[\"" + vname + "\"]"
	if nline:
		return vname + "=" + vdata + ",\n"
	if comma:
		return vname + "=" + vdata + ","
	return vname + "=" + vdata

def wvtw(f, vname, vdata, nline=True):
	"Write a variable to the wiki file."
	f.write(bytes(wvts(vname, vdata, nline), "UTF-8"))

def wlts(vname, lst, nline=True):
	"Write a list to a string containing an equivalent Lua table."
	s = ""
	if len(lst) == 0:
		return s
	for x in lst:
		if not x:
			continue
		s = s + x
		if "," not in x:
			s = s + ","
			if nline:
				s = s + "\n"
	return wvts(vname, "{" + s + "},", nline, False)

def wltw(f, vname, lst, nline=True):
	"Write a list to the wiki file."
	f.write(bytes(wlts(vname, lst, nline), "UTF-8"))

def english(f):
	"Makes sure a file is in English."
	if "de" in f or "ja" in f or "fr" in f:
		return False
	return True

import os
def find_file(fname):
	"Finds the path to a file."
	for root, dirs, files in os.walk("."):
		for f in files:
			if name in f and english(f):
				return os.path.join(root, name)
