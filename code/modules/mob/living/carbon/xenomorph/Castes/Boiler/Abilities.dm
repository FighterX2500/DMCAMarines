/datum/action/xeno_action/activable/corrosive_acid/Boiler
	name = "Corrosive Acid (200)"
	acid_plasma_cost = 200
	acid_type = /obj/effect/xenomorph/acid/strong

/datum/action/xeno_action/activable/spray_acid
	name = "Spray Acid"
	action_icon_state = "spray_acid"
	ability_name = "spray acid"


/datum/action/xeno_action/activable/spray_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (isXenoPraetorian(owner))
		X.acid_spray_cone(A)
		return

	var/mob/living/carbon/Xenomorph/Boiler/B = X
	B.acid_spray(A)

/datum/action/xeno_action/activable/spray_acid/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner

	if (isXenoPraetorian(owner))
		return !X.used_acid_spray

	var/mob/living/carbon/Xenomorph/Boiler/B = X
	return !B.acid_cooldown

//Boiler abilities

/datum/action/xeno_action/toggle_long_range
	name = "Toggle Long Range Sight (20)"
	action_icon_state = "toggle_long_range"
	plasma_cost = 20

/datum/action/xeno_action/toggle_long_range/can_use_action()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	if(X && !X.is_mob_incapacitated() && !X.lying && !X.buckled && (X.is_zoomed || X.plasma_stored >= plasma_cost) && !X.stagger)
		return TRUE

/datum/action/xeno_action/toggle_long_range/action_activate()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	if(X.is_zoomed)
		X.zoom_out()
		X.visible_message("<span class='notice'>[X] stops looking off into the distance.</span>", \
		"<span class='notice'>You stop looking off into the distance.</span>", null, 5)
	else
		X.visible_message("<span class='notice'>[X] starts looking off into the distance.</span>", \
			"<span class='notice'>You start focusing your sight to look off into the distance.</span>", null, 5)
		if(!do_after(X, 20, FALSE)) return
		if(X.is_zoomed) return
		X.zoom_in()
		..()

/datum/action/xeno_action/toggle_bomb
	name = "Toggle Bombard Type"
	action_icon_state = "toggle_bomb0"
	plasma_cost = 0

/datum/action/xeno_action/toggle_bomb/action_activate()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	to_chat(X, "<span class='notice'>You will now fire [X.ammo.type == /datum/ammo/xeno/boiler_gas ? "corrosive acid. This is lethal!" : "neurotoxic gas. This is nonlethal."]</span>")
	button.overlays.Cut()
	if(X.ammo.type == /datum/ammo/xeno/boiler_gas)
		X.ammo = ammo_list[/datum/ammo/xeno/boiler_gas/corrosive]
		button.overlays += image('icons/mob/actions.dmi', button, "toggle_bomb1")
	else
		X.ammo = ammo_list[/datum/ammo/xeno/boiler_gas]
		button.overlays += image('icons/mob/actions.dmi', button, "toggle_bomb0")

/datum/action/xeno_action/bombard
	name = "Bombard"
	action_icon_state = "bombard"
	plasma_cost = 0

/datum/action/xeno_action/bombard/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner
	return !X.bomb_cooldown

/datum/action/xeno_action/bombard/action_activate()
	var/mob/living/carbon/Xenomorph/Boiler/X = owner

	if(X.is_bombarding)
		if(X.client)
			X.client.mouse_pointer_icon = initial(X.client.mouse_pointer_icon) //Reset the mouse pointer.
		X.is_bombarding = 0
		to_chat(X, "<span class='notice'>You relax your stance.</span>")
		return

	if(X.bomb_cooldown)
		to_chat(X, "<span class='warning'>You are still preparing another spit. Be patient!</span>")
		return

	if(!isturf(X.loc))
		to_chat(X, "<span class='warning'>You can't do that from there.</span>")
		return

	X.visible_message("<span class='notice'>\The [X] begins digging their claws into the ground.</span>", \
	"<span class='notice'>You begin digging yourself into place.</span>", null, 5)
	if(do_after(X, 30, FALSE, 5, BUSY_ICON_GENERIC))
		if(X.is_bombarding) return
		X.is_bombarding = 1
		X.visible_message("<span class='notice'>\The [X] digs itself into the ground!</span>", \
		"<span class='notice'>You dig yourself into place! If you move, you must wait again to fire.</span>", null, 5)
		X.bomb_turf = get_turf(X)
		if(X.client)
			X.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")
	else
		X.is_bombarding = 0
		if(X.client)
			X.client.mouse_pointer_icon = initial(X.client.mouse_pointer_icon)