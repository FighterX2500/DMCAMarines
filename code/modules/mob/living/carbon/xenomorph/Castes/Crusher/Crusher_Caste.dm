/datum/xeno_caste/Crusher
	name = "Crusher"
	eldery = "Young"
	desc = "A huge alien with an enormous armored head crest."
	caste_type = /mob/living/carbon/Xenomorph/Crusher
	next_upgrade = /datum/xeno_caste/Crusher/mature

	melee_damage_lower = 15
	melee_damage_upper = 30
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 60
	health = 300
	maxHealth = 300
	plasma_gain = 10
	plasma_max = 200
	upgrade_threshold = 400
	evolution_allowed = FALSE
	caste_desc = "A huge tanky xenomorph."
	speed = 0.1
	armor_deflection = 75

/datum/xeno_caste/Crusher/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Crusher/elder

	melee_damage_lower = 20
	melee_damage_upper = 35
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 65
	health = 325
	maxHealth = 325
	plasma_gain = 15
	plasma_max = 300
	upgrade_threshold = 600
	caste_desc = "A huge tanky xenomorph. It looks a little more dangerous."
	armor_deflection = 80

/datum/xeno_caste/Crusher/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Crusher/ancient

	melee_damage_lower = 35
	melee_damage_upper = 45
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 75
	health = 375
	maxHealth = 375
	plasma_gain = 30
	plasma_max = 400
	upgrade_threshold = 1600
	caste_desc = "A huge tanky xenomorph. It looks pretty strong."
	armor_deflection = 85

/datum/xeno_caste/Crusher/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 35
	melee_damage_upper = 45
	tacklemin = 4
	tacklemax = 7
	tackle_chance = 75
	health = 450
	maxHealth = 450
	plasma_gain = 30
	plasma_max = 400
	caste_desc = "It always has the right of way."
	armor_deflection = 90