/datum/xeno_caste
	var/name = "Xenomorph"
	var/desc = "The workhorse of the hive."
	var/eldery = "Young"
	var/caste_type = /mob/living/carbon/Xenomorph/Drone
	var/next_upgrade = null

	var/melee_damage_lower = 12
	var/melee_damage_upper = 16
	var/health = 120
	var/maxHealth = 120
	var/plasma_max = 800
	var/plasma_gain = 20
	var/upgrade_threshold = 400
	var/caste_desc = ""						//flavor desc
	var/armor_deflection = 5
	var/tacklemin = 3
	var/tacklemax = 5
	var/tackle_chance = 60
	var/speed = -0.9
	var/aura_strength = 0
	var/spit_delay = 0
	var/bomb_strength = 0
	var/pounce_delay = 40
	var/attack_delay = 0
	var/queen_leader_limit = 0

	var/evolution_allowed = TRUE

/datum/xeno_caste/proc/apply_caste(mob/living/carbon/Xenomorph/X)
	X.caste = src
	X.caste_desc = caste_desc
	X.caste_path = next_upgrade

	X.melee_damage_lower = melee_damage_lower
	X.melee_damage_upper = melee_damage_upper
	X.health = health
	X.maxHealth = maxHealth
	X.plasma_max = plasma_max
	X.plasma_gain = plasma_gain
	X.upgrade_threshold = upgrade_threshold
	X.armor_deflection = armor_deflection
	X.tacklemin = tacklemin
	X.tacklemax = tacklemax
	X.tackle_chance = tackle_chance
	X.speed = speed
	X.aura_strength = aura_strength
	X.bomb_strength = bomb_strength
	X.pounce_delay = pounce_delay
	X.attack_delay = attack_delay
	X.queen_leader_limit = queen_leader_limit