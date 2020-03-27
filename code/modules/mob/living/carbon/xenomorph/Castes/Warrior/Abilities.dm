// Warrior Agility
/datum/action/xeno_action/activable/toggle_agility
	name = "Toggle Agility"
	action_icon_state = "agility_on"
	ability_name = "toggle agility"

/datum/action/xeno_action/activable/toggle_agility/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	X.toggle_agility()

/datum/action/xeno_action/activable/toggle_agility/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_toggle_agility


// Warrior Lunge
/datum/action/xeno_action/activable/lunge
	name = "Lunge"
	action_icon_state = "lunge"
	ability_name = "lunge"

/datum/action/xeno_action/activable/lunge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.lunge(A)

/datum/action/xeno_action/activable/lunge/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_lunge


// Warrior Fling
/datum/action/xeno_action/activable/fling
	name = "Fling"
	action_icon_state = "fling"
	ability_name = "Fling"

/datum/action/xeno_action/activable/fling/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.fling(A)

/datum/action/xeno_action/activable/fling/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_fling


// Warrior Punch
/datum/action/xeno_action/activable/punch
	name = "Punch"
	action_icon_state = "punch"
	ability_name = "punch"

/datum/action/xeno_action/activable/punch/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.punch(A)

/datum/action/xeno_action/activable/punch/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.used_punch