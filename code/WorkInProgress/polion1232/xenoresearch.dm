datum/marineResearch                        //Holder
	var/list/available_tech = list()
	var/list/known_tech = list()
	var/list/possible_tech = list()
	var/list/known_design = list()
	var/list/possible_design = list()

datum/marineResearch/New()
	for(var/T in subtypesof(/datum/marineTech))
		possible_tech += new T(src)
	for(var/T in subtypesof(/datum/marine_design))
		possible_design += new T(src)

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
		if(tech == possible.id && possible.need_item)
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
						possible_tech -= teches
	return

datum/marineResearch/proc/CheckAvail()
	var/fl = 1
	for(var/datum/marineTech/possible in possible_tech)
		if(!possible.need_item)
			for(var/id in possible.req_tech)
				fl = 0
				for(var/datum/marineTech/known in known_tech)
					if(known.id == id)
						fl = 1
			if(fl == 1)
				available_tech += possible
				possible_tech -= possible
	return

datum/marineResearch/proc/CheckDesigns()
	var/fl = 0
	for(var/datum/marine_design/design in possible_design)
		for(var/id in design.req_tech)
			fl = 0
			for(var/datum/marineTech/known in known_tech)
				if(id == known.id)
					fl = 1
		if(!fl)
			continue
		AddDesigns(design)

datum/marineResearch/proc/AddDesigns(datum/marine_design/design)			//Haphazardous[2]
	possible_design -= design
	known_design += design

datum/marineResearch/proc/AvailToKnown(datum/marineTech/reserched)			//Haphazardous
	available_tech -= reserched
	known_tech += reserched
	CheckDesigns()

/datum/marineTech
	var/name = "name"					//Name of the technology.
	var/desc = "description"			//Description before research
	var/resdesc = "resdesc"				//Description after research
	var/id = -1							//An easily referenced ID. Must be numeric.
	var/time = 30						//What time takes to research. In seconds
	var/list/req_tech = list()			//List of required teches
	var/need_item = 1					//For cheking if item needed for research

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
	resdesc = "Well, lets sink it - we are fighting against increadibly powerful and staggering foe. CLF, UPP, pirates - they are nothing compare to those beasts, if not a monsters. We need research further.."
	id = 0


//Xenobiology path//
/datum/marineTech/XenoMBiology
	name = "Xenomorph Biology"
	desc = "Analysis of bizzare nature of Xenomorphs"
	resdesc = "If we thought that humanity is a crowned kings of nature... Xenomorphs are Emperors. Resistant even for vacuum, they blood appears to be acid, that even corrode tank armor... And don't even think about those claws.."
	id = 10
	req_tech = list(0)
	need_item = 0									//No need for the item

/datum/marineTech/BioPlating
	name = "Xenomorph Armor Plating"
	desc = "Technology of manufacturing valuable plating for standart armor"
	resdesc = "Even their terrifying nature can benefit Colonial Marines with some valuable upgrades. Molecular structure of their chitin are increadibly strong and durable for being biological at fundamental. So much benefits, and no drawbacks..."
	id = 11
	req_tech = list(10)

/datum/marineTech/CrusherPlating
	name = "Crusher chitin patterns"
	desc = "Analysis of durable Crusher's chitin provides us with more reinforced plating"
	resdesc = "Well, to begin with - Crusher is very tenacious fella to kill even with AP rounds. But the best part of it - flamethowers will lighten him up like 4th July and provide us with stronger upgrades!"
	id = 12
	req_tech = list(10)

/datum/marineTech/Muscle
	name = "Xenomorph muscle tissue"
	desc = "Alien muscle tissue using same methods as human muscles, but they proven to be more durable and acid-resistant"
	resdesc = "It's true, that xenomorph claws can pierce armor, thanks to their sharpness. But to make it worse for our troops, Xenomophs have powerful muscle system, that can even withstand the most powerful of acids. It can still be pierced by standart rifle bullets, but have fun to pierce it with 9mm."
	id = 13
	req_tech = list(10)

