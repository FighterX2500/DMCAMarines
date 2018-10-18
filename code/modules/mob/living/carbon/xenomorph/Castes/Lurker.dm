//Hunter Code - Colonial Marines - Last Edit: Apophis775 - 11JUN16

/mob/living/carbon/Xenomorph/Lurker
	caste = "Lurker"
	name = "Lurker"
	desc = "A beefy, fast alien with sharp claws."
	icon = 'icons/Xeno/xenomorph_48x48.dmi'
	icon_state = "Lurker Walking"
	melee_damage_lower = 20
	melee_damage_upper = 30
	health = 150
	maxHealth = 150
	plasma_stored = 50
	plasma_gain = 8
	plasma_max = 100
	evolution_threshold = 250
	upgrade_threshold = 500
	caste_desc = "A fast, powerful front line combatant."
	speed = -1.5 //Not as fast as runners, but faster than other xenos
	pixel_x = -12
	old_x = -12
	evolves_to = list("Ravager")
	charge_type = 2 //Pounce - Hunter
	armor_deflection = 15
	attack_delay = -2
	pounce_delay = 55
	tier = 2
	t_squish_level = 1	//This variable is used to determine what will happen with alien after tank bumps into it.
	//0 - always just drive over the thing (currently larva only)
	//1 - very squishy and/or relatively light alien, (light tank can throw it away, heavy tank will straight drive over it)
	//2 - average alien, quite tough (light tank won't knock this one down, just push it one tile, other tank classes will push one tile and knock down)
	//3 - fortified alien, big and heavy will block light and medium tank, however heavy tank won't be blocked.
	upgrade = 0
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/pounce
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
