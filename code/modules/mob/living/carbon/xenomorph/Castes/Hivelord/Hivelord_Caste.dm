/datum/xeno_caste/Hivelord
	name = "Hivelord"
	desc = "A huge ass xeno covered in weeds! Oh shit!"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Hivelord
	next_upgrade = /datum/xeno_caste/Hivelord/mature

	melee_damage_lower = 15
	melee_damage_upper = 20
	health = 220
	maxHealth = 220
	plasma_max = 800
	upgrade_threshold = 400
	evolution_allowed = FALSE
	plasma_gain = 35
	caste_desc = "A builder of REALLY BIG hives."
	speed = 0.4
	aura_strength = 1

/datum/xeno_caste/Hivelord/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Hivelord/elder

	melee_damage_lower = 15
	melee_damage_upper = 20
	health = 220
	maxHealth = 220
	plasma_max = 900
	plasma_gain = 40
	upgrade_threshold = 600
	caste_desc = "A builder of REALLY BIG hives. It looks a little more dangerous."
	armor_deflection = 10
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	speed = 0.3
	aura_strength = 1.5

/datum/xeno_caste/Hivelord/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Hivelord/ancient

	melee_damage_lower = 15
	melee_damage_upper = 20
	health = 250
	maxHealth = 250
	plasma_max = 1000
	plasma_gain = 50
	upgrade_threshold = 1200
	caste_desc = "A builder of REALLY BIG hives. It looks pretty strong."
	armor_deflection = 15
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 70
	speed = 0.2
	aura_strength = 2

/datum/xeno_caste/Hivelord/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 300
	maxHealth = 300
	plasma_max = 1200
	plasma_gain = 70
	caste_desc = "An extreme construction machine. It seems to be building walls..."
	armor_deflection = 20
	tacklemin = 5
	tacklemax = 7
	tackle_chance = 80
	speed = 0.1
	aura_strength = 2.5