/datum/marineTech/hivelord
	name = "Hivelord metabolism"
	desc = "Detailed analysis of Hivelords' metabolism shows, that their organism very energy-efficent"
	resdesc = "Wow. Hivelord cannot be poisoned. It cannot overeat either. Whatever it eats, food will provide 100% nutriment, even if it's drugged. Moreover, Hivelord will be basically uncatchable on weed, thanks to sharpened senses and enigmatic connection between xenobiology and xenoflora."
	id = 14
	req_tech = list(10, 13, 20, 30, 33)


//Chemistry path
/datum/marineTech/XenoChem
	name = "Xenomorph Chemistry"
	desc = "Analysis of highly potent Xeno chemistry"
	resdesc = "Foundation of inner xenochemistry is acids. Yes, their blood are acid, their enzymes are acid, their some kind of DNA(Xenomorph-Based Acid onward on) are STRONG acid. Just don't get caught by Sentinels's shots, or it will be painful."
	id = 20
	req_tech = list(0)


/datum/marineTech/SpitterChem
	name = "Spitter's toxicity"
	desc = "Potency of Spitter's chemisty was been proven highly effective against any target"
	resdesc = "Spitters are spitting their own XBA at you. They produce it in their glands, but it does not makes it better. But the most facinating about those glands is that they produce XBA of every Xenomorph subspecies."
	id = 21
	req_tech = list(20)
/*
/datum/marineTech/Pheromones
	name = "Xenomorph Pheromones"
	desc = "Analysis of very powerful xenomorph pheromones"
	id = 22
	req_tech = list(20)
*/


//Xenoflora path//
/datum/marineTech/XenoFlora
	name = "Xenomorph Flora"
	desc = "Analysis of xenoflora, abudantly found near all Hives"
	resdesc = "It's not a flora. It's all resins. But our troops our ignorant, or stupid enough. But somehow, that resin acts like flora anyway and makes some enigmatic connection with xenobiology."
	id = 30
	req_tech = list(0)
	need_item = 1

/datum/marineTech/XenoWeed
	name = "Xenoweed"
	desc = "Weed - is a main part of xenomorphs's flora, that can somehow interact with xenomorphs's chitin"
	resdesc = "Again, it's not a weed. It's a resin that covers any surface on its way. But it in some way alive, thanks to acting like flora."
	id = 31
	req_tech = list(30)

/datum/marineTech/XenoSack
	name = "Purple Sacks"
	desc = "Those sacks - small 'bushes', that produces weed nearby"
	resdesc = "As more we study xenoflora, the more enigmatic it for us. Purple Sack - is a small tank with mixture of various xenomorph-based acids with complex organ-like thing. We assume, that thing is responsible for producing weeds nearby."
	id = 32
	req_tech = list(30)

/datum/marineTech/XenoDrone
	name = "Drone resin secrete"
	desc = "Analysis of various patterns of Drone's secrete glands"
	resdesc = "Drone is a true enigma. Let's take their secrete glands. Gland, that produces resin. Highly complex and unbelievably small, those glands can rapidly put sacks anywhere. Only one question is unanswered - where does it takes energy for that?"
	id = 33
	req_tech = list(10, 30)


//Xenopsi path
/datum/marineTech/XenoMind
	name = "Xenomorph Psionics"
	desc = "Analysis of telepathic connections between members of Xenohive"
	resdesc = "Psionics are no mistery. Xenomorphs have telepathy, but most of them only recieving signals. But our dear Queeny is center of this network! She is responsible for unity inside the Hive! She is commanding Xenomophs Forces! But NO MORE! And her death will be demise for every xeno that had been controlled by her will!"
	id = 40
	req_tech = list(0, 10, 20)
/*
/datum/marineTech/Disruptor			// Fun starting here
	name = "Hivelink disruption"
	desc = "Using Queen's core as a connection to the Hive, we can theoretically damage their ability to cooperate between members of the Hive by continiously sending echoes to all members"
	id = 41
	req_tech = list(40)

/datum/marineTech/Simulator			// "- Absolute DISGUSTING!"- says xenomorph
	name = "Hivemind simulation"
	desc = "Hypothethis: if we use Queen's core as a center of another telepathic network, we potentialy can have our own, loyal Hive"
	id = 42
	req_tech = list(41)
*/
