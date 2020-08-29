/datum/xeno_caste/Runner
	name = "Runner"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Runner
	next_upgrade = /datum/xeno_caste/Runner/mature

	melee_damage_lower = 10
	melee_damage_upper = 20
	health = 100
	maxHealth = 100
	plasma_gain = 1
	plasma_max = 100
	upgrade_threshold = 100
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	speed = -1.8
	attack_delay = -4

/datum/xeno_caste/Runner/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Runner/elder

	melee_damage_lower = 15
	melee_damage_upper = 25
	health = 120
	maxHealth = 120
	plasma_gain = 2
	plasma_max = 150
	upgrade_threshold = 150
	caste_desc = "A fast, four-legged terror, but weak in sustained combat. It looks a little more dangerous."
	speed = -1.9
	armor_deflection = 5
	attack_delay = -4
	tacklemin = 2
	tacklemax = 4
	tackle_chance = 50
	pounce_delay = 35

/datum/xeno_caste/Runner/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Runner/ancient

	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 150
	maxHealth = 150
	plasma_gain = 2
	plasma_max = 200
	upgrade_threshold = 300
	caste_desc = "A fast, four-legged terror, but weak in sustained combat. It looks pretty strong."
	speed = -2.0
	armor_deflection = 10
	attack_delay = -4
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	pounce_delay = 30

/datum/xeno_caste/Runner/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 25
	melee_damage_upper = 35
	health = 200
	maxHealth = 200
	plasma_gain = 2
	plasma_max = 200
	caste_desc = "Not what you want to run into in a dark alley. It looks fucking deadly."
	speed = -2.1
	armor_deflection = 10
	attack_delay = -4
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 70
	pounce_delay = 25