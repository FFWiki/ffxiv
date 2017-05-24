# Runs all necessary scripts for FFWiki Lua.
from meta import *
from links import print_links
from quest import print_quests
from item import print_items

def execute():
    clean_metadata()
    print_links()
    print_quests()
    print_items()
    finalize_metadata()

execute()
