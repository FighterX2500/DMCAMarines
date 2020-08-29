/datum/xeno_caste/Warrior
	name = "Warrior"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Warrior
	next_upgrade = /datum/xeno_caste/Warrior/mature

	melee_damage_lower = 30
	melee_damage_upper = 35
	health = 200
	maxHealth = 200
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 250
	caste_desc = "A powerful front line combatant."
	speed = -0.8
	armor_deflection = 30

/datum/xeno_caste/Warrior/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Warrior/elder

	melee_damage_lower = 35
	melee_damage_upper = 40
	health = 225
	maxHealth = 225
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 300
	caste_desc = "An alien with an armored carapace. It looks a little more dangerous."
	speed = -0.9
	armor_deflection = 35

/datum/xeno_caste/Warrior/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Warrior/ancient

	melee_damage_lower = 40
	melee_damage_upper = 45
	health = 250
	maxHealth = 250
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 600
	caste_desc = "An alien with an armored carapace. It looks pretty strong."
	speed = -1.0
	armor_deflection = 40

/datum/xeno_caste/Warrior/ancient
	eldery = "Ancient"
	next_upgrade = null

	melee_damage_lower = 45
	melee_damage_upper = 50
	health = 275
	maxHealth = 275
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 1200
	caste_desc = "An hulking beast capable of effortlessly breaking and tearing through its enemies."
	speed = -1.1
	armor_deflection = 45