import meta
import links
import quest

def execute():
    meta.clean_metadata()
    quest.print_quests()
    links.print_links()
    meta.finalize_metadata()

execute()
