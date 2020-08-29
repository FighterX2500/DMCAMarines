/datum/xeno_caste/Carrier
	name = "Carrier"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Carrier
	next_upgrade = /datum/xeno_caste/Carrier/mature

	melee_damage_lower = 20
	melee_damage_upper = 30
	tacklemin = 2
	tacklemax = 3
	tackle_chance = 60
	health = 175
	maxHealth = 175
	plasma_max = 250
	upgrade_threshold = 400
	evolution_allowed = FALSE
	plasma_gain = 8
	caste_desc = "A carrier of huggies."
	aura_strength = 1 //Carrier's pheromones are equivalent to Hivelord. Climbs 0.5 up to 2.5
	speed = 0

	var/huggers_max = 0
	var/throwspeed = 1
	var/hugger_delay = 30
	var/eggs_max = 3

/datum/xeno_caste/Carrier/apply_caste(mob/living/carbon/Xenomorph/X)
	. = ..()
	var/mob/living/carbon/Xenomorph/Carrier/C = X
	C.huggers_max = huggers_max
	C.throwspeed = throwspeed
	C.hugger_delay = hugger_delay
	C.eggs_max = eggs_max

/datum/xeno_caste/Carrier/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Carrier/elder

	melee_damage_lower = 25
	melee_damage_upper = 35
	health = 200
	maxHealth = 200
	plasma_max = 300
	plasma_gain = 10
	upgrade_threshold = 600
	caste_desc = "A portable Love transport. It looks a little more dangerous."
	armor_deflection = 10
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 60
	speed = -0.1
	aura_strength = 1.5
	huggers_max = 9
	hugger_delay = 30
	eggs_max = 4

/datum/xeno_caste/Carrier/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Carrier/ancient

	melee_damage_lower = 30
	melee_damage_upper = 40
	health = 220
	maxHealth = 220
	plasma_max = 350
	plasma_gain = 12
	upgrade_threshold = 1200
	caste_desc = "It looks pretty strong."
	armor_deflection = 10
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 70
	speed = -0.2
	aura_strength = 2
	huggers_max = 10
	hugger_delay = 20
	eggs_max = 5

/datum/xeno_caste/Carrier/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 35
	melee_damage_upper = 45
	health = 250
	maxHealth = 250
	plasma_max = 400
	plasma_gain = 15
	caste_desc = "It's literally crawling with 10 huggers."
	armor_deflection = 15
	tacklemin = 5
	tacklemax = 6
	tackle_chance = 75
	speed = -0.3
	aura_strength = 2.5
	huggers_max = 11
	hugger_delay = 10
	eggs_max = 6