//Runner Code - Colonial Marines - Last Edit: Apophis775 - 11JUN16

/mob/living/carbon/Xenomorph/Runner
	caste = "Runner"
	name = "Runner"
	desc = "A small red alien that looks like it could run fairly quickly..."
	icon = 'icons/xeno/xenomorph_64x64.dmi' //They are now like, 2x1 or something
	icon_state = "Runner Walking"
	melee_damage_lower = 10
	melee_damage_upper = 20
	health = 100
	maxHealth = 100
	plasma_stored = 50
	plasma_gain = 1
	plasma_max = 100
	evolution_threshold = 100
	upgrade_threshold = 100
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	speed = -1.8
	evolves_to = list("Lurker")
	charge_type = 1 //Pounce - Runner
	flags_pass = PASSTABLE
	attack_delay = -4
	tier = 1
	t_squish_level = 1	//This variable is used to determine what will happen with alien after tank bumps into it.
	//0 - always just drive over the thing (currently larva only)
	//1 - very squishy and/or relatively light alien, (light tank can throw it away, heavy tank will straight drive over it)
	//2 - average alien, quite tough (light tank won't knock this one down, just push it one tile, other tank classes will push one tile and knock down)
	//3 - fortified alien, big and heavy will block light and medium tank, however heavy tank won't be blocked.
	upgrade = 0
	pixel_x = -16  //Needed for 2x2
	old_x = -16
	pull_speed = -0.6
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/xenohide,
		/datum/action/xeno_action/activable/pounce,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
