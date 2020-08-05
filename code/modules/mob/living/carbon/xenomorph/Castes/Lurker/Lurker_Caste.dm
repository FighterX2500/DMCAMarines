/datum/xeno_caste/Lurker
	name = "Lurker"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Lurker
	next_upgrade = /datum/xeno_caste/Lurker/mature

	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 150
	maxHealth = 150
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 300
	caste_desc = "A fast, powerful front line combatant."
	speed = -1.5 //Not as fast as runners, but faster than other xenos
	attack_delay = -2
	pounce_delay = 55

/datum/xeno_caste/Lurker/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Lurker/elder

	melee_damage_lower = 25
	melee_damage_upper = 35
	health = 170
	maxHealth = 170
	plasma_gain = 10
	plasma_max = 150
	upgrade_threshold = 600
	caste_desc = "A fast, powerful front line combatant. It looks a little more dangerous."
	speed = -1.6
	armor_deflection = 20
	attack_delay = -2
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	pounce_delay = 50

/datum/xeno_caste/Lurker/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Lurker/ancient

	melee_damage_lower = 35
	melee_damage_upper = 50
	health = 200
	maxHealth = 200
	plasma_gain = 10
	plasma_max = 200
	upgrade_threshold = 1200
	caste_desc = "A fast, powerful front line combatant. It looks pretty strong."
	speed = -1.7
	armor_deflection = 25
	attack_delay = -3
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 65
	pounce_delay = 45

/datum/xeno_caste/Lurker/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 50
	melee_damage_upper = 60
	health = 250
	maxHealth = 250
	plasma_gain = 20
	plasma_max = 300
	caste_desc = "A completly unmatched hunter. No, not even the Yautja can match you."
	speed = -1.8
	armor_deflection = 25
	attack_delay = -3
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 65
	pounce_delay = 40