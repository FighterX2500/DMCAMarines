datum/marineResearch                        //Holder
	var/list/available_tech = list()
	var/list/known_tech = list()
	var/list/possible_tech = list()

datum/marineResearch/New()
	for(var/T in subtypesof(/datum/marineTech))
		possible_tech += new T(src)

datum/marineResearch/proc/Check_tech(tech)					// return 0 if tech not available nor known, return 1 if known, return 2 if available
	for(var/datum/marineTech/avail in available_tech)
		if(avail.id == tech)
			return 2
	for(var/datum/marineTech/avail in known_tech)
		if(avail.id == tech)
			return 1
	return 0

datum/marineResearch/proc/TechMakeReq(datum/marineTech/tech)
	var/fl = 1														//Entire existance of this var pisses me the fuck off
	if(istype(tech, /datum/marineTech/Xenomorph))
		return fl
	for(var/req in tech.req_tech)
		fl = 0
		for(var/datum/marineTech/known in known_tech)
			if(known.id == req)
				fl = 1
	return fl

datum/marineResearch/proc/TechMakeReqInDiss(tech) // Just for checking when about to dissected
	var fl = 1
	for(var/datum/marineTech/possible in possible_tech)
		if(tech == possible.id)
			for(var/T in possible.req_tech)
				fl = 0
				for(var/datum/marineTech/known in known_tech)
					if(T == known.id)
						fl = 1
			return fl

datum/marineResearch/proc/AddToAvail(obj/item/marineResearch/xenomorp/A)
	for(var/datum/marineTech/teches in possible_tech)
		if(!Check_tech(teches.id))
			for(var/tech in A.id)
				if(tech == teches.id)
					if(TechMakeReq(teches))
						available_tech += teches
	return

datum/marineResearch/proc/AvailToKnown(datum/marineTech/reserched)			//Haphazardous
	available_tech -= reserched
	known_tech += reserched

/datum/marineTech
	var/name = "name"					//Name of the technology.
	var/desc = "description"			//General description of what it does and what it makes.
	var/id = -1						//An easily referenced ID. Must be alphanumeric, lower-case, and no symbols.
	var/time = 10						//What time takes to research. In seconds
	var/list/req_tech = list()			//List of required teches

/*
///// List of ids for teches/////

//First letter determinates path, second - tech
Starting (Xenomorphs) - 0

Xeno Biology - 10
Bio Plating - 11
Crusher Plating - 12
Xeno Muscles - 13
Hivelord thingy - 14

Xeno Chemistry - 20
Spitter thingy - 21

Xeno Flora - 30
Xenoweed - 31
Xenosack - 32
Drone thingy - 33

Queen thingy - 40
*/

/datum/marineTech/Xenomorph  //Starting tech
	name = "Xenomorphs"
	desc = "Analysis of alien species."
	id = 0


//Xenobiology path//
/datum/marineTech/XenoMBiology
	name = "Xenomorph Biology"
	desc = "Analysis of bizzare nature of Xenomorphs"
	id = 10
	req_tech = list(0)

/datum/marineTech/BioPlating
	name = "Xenomorph Armor Plating"
	desc = "Technology of manufacturing valuable plating for standart armor"
	id = 11
	req_tech = list(10)

/datum/marineTech/CrusherPlating
	name = "Crusher chitin patterns"
	desc = "Analysis of durable Crusher's chitin provides us with more reinforced plating"
	id = 12
	req_tech = list(10)

/datum/marineTech/Muscle
	name = "Xenomorph muscle tissue"
	desc = "Alien muscle tissue using same methods as human muscles, but they proven to be more durable and acid-resistant"
	id = 13
	req_tech = list(10)

/datum/marineTech/hivelord
	name = "Hivelord metabolism"
	desc = "Detailed analysis of Hivelords' metabolism shows, that their organism very energy-efficent"
	id = 14
	req_tech = list(10, 13)


//Chemistry path
/datum/marineTech/XenoChem
	name = "Xenomorph Chemistry"
	desc = "Analysis of highly potent Xeno chemistry"
	id = 20
	req_tech = list(0)

/datum/marineTech/SpitterChem
	name = "Spitter's toxicity"
	desc = "Potency of Spitter's chemisty was been proven highly effective against any target"
	id = 21
	req_tech = list(20)


//Xenoflora path//
/datum/marineTech/XenoFlora
	name = "Xenomorph Flora"
	desc = "Analysis of xenoflora, abudantly found near all Hives"
	id = 30
	req_tech = list(0)

/datum/marineTech/XenoWeed
	name = "Xenoweed"
	desc = "Weed - is a main part of xenomorphs's flora, that can somehow interact with xenomorphs's chitin"
	id = 31
	req_tech = list(30)

/datum/marineTech/XenoSack
	name = "Purple Sacks"
	desc = "Those sacks - small 'bushes', that produces weed nearby"
	id = 32
	req_tech = list(30)

/datum/marineTech/XenoDrone
	name = "Drone resin secrete"
	desc = "Analysis of various patterns of Drone's secrete glands"
	id = 33
	req_tech = list(10, 30)


//Xenopsi path
/datum/marineTech/XenoMind
	name = "Xenomorph Psionics"
	desc = "Analysis of telepathic connections between members of Xenohive"
	id = 40
	req_tech = list(0, 10, 20)


