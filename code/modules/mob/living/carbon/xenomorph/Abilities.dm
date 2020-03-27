// Resting
/datum/action/xeno_action/xeno_resting
	name = "Rest"
	action_icon_state = "resting"

//resting action can be done even when lying down
/datum/action/xeno_action/xeno_resting/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner

	if (!X || X.is_mob_incapacitated(1) || X.buckled || X.fortify || X.crest_defense)
		return

	return 1

/datum/action/xeno_action/xeno_resting/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.is_mob_incapacitated(TRUE))
		return

	X.resting = !X.resting
	to_chat(X, "\blue You are now [X.resting ? "resting" : "getting up"]")

// Regurgitate
/datum/action/xeno_action/regurgitate
	name = "Regurgitate"
	action_icon_state = "regurgitate"
	plasma_cost = 0

/datum/action/xeno_action/regurgitate/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(!isturf(X.loc))
		to_chat(X, "<span class='warning'>You cannot regurgitate here.</span>")
		return

	if(X.stomach_contents.len)
		for(var/mob/M in X.stomach_contents)
			X.stomach_contents.Remove(M)
			M.acid_damage = 0 //Reset the acid damage
			if(M.loc != X)
				continue
			M.forceMove(X.loc)

		X.visible_message("<span class='xenowarning'>\The [X] hurls out the contents of their stomach!</span>", \
		"<span class='xenowarning'>You hurl out the contents of your stomach!</span>", null, 5)
	else
		to_chat(X, "<span class='warning'>There's nothing in your belly that needs regurgitating.</span>")

/mob/living/carbon/Xenomorph/proc/add_abilities()
	if(actions && actions.len)
		for(var/action_path in actions)
			if(ispath(action_path))
				actions -= action_path
				var/datum/action/xeno_action/A = new action_path()
				A.give_action(src)