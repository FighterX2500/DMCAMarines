datum/marineResearch                        //Holder
	var/list/possible_tech = list()			//List of all tech in the game that players have access to (barring special events).
	var/list/known_tech = list()				//List of locally known tech.
	var/list/possible_designs = list()		//List of all designs (at base reliability).
	var/list/known_designs = list()			//List of available designs (at base reliability).


//Next bunch has been scrapped from previous things

//Checks to see if tech has all the required pre-reqs.
//Input: datum/tech; Output: 0/1 (false/true)
/datum/marineResearch/proc/TechHasReqs(var/datum/tech/T)
	if(T.req_tech.len == 0)
		return 1
	var/matches = 0
	for(var/req in T.req_tech)
		for(var/datum/tech/known in known_tech)
			if((req == known.id) && (known.level >= T.req_tech[req]))
				matches++
				break
	if(matches == T.req_tech.len)
		return 1
	else
		return 0

//Checks to see if design has all the required pre-reqs.
//Input: datum/design; Output: 0/1 (false/true)
/datum/marineResearch/proc/DesignHasReqs(var/datum/design/D)
	if(D.req_tech.len == 0)
		return 1
	var/matches = 0
	var/list/k_tech = list()
	for(var/datum/tech/known in known_tech)
		k_tech[known.id] = known.level
	for(var/req in D.req_tech)
		if(!isnull(k_tech[req]) && k_tech[req] >= D.req_tech[req])
			matches++
	if(matches == D.req_tech.len)
		return 1
	else
		return 0

//Adds a tech to known_tech list. Checks to make sure there aren't duplicates and updates existing tech's levels if needed.
//Input: datum/tech; Output: Null
/datum/marineResearch/proc/AddTech2Known(var/datum/tech/T)
	for(var/datum/tech/known in known_tech)
		if(T.id == known.id)
			if(T.level > known.level)
				known.level = T.level
			return
	known_tech += T
	return

/datum/marineResearch/proc/AddDesign2Known(var/datum/design/D)
	for(var/datum/design/known in known_designs)
		if(D.id == known.id)
			if(D.reliability_mod > known.reliability_mod)
				known.reliability_mod = D.reliability_mod
			return
	known_designs += D
	return

//Refreshes known_tech and known_designs list. Then updates the reliability vars of the designs in the known_designs list.
//Input/Output: n/a
/datum/marineResearch/proc/RefreshResearch()
	for(var/datum/tech/PT in possible_tech)
		if(TechHasReqs(PT))
			AddTech2Known(PT)
	for(var/datum/design/PD in possible_designs)
		if(DesignHasReqs(PD))
			AddDesign2Known(PD)
	for(var/datum/tech/T in known_tech)
		T = between(1,T.level,20)
	for(var/datum/design/D in known_designs)
		D.CalcReliability(known_tech)
	return

//Refreshes the levels of a given tech.
//Input: Tech's ID and Level; Output: null
/datum/marineResearch/proc/UpdateTech(var/ID, var/level)
	for(var/datum/tech/KT in known_tech)
		if(KT.id == ID)
			if(KT.level <= level) KT.level = max((KT.level + 1), (level - 1))
	return

/datum/marineResearch/proc/UpdateDesign(var/path)
	for(var/datum/design/KD in known_designs)
		if(KD.build_path == path)
			KD.reliability_mod += rand(1,2)
			break
	return

//List of researches
/*datum/tech	//Datum of individual technologies.
	var/name = "name"					//Name of the technology.
	var/desc = "description"			//General description of what it does and what it makes.
	var/id = "id"						//An easily referenced ID. Must be alphanumeric, lower-case, and no symbols.
	var/level = 1						//A simple number scale of the research level. Level 0 = Secret tech.
	var/list/req_tech = list()			//List of ids associated values of techs required to research this tech. "id" = #
*/

datum/tech/XenoSBiology
	name = "Xeno Biology"
	desc = "Analysis of alien biology"
	id = "XenoSBio"

datum/tech/XenoMBiology
	name = "Xenomoprh Biology"
	desc = "Analysis of bizzare nature of Xenomorphs"
	id = "XenomBio"
	level = 2
	req_tech = list("XenoSBio" = 2)

datum/tech/XenoFBiology
	name = "Xenomoprh Flora"
	desc = "Analysis of few xenoflora"
	id = "XenoFlora"
	level = 2
	req_tech = list("XenoSBio" = 2)

datum/tech/XenoChem
	name = "Xenomorph Chemistry"
	desc = "Analysis of highly potent Xeno chemistry"
	id = "XenoChem"
	level = 2
	req_tech = list("XenoSBio" = 2)

datum/tech/XenoMind
	name = "Xenomorph Chemistry"
	desc = "Analysis of telepathic connections between members of Xenohive"
	id = "XenoMind"
	req_tech = list("XenoSBio" = 4)