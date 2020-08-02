/datum/xeno_caste/Defender
	name = "Defender"
	eldery = "Young"
	caste_type = /mob/living/carbon/Xenomorph/Defender
	next_upgrade = /datum/xeno_caste/Defender/mature

	melee_damage_lower = 15
	melee_damage_upper = 25
	health = 250
	maxHealth = 250
	plasma_gain = 8
	plasma_max = 100
	armor_deflection = 40
	upgrade_threshold = 100
	caste_desc = "A sturdy front line combatant."
	speed = -0.2

/datum/xeno_caste/Defender/mature
	eldery = "Mature"
	next_upgrade = /datum/xeno_caste/Defender/elder

	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 275
	maxHealth = 275
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 150
	caste_desc = "An alien with an armored head crest. It looks a little more dangerous."
	speed = -0.3
	armor_deflection = 45

/datum/xeno_caste/Defender/elder
	eldery = "Elder"
	next_upgrade = /datum/xeno_caste/Defender/ancient

	melee_damage_lower = 25
	melee_damage_upper = 35
	health = 300
	maxHealth = 300
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 300
	caste_desc = "An alien with an armored head crest. It looks pretty strong."
	speed = -0.4
	armor_deflection = 50

/datum/xeno_caste/Defender/ancient
	eldery = "Ancient"
	next_upgrade = null

	health = 325
	maxHealth = 325
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 600
	caste_desc = "An unstoppable force that remains when others would fall."
	speed = -0.4
	armor_deflection = 55