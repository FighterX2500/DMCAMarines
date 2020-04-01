/datum/action/xeno_action/activable/xeno_spit
	name = "Xeno Spit"
	action_icon_state = "xeno_spit"
	ability_name = "xeno spit"

/datum/action/xeno_action/activable/xeno_spit/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	X.xeno_spit(A)

/datum/action/xeno_action/activable/xeno_spit/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.has_spat < world.time) return TRUE

// Shift Spits
/datum/action/xeno_action/shift_spits
	name = "Toggle Spit Type"
	action_icon_state = "shift_spit_neurotoxin"
	plasma_cost = 0

/datum/action/xeno_action/shift_spits/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return
	for(var/i in 1 to X.spit_types.len)
		if(X.ammo == ammo_list[X.spit_types[i]])
			if(i == X.spit_types.len)
				X.ammo = ammo_list[X.spit_types[1]]
			else
				X.ammo = ammo_list[X.spit_types[i+1]]
			break
	to_chat(X, "<span class='notice'>You will now spit [X.ammo.name] ([X.ammo.spit_cost] plasma).</span>")
	button.overlays.Cut()
	button.overlays += image('icons/mob/actions.dmi', button, "shift_spit_[X.ammo.icon_state]")