//Crusher abilities
/datum/action/xeno_action/activable/stomp
	name = "Stomp (50)"
	action_icon_state = "stomp"
	ability_name = "stomp"

/datum/action/xeno_action/activable/stomp/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Crusher/X = owner
	if(world.time >= X.has_screeched + CRUSHER_STOMP_COOLDOWN)
		return TRUE

/datum/action/xeno_action/activable/stomp/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Crusher/X = owner
	X.stomp()

/datum/action/xeno_action/ready_charge
	name = "Toggle Charging"
	action_icon_state = "ready_charge"
	plasma_cost = 0

/datum/action/xeno_action/ready_charge/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state()) return FALSE
	if(X.legcuffed)
		to_chat(src, "<span class='xenodanger'>You can't charge with that thing on your leg!</span>")
		X.is_charging = 0
	else
		X.is_charging = !X.is_charging
		to_chat(X, "<span class='xenonotice'>You will [X.is_charging ? "now" : "no longer"] charge when moving.</span>")

// Crusher Crest Toss
/datum/action/xeno_action/activable/cresttoss
	name = "Crest Toss"
	action_icon_state = "cresttoss"
	ability_name = "crest toss"

/datum/action/xeno_action/activable/cresttoss/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.cresttoss(A)

/datum/action/xeno_action/activable/cresttoss/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	return !X.cresttoss_used
