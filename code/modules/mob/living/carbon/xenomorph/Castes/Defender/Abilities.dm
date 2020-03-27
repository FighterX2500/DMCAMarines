// Defender Headbutt
/datum/action/xeno_action/activable/headbutt
	name = "Headbutt"
	action_icon_state = "headbutt"
	ability_name = "headbutt"

/datum/action/xeno_action/activable/headbutt/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.headbutt(A)

/datum/action/xeno_action/activable/headbutt/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_headbutt


// Defender Tail Sweep
/datum/action/xeno_action/activable/tail_sweep
	name = "Tail Sweep"
	action_icon_state = "tail_sweep"
	ability_name = "tail sweep"

/datum/action/xeno_action/activable/tail_sweep/use_ability()
	var/mob/living/carbon/Xenomorph/X = owner
	X.tail_sweep()

/datum/action/xeno_action/activable/tail_sweep/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_tail_sweep


// Defender Toggle Crest Defense
/datum/action/xeno_action/activable/toggle_crest_defense
	name = "Toggle Crest Defense"
	action_icon_state = "crest_defense"
	ability_name = "toggle crest defense"

/datum/action/xeno_action/activable/toggle_crest_defense/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	X.toggle_crest_defense()

/datum/action/xeno_action/activable/toggle_crest_defense/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_crest_defense


// Defender Fortify
/datum/action/xeno_action/activable/fortify
	name = "Fortify"
	action_icon_state = "fortify"	// TODO
	ability_name = "fortify"

/datum/action/xeno_action/activable/fortify/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	X.fortify()

/datum/action/xeno_action/activable/fortify/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_fortify