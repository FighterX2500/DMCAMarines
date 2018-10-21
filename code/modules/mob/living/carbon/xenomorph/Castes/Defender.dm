/mob/living/carbon/Xenomorph/Defender
	caste = "Defender"
	name = "Defender"
	desc = "A alien with an armored head crest."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Defender Walking"
	melee_damage_lower = 15
	melee_damage_upper = 25
	health = 250
	maxHealth = 250
	plasma_stored = 50
	plasma_gain = 8
	plasma_max = 100
	evolution_threshold = 100
	upgrade_threshold = 100
	caste_desc = "A sturdy front line combatant."
	speed = -0.2
	mob_size = MOB_SIZE_BIG
	pixel_x = -16
	old_x = -16
	evolves_to = list("Warrior")
	charge_type = 2 //Pounce - Hunter
	armor_deflection = 40
	tier = 1
	t_squish_level = 2	//This variable is used to determine what will happen with alien after tank bumps into it.
	//0 - always just drive over the thing (currently larva only)
	//1 - very squishy and/or relatively light alien, (light tank can throw it away, heavy tank will straight drive over it)
	//2 - average alien, quite tough (light tank won't knock this one down, just push it one tile, other tank classes will push one tile and knock down)
	//3 - fortified alien, big and heavy will block light and medium tank, however heavy tank won't be blocked.
	upgrade = 0
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/toggle_crest_defense,
		/datum/action/xeno_action/activable/fortify,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/activable/tail_sweep
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)

/mob/living/carbon/Xenomorph/Defender/update_icons()
	if (stat == DEAD)
		icon_state = "Defender Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Defender Sleeping"
		else
			icon_state = "Defender Knocked Down"
	else if (fortify)
		icon_state = "Defender Fortify"
	else if (crest_defense)
		icon_state = "Defender Crest"
	else
		if (m_intent == MOVE_INTENT_RUN)
			icon_state = "Defender Running"
		else
			icon_state = "Defender Walking"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
