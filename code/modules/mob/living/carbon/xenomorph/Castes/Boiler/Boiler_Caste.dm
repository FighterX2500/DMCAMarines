/datum/xeno_caste/Boiler
	name = "Boiler"
	eldery = "Young"
	desc = "A huge, grotesque xenomorph covered in glowing, oozing acid slime."
	caste_type = /mob/living/carbon/Xenomorph/Boiler
	next_upgrade = /datum/xeno_caste/Boiler/mature

	melee_damage_lower = 12
	melee_damage_upper = 15
	tacklemin = 2
	tacklemax = 4
	tackle_chance = 60
	health = 180
	maxHealth = 180
	plasma_gain = 30
	plasma_max = 800
	upgrade_threshold = 400
	evolution_allowed = FALSE
	spit_delay = 40
	speed = 0.7
	armor_deflection = 20
	bomb_strength = 1.0

	evolution_allowed = FALSE

/datum/xeno_caste/Boiler/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Boiler/elder

	melee_damage_lower = 20
	melee_damage_upper = 25
	health = 200
	maxHealth = 200
	plasma_gain = 35
	plasma_max = 900
	upgrade_threshold = 600
	spit_delay = 30
	bomb_strength = 1.5
	caste_desc = "It looks a little more dangerous."
	armor_deflection = 30
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 65
	speed = 0.6

/datum/xeno_caste/Boiler/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Boiler/ancient

	melee_damage_lower = 30
	melee_damage_upper = 35
	health = 220
	maxHealth = 220
	plasma_gain = 40
	plasma_max = 1000
	upgrade_threshold = 1200
	spit_delay = 20
	bomb_strength = 2
	caste_desc = "It looks pretty strong."
	armor_deflection = 35
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 70
	speed = 0.5

/datum/xeno_caste/Boiler/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 35
	melee_damage_upper = 45
	health = 250
	maxHealth = 250
	plasma_gain = 50
	plasma_max = 1000
	spit_delay = 10
	bomb_strength = 2.5
	caste_desc = "A devestating piece of alien artillery."
	armor_deflection = 35
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 80
	speed = 0.4