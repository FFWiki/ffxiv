# Runs all necessary scripts for FFWiki Lua.
from meta import *
from links import print_links
from quest import print_quests

def execute():
    clean_metadata()
    print_links()
    print_quests()
    finalize_metadata()

execute()
