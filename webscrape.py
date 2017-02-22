from lxml import html
import requests

def gescape_quest(name):
    tree = html.fromstring(requests.get('http://ffxiv.gamerescape.com/wiki/' + name).content)
    xp = tree.xpath("//td/[@colspan=1]/span/text()")[0]
    npc = tree.xpath("//td/text()")
