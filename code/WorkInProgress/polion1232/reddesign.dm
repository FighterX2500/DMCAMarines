#define MARINE_PROTHOLATHE 1

/datum/marine_design
	var/name = ""		//Design Name
	var/desc = ""		//Design Description
	var/id = null		//Desighn ID
	var/build_path = null			//Base of the Design
	var/build_type		//In what kind of machine it will be built
	var/list/req_tech = list()		//What needed for design
	var/list/materials = list()		//Needed materials

///// Machines of xenos' impending DOOM /////

/datum/marine_design/sampler
	name = "Standart science-issued sampler"
	desc = "Common sampler, used by most scientific groups. Limited numbers of that devices we already have in hands, but we may need more of them."
	id = "sampler"
	build_path = /obj/item/marineResearch/sampler
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENOSTART)
	materials = list("metal" = 500, "glass" = 0, "biomass" = 0)

/datum/marine_design/stun_grenades
	name = "M40 HEDP to T-1 grenade retrofit"
	desc = "Custom-built shock grenades with limited area of effect and occasional malfunctions."
	id = "teslanades"
	build_path = /obj/item/storage/box/tesla_box
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_MUSCLES)
	materials = list("metal" = 1500, "glass" = 1500, "biomass" = 0)

/datum/marine_design/anti_weed
	name = "Plant-B-Gone military-grade sprinkler"
	desc = "Common pesticide had been found useful against Xenoflora of all kind."
	id = "sprayer"
	build_path = /obj/item/reagent_container/spray/anti_weed
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_FLORA)
	materials = list("metal" = 500, "glass" = 0, "biomass" = 0)

/datum/marine_design/anti_acid
	name = "Anti-Acid standart chemical mixture"
	desc = "Useful mixture of alkalies, strong enough to neutralize most of XBA-based acids."
	id = "anti-acid_sprayer"
	build_path = /obj/item/anti_acid
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_SPITTER)
	materials = list("metal" = 500, "glass" = 0, "biomass" = 0)

/datum/marine_design/knight
	name = "Chitin armor prototype"
	desc = "Powerful armor, that has been haphazardly bolted in gives marines more chances of survival."
	id = "carmor"
	build_path = /obj/item/clothing/suit/knight
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_ARMOR)
	materials = list("metal" = 7500, "glass" = 0, "biomass" = 7500)

/datum/marine_design/helmknight
	name = "Chitin helmet prototype"
	desc = "Powerful helmet, that has been haphazardly bolted in gives marines more chances of survival."
	id = "chelmet"
	build_path = /obj/item/clothing/head/helmet/knight
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_ARMOR)
	materials = list("metal" = 0, "glass" = 0, "biomass" = 1500)

/datum/marine_design/biocircuit
	name = "Biogenerator Prototype"
	desc = "With understanding Hivelord's metabolism we can potentially have infinite source of Xenomorph biomaterial. But we must use internal connetor of our protolathe."
	id = "hivethingy"
	build_path = /obj/item/circuitboard/machine/biolathe
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_HIVELORD)
	materials = list("metal" = 0, "glass" = 500, "biomass" = 50)

/datum/marine_design/teslagun
	name = "HEW \"Paralayzer\" military-grade retrofit"
	desc = "Initial flaw, that we found in Xenomorph organism, bring us to the idea of retrofitting old Heavy Electrical Weapon. But it need suitable recharger, what can be created separately."
	id = "tesla"
	build_path = /obj/item/weapon/gun/energy/tesla
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENOSTART)
	materials = list("metal" = 1000, "glass" = 500, "biomass" = 0)

/datum/marine_design/teslabackpack
	name = "HEW-2 \"Zeus\" Powerpack"
	desc = "Powerful recharging system for HEW-2 \"Zeus\", needed for proper functioning of discharger."
	id = "teslabackpack"
	build_path = /obj/item/tesla_powerpack
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENOSTART)
	materials = list("metal" = 1000, "glass" = 500, "biomass" = 0)

/datum/marine_design/cell
	name = "XBA-based power cells"
	desc = "Powerful Xenomorph acids can be very useful for power cells' production."
	id = "cell"
	build_path = /obj/item/cell/xba
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_CHEMISTRY)
	materials = list("metal" = 100, "glass" = 0, "biomass" = 100)

/datum/marine_design/hcell
	name = "Increased-capacity power cells"
	desc = "Spitter's acids proven to be much more energy-efficient than standart XBA cells."
	id = "hcell"
	build_path = /obj/item/cell/xba/high
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_SPITTER)
	materials = list("metal" = 100, "glass" = 0, "biomass" = 200)

/datum/marine_design/laserpistol
	name = "Experimental Laser Handgun"
	desc = "Our new breakthrough with XBA-based energy cells opens gates to deadly portable laser weaponry."
	id = "laspist"
	build_path = /obj/item/weapon/gun/energy/laspistol
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_LASGUN)
	materials = list("metal" = 100, "glass" = 0, "biomass" = 500)

/datum/marine_design/lasergun
	name = "Experimental Laser Rifle"
	desc = "Our new breakthrough with XBA-based energy cells opens gates to deadly portable laser weaponry."
	id = "lasgan"
	build_path = /obj/item/weapon/gun/energy/lasgan
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_LASGUN)
	materials = list("metal" = 500, "glass" = 0, "biomass" = 1000)

/datum/marine_design/lasercannon
	name = "Experimental Heavy Portable Laser Cannon"
	desc = "Our new breakthrough with XBA-based energy cells opens gates to deadly portable laser weaponry."
	id = "lascan"
	build_path = /obj/item/weapon/gun/energy/lascannon
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_SPITTER, RESEARCH_XENO_LASGUN)
	materials = list("metal" = 1000, "glass" = 0, "biomass" = 1500)

/datum/marine_design/hivecorruption
	name = "Gene-Agent \"Infector\"."
	desc = "A crime against the Nature, \"Infector\" is our crowned achievment in Hivemind understanding. Evil and brutal, one injection of this abomination can forever change still not born organism. We just need to make sure that no one, except High Command, will know about our shenanigans here."
	id = "corruptor"
	build_path = /obj/item/infector
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_CORRUPTION)
	materials = list("metal" = 50, "glass" = 100, "biomass" = 1500)

/datum/marine_design/disruptorcircuit									//You must REALLY hate xeno, if you creating that
	name = "Hivelink Disruptor Prototype"
	desc = "Powerful machinery, what can throw entire Hive chain of command into chaos. But we must deply that machine on surface under protection of planetary magnetic field."
	id = "disruptor"
	build_path = /obj/item/circuitboard/machine/hive_disruptor
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_DISRUPTION)
	materials = list("metal" = 0, "glass" = 500, "biomass" = 7500)

/datum/marine_design/controllercircuit									//You must REALLY hate xeno, if you creating that
	name = "Hivelink Controller Prototype"
	desc = "Comm. console, that can take control over corrupted hives. If we create this, we will bring dishonor on our souls."
	id = "controller"
	build_path = /obj/item/circuitboard/machine/hive_controller
	build_type = MARINE_PROTHOLATHE
	req_tech = list(RESEARCH_XENO_CORRUPTION)
	materials = list("metal" = 0, "glass" = 500, "biomass" = 7500)