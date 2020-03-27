// Pounce
/datum/action/xeno_action/activable/pounce
	name = "Pounce"
	action_icon_state = "pounce"
	ability_name = "pounce"

/datum/action/xeno_action/activable/pounce/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.Pounce(A)

/datum/action/xeno_action/activable/pounce/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.usedPounce

/datum/action/xeno_action/xenohide
	name = "Hide"
	action_icon_state = "xenohide"
	plasma_cost = 0

/datum/action/xeno_action/xenohide/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return
	if(X.layer != XENO_HIDING_LAYER)
		X.layer = XENO_HIDING_LAYER
		to_chat(X, "<span class='notice'>You are now hiding.</span>")
	else
		X.layer = MOB_LAYER
		to_chat(X, "<span class='notice'>You have stopped hiding.</span>")