from meta import *
from links import print_links
from quest import print_quests

def execute():
    clean_metadata()
    print_quests()
    print_links()
    finalize_metadata()

execute()
