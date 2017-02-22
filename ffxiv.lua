p = {}

local getArgs = require("Dev:Arguments").getArgs
local string = require("Module:String")
local ffwiki = require("Module:HF")
local metadata = mw.loadData("Module:FFXIV Data/Meta")
local html = mw.html
local jobset = {"Gladiator","Pugilist","Marauder","Lancer","Archer","Conjurer","Thaumaturge","Carpenter","Blacksmith","Armorer","Goldsmith","Leatherworker","Weaver","Alchemist","Culinarian","Miner","Botanist","Fisher","Paladin","Monk","Warrior","Dragoon","Bard","White Mage","Black Mage","Arcanist","Summoner","Scholar","Rogue","Ninja","Machinist","Dark Knight","Astrologian"}

--Functions useful to all databases.
function anchor(name,linked) --Generates an {{LA}} if linked given, or otherwise an {{A}}. Returns wikitext.
	local str
	if linked then str = "<span id=\"" .. linked .. "\">[[" .. name .. "]]</span>"
	else str = "<span id=\"" .. name .. "\">" .. name .. "</span>"
	end
	return str
end

function image(ico) --Returns the [[File: link for the relevant icon in wikitext.
    return "File:icon-ffxiv-" .. ('00000'):sub(#tostring(ico)) .. ico .. ".png"
end

function patchep(patch,lua) --Generates a <div> of the patch version and about-edit-purge.
	return ffwiki.expandTemplate({title = "dnav", args = {patch, lua}})
end

function err(name,database,cspan) --Generates a <tr> for when a data piece does not exist.
	return html.create("tr"):tag("td"):attr("colspan",cspan or 1):wikitext(ffwiki.err(name .. " does not exist in the " .. database .. " database.<br/>")):done()
end

function imglink(k, v, db) -- Generates a link to the data stored by k,v in database db.
    return "[[" .. image(v.ico) .. "|link=" .. mw.loadData("Module:FFXIV Data/Links")[db][v.typ] .. "#" .. k .. "|" .. k .. "]]"
end

--The following functions are used in the items database.
function crafting(item) --Returns wikitext of the item's crafting.
	local price = ""
	local dmat = {[5594]="Grade 1",[5595]="Grade 2",[5596]="Grade 3",[5597]="Grade 4",[5598]="Grade 5",[10386]="Grade 6",[10335]="Cluster"}
	local rlvl = (math.floor(item.lv / 10) - 1) * 10
	if rlvl < 1 then rlvl = 1 end
	if item.rjob and item.dmat ~= 0 then price = price .. "Repair: " .. jobset[item.rjob] .. " Lv. " .. rlvl .. "<br/>Dark Matter: " .. dmat[item.dmat] end
	return price
end

function nrow(item,name,rspan,cspan,showprice) --Returns a <tr> object of the item's name row.
	local equipslots = {"All Classes","GLA","PGL","MRD","LNC","ARC","CNJ","THM","CRP","BSM","ARM","GSM","LTW","WVR","ALC","CUL","MIN","BTN","FSH","PLD","MNK","WAR","DRG","BRD","WHM","BLM","ACN","SMN","SCH","Disciple of War","Disciple of Magic","Disciple of the Land","Disciple of the Hand","Disciples of War or Magic","Disciples of the Land or Hand","Any Disciple of War but gladiator","GLA PGL MRD LNC ARC ROG CNJ THM ACN PLD WAR DRK","GLA PLD","GLA PGL MRD LNC ARC ROG PLD WAR DRK","GLA PGL MRD LNC ARC ROG CNJ THM ACN MNK WAR DRG BRD NIN","PGL MNK","GLA PGL MRD LNC ARC ROG MNK WAR DRG BRD NIN","GLA PGL MRD LNC ARC ROG CNJ THM ACN PLD MNK WAR DRG DRK","MRD WAR","GLA PGL MRD LNC ARC ROG PLD MNK WAR DRG DRK","GLA PGL MRD LNC ARC ROG CNJ THM ACN MNK DRG BRD NIN MCH","LNC DRG","GLA PGL MRD LNC ARC ROG MNK DRG BRD NIN MCH","GLA PGL MRD LNC ARC ROG CNJ THM ACN BRD BLM SMN MCH","ARC BRD","GLA PGL MRD LNC ARC ROG BRD MCH","GLA PGL MRD LNC ARC ROG CNJ THM ACN PLD WHM SCH AST","CNJ WHM","GLA PGL MRD LNC ARC ROG CNJ THM ACN WHM BLM SMN SCH AST","THM BLM","GLA CNJ THM PLD WHM BLM","GLA THM PLD BLM","GLA CNJ PLD WHM","GLA MRD PLD WAR DRK","GLA MRD LNC PLD WAR DRG DRK","CNJ THM ACN WHM SCH AST","CNJ THM ACN WHM BLM SMN SCH AST","THM ACN BLM SMN","CNJ WHM SCH AST","PGL MNK","ARC BRD MCH","GLA PGL MRD LNC ROG MNK DRG NIN","ACN SMN SCH","ACN SMN","Any Disciple of the Hand but culinarian","GLA PGL MRD LNC ARC ROG CNJ THM ACN WHM BLM SMN SCH","CNJ THM ACN WHM BLM SMN SCH","CNJ WHM SCH AST","","","","","","","","","","","","GLA MRD PLD WAR DRK","PGL LNC MNK DRG","GLA MRD PGL LNC ROG PLD MNK WAR DRG NIN","GLA MRD PGL LNC ARC ROG PLD MNK WAR DRG BRD NIN MCH","CNJ THM ACN WHM BLM SMN SCH AST","ARC CNJ THM ACN WHM BRD BLM SMN SCH MCH AST","ROG","NIN","ROG NIN","GLA PGL MRD LNC ARC ROG NIN","GLA PGL MRD LNC ROG NIN","MCH","PGL LNC ARC ROG MNK DRG BRD NIN MCH","DRK","AST","ARC ROG BRD NIN MCH","PGL LNC ROG MNK DRG NIN","PGL ROG MNK NIN","ROG NIN","","","GLA MRD PGL LNC ARC ROG BRD"}
	local types = {"[[List of Final Fantasy XIV weapons/Pugilist|Pugilist's knuckles]]","[[List of Final Fantasy XIV weapons/Gladiator|Gladiator's sword]]","[[List of Final Fantasy XIV weapons/Marauder|Marauder's axe]]","[[List of Final Fantasy XIV weapons/Archer|Archer's bow]]","[[List of Final Fantasy XIV weapons/Lancer|Lancer's spear]]","[[List of Final Fantasy XIV weapons/Thaumaturge#One-handed (Scepters)|Thaumaturge's scepter]]","[[List of Final Fantasy XIV weapons/Thaumaturge#Two-handed (Staves)|Thaumaturge's staff]]","[[List of Final Fantasy XIV weapons/Conjurer#One-handed (Rods)|Conjurer's rod]]","[[List of Final Fantasy XIV weapons/Conjurer#Two-handed (Canes)|Conjurer's cane]]","[[List of Final Fantasy XIV weapons/Arcanist|Arcanist's grimoire]]","[[List of Final Fantasy XIV armor/Shield|Shield]]","[[List of Final Fantasy XIV tools/Carpenter#Primary Tool (Saws)|Carpenter's saw]]","[[List of Final Fantasy XIV tools/Carpenter#Secondary Tool (Claw Hammers)|Carpenter's claw hammer]]","[[List of Final Fantasy XIV tools/Blacksmith#Primary Tool (Cross-pein Hammers)|Blacksmith's cross-pein hammer]]","[[List of Final Fantasy XIV tools/Blacksmith#Secondary Tool (Files)|Blacksmith's file]]","[[List of Final Fantasy XIV tools/Armorer#Primary Tool (Doming Hammers)|Armorer's doming hammer]]","[[List of Final Fantasy XIV tools/Armorer#Secondary Tool (Pliers)|Armorer's file]]","[[List of Final Fantasy XIV tools/Goldsmith#Primary Tool (Chaser Hammers)|Goldsmith's chaser hammer]]","[[List of Final Fantasy XIV tools/Goldsmith#Secondary Tool (Grinding Wheels)|Goldsmith's grinding wheels]]","[[List of Final Fantasy XIV tools/Leatherworker#Primary Tool (Head Knives)|Leatherworker's head knife]]","[[List of Final Fantasy XIV tools/Leatherworker#Secondary Tool (Awls)|Goldsmith's awls]]","[[List of Final Fantasy XIV tools/Weaver#Primary Tool (Needles)|Weaver's needle]]","[[List of Final Fantasy XIV tools/Weaver#Secondary Tool (Spinning Wheels)|Weaver's spinning wheels]]","[[List of Final Fantasy XIV tools/Alchemist#Primary Tool (Alembics)|Alchemist's alembics]]","[[List of Final Fantasy XIV tools/Alchemist#Secondary Tool (Mortars)|Alchemist's mortar]]","[[List of Final Fantasy XIV tools/Culinarian#Primary Tool (Skillets)|Culinarian's skillets]]","[[List of Final Fantasy XIV tools/Culinarian#Secondary Tool (Culinary Knives)|Culinarian's culinary knife]]","[[List of Final Fantasy XIV tools/Miner#Primary Tool (Pickaxes)|Miner's pickaxe]]","[[List of Final Fantasy XIV tools/Miner#Secondary Tool (Sledgehammers)|Miner's sledgehammer]]","[[List of Final Fantasy XIV tools/Botanist#Primary Tool (Hatchets)|Botanist's hatchet]]","[[List of Final Fantasy XIV tools/Botanist#Secondary Tool (Scythe)|Botanist's scythe]]","[[List of Final Fantasy XIV tools/Fisher|Fisher's rod]]","[[List of Final Fantasy XIV items/Fishing Tackle|Fishing Tackle]]","[[List of Final Fantasy XIV armor/Head|Armor (Head)]]","[[List of Final Fantasy XIV armor/Body|Armor (Body)]]","[[List of Final Fantasy XIV armor/Legs|Armor (Legs)]]","[[List of Final Fantasy XIV armor/Hands|Armor (Hands)]]","[[List of Final Fantasy XIV armor/Feet|Armor (Feet)]]","[[List of Final Fantasy XIV armor/Waist|Armor (Waist)]]","[[List of Final Fantasy XIV accessories/Necklace|Necklace]]","[[List of Final Fantasy XIV accessories/Earrings|Earrings]]","[[List of Final Fantasy XIV accessories/Bracelets|Bracelets]]","[[List of Final Fantasy XIV accessories/Ring|Ring]]","[[List of Final Fantasy XIV items/Medicines and Meals#Medicines|Medicine]]","[[List of Final Fantasy XIV items/Materials#Ingredient|Ingredient]]","[[List of Final Fantasy XIV items/Medicines and Meals#Meals|Meal]]","[[List of Final Fantasy XIV items/Materials#Seafood|Seafood]]","[[List of Final Fantasy XIV items/Materials#Stone|Stone]]","[[List of Final Fantasy XIV items/Materials#Metal|Metal]]","[[List of Final Fantasy XIV items/Materials#Lumber|Lumber]]","[[List of Final Fantasy XIV items/Materials#Cloth|Cloth]]","[[List of Final Fantasy XIV items/Materials#Leather|Leather]]","[[List of Final Fantasy XIV items/Materials#Bone|Bone]]","[[List of Final Fantasy XIV items/Materials#Reagents|Reagent]]","[[List of Final Fantasy XIV items/Materials#Dye|Dye]]","[[List of Final Fantasy XIV items/Materials#Parts|Part]]","[[List of Final Fantasy XIV items/Furnishing|Furnishing]]","[[Materia (Final Fantasy XIV)|Materia]]","[[List of Final Fantasy XIV items/Crystal|Crystal]]","[[List of Final Fantasy XIV items/Catalyst|Catalyst]]","[[List of Final Fantasy XIV items/Miscellany#Miscellany|Miscellany]]","[[List of Final Fantasy XIV accessories/Soul Crystal|Soul Crystal]]","[[List of Final Fantasy XIV items/Miscellany#Other Items|Other Item]]","[[List of Final Fantasy XIV items/Construction Permit|Construction Permit]]","[[List of Final Fantasy XIV items/Roof|Roof]]","[[List of Final Fantasy XIV items/Wall|Wall]]","[[List of Final Fantasy XIV items/Window|Window]]","[[List of Final Fantasy XIV items/Door|Door]]","[[List of Final Fantasy XIV items/Roof Decoration|Roof Decoration]]","[[List of Final Fantasy XIV items/Exterior Wall Decoration|Exterior Wall Decoration]]","[[List of Final Fantasy XIV items/Placard|Placard]]","[[List of Final Fantasy XIV items/Fence|Fence]]","[[List of Final Fantasy XIV items/Interior Wall|Interior Wall]]","[[List of Final Fantasy XIV items/Flooring|Flooring]]","[[List of Final Fantasy XIV items/Ceiling Light|Ceiling Light]]","[[List of Final Fantasy XIV items/Furnishing|Furnishing]]","[[List of Final Fantasy XIV items/Table|Table]]","[[List of Final Fantasy XIV items/Tabletop|Tabletop]]","[[List of Final Fantasy XIV items/Wall-mounted|Wall-mounted]]","[[List of Final Fantasy XIV items/Rug|Rug]]","[[List of Final Fantasy XIV items/Minion|Minion]]","[[List of Final Fantasy XIV items/Gardening|Gardening]]","[[Materia (Final Fantasy XIV)|Demimateria]]","[[List of Final Fantasy XIV weapons/Rogue|Rogue's daggers]]","Seasonal Miscellany","Triple Triad Card","[[List of Final Fantasy XIV weapons/Dark Knight|Dark Knight's greatsword]]","[[List of Final Fantasy XIV weapons/Machinist|Machinist's firearms]]","[[List of Final Fantasy XIV weapons/Astrologian|Astrologian's star globe]]","[[List of Final Fantasy XIV items/Airship|Airship Hull]]","[[List of Final Fantasy XIV items/Airship|Airship Propeller]]","[[List of Final Fantasy XIV items/Airship|Airship Aftcastle]]","[[List of Final Fantasy XIV items/Airship|Airship Forecastle]]","[[List of Final Fantasy XIV items/Orchestrion Roll|Orchestrion Roll]]"}
	local zodiac = {"Excalibur","Ragnarok","Lilith Rod","Nirvana","Aegis Shield","Longinus","Apocalypse","Sasuke's Blades","Kaiser Knuckles","Yoichi Bow","Last Resort"}
	local races = {"Hyur", "Elezen", "Lalafell", "Mi'qote", "Roegadyn", "Au Ra"}
	local genders = {"male", "female"}
	local gcicons = {"[[File:Limsa banner.jpg|25px]] ", "[[File:Grida banner.jpg|25px]] ", "[[File:Uldah banner.jpg|25px]] "}
	local gcnames = {"The Maelstrom", "The Order of the Twin Adder", "The Immortal Flames"}
	local elems = {"Slashing", "Piercing", "Blunt"}
	
	local zodiacbonus
	for _, w in ipairs(zodiac) do if name == w then zodiacbonus = true end end
	if ((name:find(" Novus") or name:find(" Nexus") or name:find(" Zeta")) and not name:find("Replica")) then zodiacbonus = true end
	
	local wpntype
	if item.typ == 1 or (item.typ > 5 and item.typ < 11) then --PGL CNJ THM ACN
		wpntype = "Deals blunt damage. "
	elseif item.typ == 2 or item.typ == 3 or item.typ == 84 or (item.typ > 88 and item.typ < 91) then --GLA LNC DRK AST
		wpntype = "Deals slashing damage. "
	elseif item.typ == 4 or item.typ == 88 then --ARC MCH
		wpntype = "Deals piercing damage. "
	elseif item.typ == 5 then --LNC
		wpntype = "Deals piercing damage. "
	end
	
	local notes = ""
	if item.gc and gcicons[item.gc] then notes = notes .. gcicons[item.gc] .. gcnames[item.gc] .. " uniform. " end
	if item.ndis then notes = notes .. "Cannot be discarded. " end
	if item.uniq then notes = notes .. "Unique. " end
	if item.untr then notes = notes .. "Untradable. " end
	if item.dye then notes = notes .. "Can be dyed. " end
	if item.crs then notes = notes .. "Crest-worthy. " end
	if name:find("Aetherial") or name:find("Mistbreak") then notes = notes .. "Randomly generated bonus stats. " end
	if zodiacbonus then notes = notes .. "Has 75 player-assigned bonus stats. " end
	if wpntype then notes = notes .. wpntype end
	if item.note then notes = notes .. item.note end
	if item.flv then
		if notes ~= "" then notes = notes .. "<br/>" end
		flavor = item.flv:gsub("?","")
		flavor = flavor:gsub("<color.>","")
		flavor = flavor:gsub("</color>","")
		notes = notes .. "<span style=\"font-style:italic;\">" .. flavor .. "</span>"
	end
	
	local nrow = html.create("tr")
	nrow:tag("th"):addClass("b"):attr("rowspan",rspan or 2):wikitext(anchor(name,item.page) .. "<br/>[[" .. image(item.ico) .. "|40px|Icon.]]")
	
	local ntd = nrow:tag("td"):cssText("border-right:none;vertical-align:top;"):attr("colspan",cspan or 2)
	ntd:wikitext("Level " .. item.lv .. " (Item Level " .. item.ilv .. ")<br/>" .. notes)
	if showprice then ntd:tag("p"):wikitext(crafting(item)) end
	
	local right = nrow:tag("td"):cssText("border-left:none;vertical-align:top;"):wikitext("'''" .. types[item.typ] .. "'''")
	if equipslots[item.job] then right:wikitext("<br/>Equipped by " .. (genders[item.gen] or "") .. " " .. (races[item.race] or "") .. " " .. equipslots[item.job]) end
	
	return nrow
end

function hq(item,sid) --If item.hq exists, returns the appropriate value. Otherwise 0.
	if item.hq then return item.hq[sid] or 0
	else return 0 end
end

function seval(s,hq) --Evaluates a stat, accounting for HQ bonuses. Returns 0 if doesn't exist, otherwise appropriate wikitext.
	local str = s or ""
	if hq and hq ~= 0 then
		if not s then s = 0 end
		if str == "" then str = "[[File:FFXIV HQ Icon.png]] " .. (s + hq)
		else str = str .. " ([[File:FFXIV HQ Icon.png]] " .. (s + hq) .. ")" end
	end
	if str == "" then str = 0 end
	return str
end

function stats(item) --Returns a <tr> object of the item's stats.
	local statcodes = {"Strength","Dexterity","Vitality","Intelligence","Mind","Piety","HP","MP","TP","GP","CP","Physical Damage","Magic Damage","Delay","Additional Effect: ","Attack Speed","Block Rate","Block Strength","Parry","Attack Power","Defense","Accuracy","Evasion","Magic Defense","Critical Hit Power","Critical Hit Resilience","Critical Hit Rate","Critical Hit Evasion","Slashing Resistance","Piercing Resistance","Blunt Resistance","Projectile Resistance","Attack Magic Potency","Healing Magic Potency","Enhancement Magic Potency","Enfeebling Magic Potency","Fire Resistance","Ice Resistance","Wind Resistance","Earth Resistance","Lightning Resistance","Water Resistance","Magic Resistance","Determination","Skill Speed","Spell Speed","??","Morale","Enmity","Enmity Reduction","Careful Desynthesis","","Regen","Refresh","Movement Speed","Spikes","Slow Resistance","Petrification Resistance","Paralysis Resistance","Silence Resistance","Blind Resistance","Poison Resistance","Stun Resistance","Sleep Resistance","Bind Resistance","Heavy Resistance","Doom Resistance","Reduced Durability Loss","Increased Spiritbond Gain","Craftsmanship","Control","Gathering","Perception"}
	
	local stattr = html.create("tr"):cssText("vertical-align:top;")
	local i = 1
	local stattd = {stattr:tag("td"):cssText("width:26%;border-right:none;"), stattr:tag("td"):cssText("width:26%;border-left:none;border-right:none;")}
	
	if (item.typ > 0 and item.typ < 11) or (item.typ > 11 and item.typ < 33 and (item.typ % 2) == 0) or item.typ == 84 or (item.typ > 87 and item.typ < 91) then --Mainhands
		stattd[1]:wikitext("Physical Damage: " .. seval(item.pdm,hq(item,12)) .. "<br/>")
		stattd[2]:wikitext("Magical Damage: " .. seval(item.mdm,hq(item,13)) .. "<br/>")
		stattd[1]:wikitext("Autoattack Delay: " .. ((item.aad / 1000) or 0) .. "<br/>")
	end
	
	if item.typ == 1 or (item.typ > 5 and item.typ < 11) then --PGL CNJ THM ACN
		stattd[2]:wikitext("Autoattack Range: 3<br/>")
	elseif item.typ == 2 or item.typ == 3 or item.typ == 84 or (item.typ > 88 and item.typ < 91) then --GLA LNC DRK AST
		stattd[2]:wikitext("Autoattack Range: 3<br/>")
	elseif item.typ == 4 or item.typ == 88 then --ARC MCH
		stattd[2]:wikitext("Autoattack Range: 25<br/>")
	elseif item.typ == 5 then --LNC
		stattd[2]:wikitext("Autoattack Range: 3<br/>")
	end
	
	if item.typ == 11 then --Shields
		stattd[1]:wikitext("Block Rate: " .. seval(item.blkr,hq(item,17)) .. "<br/>")
		stattd[2]:wikitext("Block Strength: " .. seval(item.blks,hq(item,18)) .. "<br/>")
	end
	
	if (item.typ > 33 and item.typ < 44) then --Armor & Accessories
		stattd[1]:wikitext("Physical Defense: " .. seval(item.pdf,hq(item,21)) .. "<br/>")
		stattd[2]:wikitext("Magical Defense: " .. seval(item.pdf,hq(item,24)) .. "<br/>")
	end
	
	if item.cld then --Consumable cooldown
		stattd[1]:wikitext("Cooldown: " .. item.cld .. "<br/>")
		i = 2
	end
	
	if item.pvp then --PvP rank
		stattd[i]:wikitext("PvP rank: " .. item.pvp .. "<br/>")
		i = 2
	end
	
	if item.s then
		for k, v in pairs(item.s) do
			if v ~= 0 then
				stattd[i]:wikitext(statcodes[k] .. " +" .. seval(v,hq(item,k)) .. "<br/>")
				if i == 2 then i = 1
				else i = 2 end
			end
		end
	end
	
	stattr:tag("td"):cssText("border-left:none;"):wikitext(crafting(item))
	
	return stattr
end

--Return functions for Items database.
function p.Accessories(frame)
	local args = getArgs(frame)
	local params = {}
	local data = mw.loadData("Module:FFXIV Data/Accessories")
	
	local tbl = html.create("table"):addClass("full-width FFXIV table")
	local header = tbl:tag("tr"):addClass("a")
	
	header:tag("th"):cssText("width:20%"):wikitext("Name")
	header:tag("th"):attr("colspan",2):wikitext("Stats")
	header:tag("th"):cssText("width:26%"):wikitext("Crafting")
	
	params[1] = args[1]:split(";", true, true)
	for k, v in pairs(params[1]) do
		local item = data[v]
		if item then
			tbl:node(nrow(item,v))
			tbl:node(stats(item))
		else
			tbl:node(err(v,"Accessories",4))
		end
	end
	return tostring(patchep(metadata.itemPatch,"Accessories")) .. tostring(tbl)
end

function p.Armor(frame)
	local args = getArgs(frame)
	local params = {}
	local data = mw.loadData("Module:FFXIV Data/Armor")
	
	local tbl = html.create("table"):addClass("full-width FFXIV table")
	local header = tbl:tag("tr"):addClass("a")
	
	header:tag("th"):cssText("width:20%"):wikitext("Name")
	header:tag("th"):attr("colspan",2):wikitext("Stats")
	header:tag("th"):cssText("width:26%"):wikitext("Crafting")
	
	params[1] = args[1]:split(";", true, true)
	for k, v in pairs(params[1]) do
		local item = data[v]
		if item then
			tbl:node(nrow(item,v))
			tbl:node(stats(item))
		else
			tbl:node(err(v,"Armor",4))
		end
	end
	return tostring(patchep(metadata.itemPatch,"Armor")) .. tostring(tbl)
end

function p.Arms(frame)
	local args = getArgs(frame)
	local params = {}
	local data = mw.loadData("Module:FFXIV Data/Arms")
	
	local tbl = html.create("table"):addClass("full-width FFXIV table")
	local header = tbl:tag("tr"):addClass("a")
	
	header:tag("th"):cssText("width:20%"):wikitext("Name")
	header:tag("th"):attr("colspan",2):wikitext("Stats")
	header:tag("th"):cssText("width:26%"):wikitext("Crafting")
	
	params[1] = args[1]:split(";", true, true)
	for k, v in pairs(params[1]) do
		local item = data[v]
		if item then
			tbl:node(nrow(item,v))
			tbl:node(stats(item))
		else
			tbl:node(err(v,"Arms",4))
		end
	end
	return tostring(patchep(metadata.itemPatch,"Arms")) .. tostring(tbl)
end

function p.Materials(frame)
	local args = getArgs(frame)
	local params = {}
	local data = mw.loadData("Module:FFXIV Data/Materials")
	
	local tbl = html.create("table"):addClass("full-width FFXIV table")
	local header = tbl:tag("tr"):addClass("a")
	
	header:tag("th"):cssText("width:25%"):wikitext("Name")
	header:tag("th"):cssText("width:65%"):wikitext("Data")
	header:tag("th"):cssText("width:20%"):wikitext("Type")
	
	params[1] = args[1]:split(";", true, true)
	for k, v in pairs(params[1]) do
		local item = data[v]
		if item then
			tbl:node(nrow(item,v,1,1,true))
		else
			tbl:node(err(v,"Materials",2))
		end
	end
	return tostring(patchep(metadata.itemPatch,"Materials")) .. tostring(tbl)
end

function p.MedicinesAndMeals(frame) --Could be turned into an equipment-like stat table, but for now, making it more like a mat-like table.
	local args = getArgs(frame)
	local params = {}
	local data = mw.loadData("Module:FFXIV Data/Medicines and Meals")
	
	local tbl = html.create("table"):addClass("full-width FFXIV table")
	local header = tbl:tag("tr"):addClass("a")
	
	header:tag("th"):cssText("width:25%"):wikitext("Name")
	header:tag("th"):cssText("width:65%"):wikitext("Data")
	header:tag("th"):cssText("width:20%"):wikitext("Type")
	
	params[1] = args[1]:split(";", true, true)
	for k, v in pairs(params[1]) do
		local item = data[v]
		if item then
			tbl:node(nrow(item,v,1,1,true))
		else
			tbl:node(err(v,"Medicines and Meals",2))
		end
	end
	return tostring(patchep(metadata.itemPatch,"Medicines and Meals")) .. tostring(tbl)
end

function p.OtherItems(frame)
	local args = getArgs(frame)
	local params = {}
	local data = mw.loadData("Module:FFXIV Data/Other Items")
	
	local tbl = html.create("table"):addClass("full-width FFXIV table")
	local header = tbl:tag("tr"):addClass("a")
	
	header:tag("th"):cssText("width:25%"):wikitext("Name")
	header:tag("th"):cssText("width:65%"):wikitext("Data")
	header:tag("th"):cssText("width:20%"):wikitext("Type")
	
	params[1] = args[1]:split(";", true, true)
	for k, v in pairs(params[1]) do
		local item = data[v]
		if item then
			tbl:node(nrow(item,v,1,1,true))
		else
			tbl:node(err(v,"Other Items",2))
		end
	end
	return tostring(patchep(metadata.itemPatch,"Other Items")) .. tostring(tbl)
end

function p.Tools(frame)
	local args = getArgs(frame)
	local params = {}
	local data = mw.loadData("Module:FFXIV Data/Tools")
	
	local tbl = html.create("table"):addClass("full-width FFXIV table")
	local header = tbl:tag("tr"):addClass("a")
	
	header:tag("th"):cssText("width:20%"):wikitext("Name")
	header:tag("th"):attr("colspan",2):wikitext("Stats")
	header:tag("th"):cssText("width:26%"):wikitext("Crafting")
	
	params[1] = args[1]:split(";", true, true)
	for k, v in pairs(params[1]) do
		local item = data[v]
		if item then
			tbl:node(nrow(item,v))
			tbl:node(stats(item))
		else
			tbl:node(err(v,"Tools",4))
		end
	end
	return tostring(patchep(metadata.itemPatch,"Tools")) .. tostring(tbl)
end

--Achievements database
function p.Achievements(frame)
	local args = getArgs(frame)
	local params = {}
	local data = mw.loadData("Module:FFXIV Data/Achievements")
	
	local tbl = html.create("table"):addClass("full-width FFXIV table")
	local header = tbl:tag("tr"):addClass("a")
	
	header:tag("th"):cssText("width:30%"):wikitext("Name")
	header:tag("th"):cssText("width:5%"):wikitext(ffwiki.expandTemplate({title = "foot", args = {"Pts","Points"}}))
	header:tag("th"):cssText("width:40"):wikitext("Description")
	header:tag("th"):cssText("width:25%"):wikitext("Reward")
	
	params[1] = args[1]:split(";", true, true)
	for k, v in pairs(params[1]) do
		local achv = data[v]
		if achv then
			local tr = tbl:tag("tr")
			tr:tag("th"):addClass("b"):wikitext(anchor(v,achv.page) .. "<br/>[[" .. image(achv.ico) .. "|40px|Icon.]]")
			tr:tag("td"):cssText("text-align:center;"):wikitext(achv.pts)
			tr:tag("td"):wikitext(achv.desc)
			tr:tag("td"):cssText("text-align:center;"):wikitext(achv.rwd or "&mdash;")
		else
			tbl:node(err(v,"Achivements",5))
		end
	end
	return tostring(patchep(metadata.achvPatch,"Achievements")) .. tostring(tbl)
	
end

--Icons database
function p.Icons(frame)
    local arg = getArgs(frame)[1]
    local datasources = {"Module:FFXIV Data/Accessories", "Module:FFXIV Data/Armor", "Module:FFXIV Data/Arms", "Module:FFXIV Data/Materials", "Module:FFXIV Data/Medicines and Meals", "Module:FFXIV Data/Other Items", "Module:FFXIV Data/Tools", "Module:FFXIV Data/Achievements"}
    
    for i, v in ipairs(datasources) do
        if mw.loadData(v)[arg] then return '[[' .. image(mw.loadData(v)[arg].ico) .. ']]' end
    end
    
    return ffwiki.err("Icon of " .. arg .. " does not exist in the database.") 
end

--Tomestones database
function p.Tomestones(frame)
    local args = getArgs(frame)
    local data = mw.loadData("Module:FFXIV Data/Tomestones")
    
    local typ = string.lower(args.type)
    local ilv = tonumber(args.ilvl)
    local tomes = {0, 0, 0}
    if data[typ] and data[typ][ilv] then
        tomes = data[typ][ilv]
    else
        tomes = {tonumber(args.tome1) or 0, tonumber(args.tome2) or 0, tonumber(args.tome3) or 0}
    end
    
    local rv = ""
    if tomes == {0, 0, 0} then return rv end
    for i, v in pairs(tomes) do
        local tdata = data.tomes[i] or ffwiki.err("Missing data in [[Module:FFXIV Data/Tomestones]], contact an admin!")
        if v > 0 then rv = rv .. "[[" .. tdata[2] .. "|25px|" .. tdata[1] .. "]] " .. v .. "<br/>" end
    end
    
    return rv
end

--Quests database
function questlookup(q)
    local data = mw.loadData("Module:FFXIV Data/Quests")
    for k, v in pairs(data) do if v.id == q then return "[[" .. mw.loadData("Module:FFXIV Data/Links").quests[v.typ] .. "#" .. k .. "|" .. k .. "]]" end end
    return ffwiki.err('Missing q' .. q .. ' !')
end

function itemlookup(x)
    local datasources = {"Module:FFXIV Data/Accessories", "Module:FFXIV Data/Armor", "Module:FFXIV Data/Arms", "Module:FFXIV Data/Materials", "Module:FFXIV Data/Medicines and Meals", "Module:FFXIV Data/Other Items", "Module:FFXIV Data/Tools"}
    for k, v in ipairs(datasources) do
        for l, w in pairs(mw.loadData(v)) do
            if w.id == x then return imglink(l, w, 'items') end
        end
    end
    return ffwiki.err('Missing i' .. x .. ' !')
end

function aclookup(x)
    return ''
end

function p.Quest(frame)
    local data = mw.loadData("Module:FFXIV Data/Quests")
    
    local div = html.create("div"):addClass("quests")
    for k, v in ipairs(getArgs(frame)[1]:split(";", true, true)) do
        local quest = data[v]
        div:tag("h3"):wikitext(v)
        tbl = div:tag("table"):cssText("float:right;width:382px;"):addClass("FFXIV table")
        if quest.ico > 0 then tbl:tag("tr"):tag("td"):attr("colspan", 2):wikitext("[[" .. image(quest.ico) .. "|" .. v .. "]]") end
        tbl:tag("tr"):tag("th"):addClass("b"):cssText("width:150px;"):wikitext("Level"):done():tag("td"):wikitext(quest.lvl)
        
        if quest.gil > 0 then
            tbl:tag("tr"):tag("th"):addClass("b"):wikitext("Gil"):done():tag("td"):wikitext(quest.gil)
        end
        if quest.prereqs then
            preqlist = tbl:tag("tr"):tag("th"):addClass("b"):wikitext("Prerequisites"):done():tag("td")
            for l, w in ipairs(quest.prereqs) do
                preqlist:wikitext(questlookup(w))
            end
        end
        if quest.unlocks then
            unlocklist = tbl:tag("tr"):tag("th"):addClass("b"):wikitext("Unlocks"):done():tag("td")
            for l, w in ipairs(quest.unlocks) do
                unlocklist:wikitext(questlookup(w))
            end
        end 
        if quest.needed then
            neededlist = tbl:tag("tr"):tag("th"):addClass("b"):wikitext("Needed items"):done():tag("td")
            for l, w in ipairs(quest.needed) do
                neededlist:wikitext(itemlookup(w))
            end
        end
        if quest.drops then
            droplist = tbl:tag("tr"):tag("th"):addClass("b"):wikitext("Dropped items"):done():tag("td")
            for l, w in ipairs(quest.drops) do
                droplist:wikitext(itemlookup(w))
            end
        end
        if quest.optdrops then
            odroplist = tbl:tag("tr"):tag("th"):addClass("b"):wikitext("Optional items"):done():tag("td")
            for l, w in ipairs(quest.optdrops) do
                odroplist:wikitext(itemlookup(w))
            end
        end
        if quest.action and quest.action > 0 then
            tbl:tag("tr"):tag("th"):addClass("b"):wikitext("Action unlocked"):done():tag("td"):wikitext(aclookup(quest.action))
        end
        
        div:tag("h4"):wikitext("Description"):done():tag("p"):wikitext(quest.desc)
        journ = div:tag("h4"):wikitext("Journal"):done():tag("ul")
        for l, w in ipairs(quest.journ) do
            journ:tag("li"):wikitext(w)
        end
        obj = div:tag("h4"):wikitext("Objectives"):done():tag("ul")
        for l, w in ipairs(quest.walkthr) do
            obj:tag("li"):wikitext(w)
        end
        dialog = div:tag("h4"):wikitext("Dialogue"):done():tag("dl"):addClass("collapsible collapsed")
        for l, w in ipairs(quest.dialogue) do
            dialog:tag("dt"):wikitext(w[1]):done():tag("dd"):wikitext(w[2])
        end
    end
    return tostring(patchep(metadata.questPatch,"Quests")) .. tostring(div)
end
return p

