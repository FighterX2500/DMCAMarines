/datum/xeno_caste/Queen
	name = "Queen"
	eldery = ""
	caste_type = /mob/living/carbon/Xenomorph/Queen
	next_upgrade = /datum/xeno_caste/Queen/mature

	melee_damage_lower = 30
	melee_damage_upper = 46
	tacklemin = 4
	tacklemax = 6
	tackle_chance = 80
	health = 300
	maxHealth = 300
	plasma_max = 700
	plasma_gain = 30
	speed = 0.6
	upgrade_threshold = 400
	evolution_allowed = FALSE
	armor_deflection = 45
	aura_strength = 2 //The Queen's aura is strong and stays so, and gets devastating late game. Climbs by 1 to 5
	caste_desc = "The biggest and baddest xeno. The Queen controls the hive and plants eggs"
	spit_delay = 25

/datum/xeno_caste/Queen/mature
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Queen/elder

	melee_damage_lower = 40
	melee_damage_upper = 55
	health = 320
	maxHealth = 320
	plasma_max = 800
	plasma_gain = 40
	upgrade_threshold = 800
	spit_delay = 20
	caste_desc = "The biggest and baddest xeno. The Queen controls the hive and plants eggs."
	armor_deflection = 50
	tacklemin = 5
	tacklemax = 7
	tackle_chance = 85
	speed = 0.5
	aura_strength = 3
	queen_leader_limit = 2

/datum/xeno_caste/Queen/elder
	name = "Empress"
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Queen/ancient

	melee_damage_lower = 50
	melee_damage_upper = 60
	health = 350
	maxHealth = 350
	plasma_max = 900
	plasma_gain = 50
	upgrade_threshold = 1600
	spit_delay = 15
	caste_desc = "The biggest and baddest xeno. The Empress controls multiple hives and planets."
	armor_deflection = 55
	tacklemin = 6
	tacklemax = 9
	tackle_chance = 90
	speed = 0.4
	aura_strength = 4
	queen_leader_limit = 3

/datum/xeno_caste/Queen/ancient
	name = "Empress"
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 70
	melee_damage_upper = 90
	health = 400
	maxHealth = 400
	plasma_max = 1000
	plasma_gain = 50
	spit_delay = 10
	caste_desc = "The most perfect Xeno form imaginable."
	armor_deflection = 55
	tacklemin = 7
	tacklemax = 10
	tackle_chance = 95
	speed = 0.3
	aura_strength = 5
	queen_leader_limit = 4