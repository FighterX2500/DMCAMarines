/datum/xeno_caste/Spitter
	name = "Spitter"
	eldery = "Young"
	next_upgrade = /datum/xeno_caste/Spitter/mature
	caste_type = /mob/living/carbon/Xenomorph/Spitter

	melee_damage_lower = 12
	melee_damage_upper = 22
	health = 160
	maxHealth = 160
	plasma_gain = 20
	plasma_max = 600
	upgrade_threshold = 140
	spit_delay = 25
	speed = -0.5
	caste_desc = "Ptui!"
	armor_deflection = 15

/datum/xeno_caste/Spitter/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Spitter/elder

	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 180
	maxHealth = 180
	plasma_gain = 25
	plasma_max = 700
	upgrade_threshold = 300
	spit_delay = 20
	caste_desc = "A ranged damage dealer. It looks a little more dangerous."
	armor_deflection = 20
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	speed = -0.6

/datum/xeno_caste/Spitter/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Spitter/ancient

	melee_damage_lower = 25
	melee_damage_upper = 35
	health = 200
	maxHealth = 200
	plasma_gain = 30
	plasma_max = 800
	upgrade_threshold = 600
	spit_delay = 15
	caste_desc = "A ranged damage dealer. It looks pretty strong."
	armor_deflection = 25
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 70
	speed = -0.7

/datum/xeno_caste/Spitter/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 35
	melee_damage_upper = 45
	health = 250
	maxHealth = 250
	plasma_gain = 50
	plasma_max = 900
	spit_delay = 10
	caste_desc = "A ranged destruction machine."
	armor_deflection = 30
	tacklemin = 5
	tacklemax = 7
	tackle_chance = 75
	speed = -0.8