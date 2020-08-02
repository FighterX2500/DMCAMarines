/datum/xeno_caste/Praetorian
	name = "Praetorian"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Praetorian
	next_upgrade = /datum/xeno_caste/Praetorian/mature

	melee_damage_lower = 15
	melee_damage_upper = 25
	tacklemin = 3
	tacklemax = 8
	tackle_chance = 75
	health = 250
	maxHealth = 250
	plasma_gain = 25
	plasma_max = 800
	upgrade_threshold = 400
	evolution_allowed = FALSE
	spit_delay = 20
	aura_strength = 1.5

/datum/xeno_caste/Praetorian/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Praetorian/elder

	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 220
	maxHealth = 220
	plasma_gain = 30
	plasma_max = 900
	upgrade_threshold = 800
	spit_delay = 15
	caste_desc = "A giant ranged monster. It looks a little more dangerous."
	armor_deflection = 40
	tacklemin = 5
	tacklemax = 8
	tackle_chance = 75
	speed = 0.0
	aura_strength = 2.5

/datum/xeno_caste/Praetorian/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Praetorian/ancient

	melee_damage_lower = 30
	melee_damage_upper = 35
	health = 250
	maxHealth = 250
	plasma_gain = 40
	plasma_max = 1000
	upgrade_threshold = 1600
	spit_delay = 10
	caste_desc = "A giant ranged monster. It looks pretty strong."
	armor_deflection = 45
	tacklemin = 6
	tacklemax = 9
	tackle_chance = 80
	speed = -0.1
	aura_strength = 3.5

/datum/xeno_caste/Praetorian/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 40
	melee_damage_upper = 50
	health = 270
	maxHealth = 270
	plasma_gain = 50
	plasma_max = 1000
	spit_delay = 0
	caste_desc = "Its mouth looks like a minigun."
	armor_deflection = 45
	tacklemin = 7
	tacklemax = 10
	tackle_chance = 85
	speed = -0.2
	aura_strength = 4.5