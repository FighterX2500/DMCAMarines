/datum/xeno_caste/Ravager
	name = "Ravager"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Ravager
	next_upgrade = /datum/xeno_caste/Ravager/mature

	melee_damage_lower = 25
	melee_damage_upper = 35
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 70
	health = 200
	maxHealth = 200
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 400
	evolution_allowed = FALSE
	caste_desc = "A brutal, devastating front-line attacker."
	speed = -0.7 //Not as fast as runners, but faster than other xenos.
	armor_deflection = 40
	attack_delay = -2

/datum/xeno_caste/Ravager/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Ravager/elder

	melee_damage_lower = 50
	melee_damage_upper = 70
	health = 220
	maxHealth = 220
	plasma_gain = 10
	plasma_max = 150
	upgrade_threshold = 800
	caste_desc = "A brutal, devastating front-line attacker. It looks a little more dangerous."
	speed = -0.8
	armor_deflection = 45
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 75

/datum/xeno_caste/Ravager/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Ravager/ancient

	melee_damage_lower = 60
	melee_damage_upper = 80
	health = 250
	maxHealth = 250
	plasma_gain = 15
	plasma_max = 200
	upgrade_threshold = 1600
	caste_desc = "A brutal, devastating front-line attacker. It looks pretty strong."
	speed = -0.9
	armor_deflection = 50
	tacklemin = 5
	tacklemax = 7
	tackle_chance = 80

/datum/xeno_caste/Ravager/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 80
	melee_damage_upper = 100
	health = 350
	maxHealth = 350
	plasma_gain = 15
	plasma_max = 200
	caste_desc = "As I walk through the valley of the shadow of death."
	speed = -1.0
	armor_deflection = 50
	tacklemin = 5
	tacklemax = 10
	tackle_chance = 90