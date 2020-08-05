/datum/xeno_caste/Sentinel
	name = "Sentinel"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Sentinel
	next_upgrade = /datum/xeno_caste/Sentinel/mature

	melee_damage_lower = 10
	melee_damage_upper = 20
	health = 130
	maxHealth = 130
	plasma_gain = 10
	plasma_max = 300
	upgrade_threshold = 100
	spit_delay = 30
	caste_desc = "A weak ranged combat alien."
	armor_deflection = 15
	speed = -0.8

/datum/xeno_caste/Sentinel/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Sentinel/elder

	melee_damage_lower = 15
	melee_damage_upper = 25
	health = 150
	maxHealth = 150
	plasma_gain = 12
	plasma_max = 400
	upgrade_threshold = 150
	spit_delay = 25
	caste_desc = "A ranged combat alien. It looks a little more dangerous."
	armor_deflection = 15
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	speed = -0.9

/datum/xeno_caste/Sentinel/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Sentinel/ancient

	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 175
	maxHealth = 175
	plasma_gain = 15
	plasma_max = 500
	upgrade_threshold = 300
	spit_delay = 20
	caste_desc = "A ranged combat alien. It looks pretty strong."
	armor_deflection = 20
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 60
	speed = -1.0

/datum/xeno_caste/Sentinel/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 25
	melee_damage_upper = 35
	health = 200
	maxHealth = 200
	plasma_gain = 20
	plasma_max = 600
	spit_delay = 10
	caste_desc = "Neurotoxin Factory, don't let it get you."
	armor_deflection = 20
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 60
	speed = -1.1