/datum/xeno_caste/Drone
	name = "Drone"
	desc = "The workhorse of the hive."
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Drone
	next_upgrade = /datum/xeno_caste/Drone/mature

	melee_damage_lower = 12
	melee_damage_upper = 16
	health = 120
	maxHealth = 120
	plasma_max = 800
	plasma_gain = 20
	upgrade_threshold = 400
	caste_desc = ""						//flavor desc
	armor_deflection = 5
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	speed = -0.9
	aura_strength = 0.5
	spit_delay = 0
	bomb_strength = 0

/datum/xeno_caste/Drone/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Drone/elder

	melee_damage_lower = 12
	melee_damage_upper = 16
	health = 120
	maxHealth = 120
	plasma_max = 800
	plasma_gain = 20
	upgrade_threshold = 400
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	armor_deflection = 5
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	speed = -0.9
	aura_strength = 1

/datum/xeno_caste/Drone/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Drone/ancient

	melee_damage_lower = 12
	melee_damage_upper = 16
	health = 150
	maxHealth = 150
	plasma_max = 900
	plasma_gain = 30
	upgrade_threshold = 650
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	armor_deflection = 10
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	speed = -1.0
	aura_strength = 1.5

/datum/xeno_caste/Drone/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 200
	maxHealth = 200
	plasma_max = 1000
	plasma_gain = 50
	caste_desc = "A very mean architect."
	armor_deflection = 15
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 80
	speed = -1.1
	aura_strength = 2