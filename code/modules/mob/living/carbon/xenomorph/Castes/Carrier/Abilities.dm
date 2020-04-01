//Carrier Abilities

/datum/action/xeno_action/activable/throw_hugger
	name = "Use/Throw Facehugger"
	action_icon_state = "throw_hugger"
	ability_name = "throw facehugger"

/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.throw_hugger(A)

/datum/action/xeno_action/activable/throw_hugger/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	return !X.threw_a_hugger

/datum/action/xeno_action/activable/retrieve_egg
	name = "Retrieve Egg"
	action_icon_state = "retrieve_egg"
	ability_name = "retrieve egg"

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.retrieve_egg(A)

/datum/action/xeno_action/place_trap
	name = "Place hugger trap (200)"
	action_icon_state = "place_trap"
	plasma_cost = 200

/datum/action/xeno_action/place_trap/action_activate()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!X.check_state())
		return
	if(!X.check_plasma(plasma_cost))
		return
	var/turf/T = get_turf(X)

	if(!istype(T) || !T.is_weedable() || T.density)
		to_chat(X, "<span class='warning'>You can't do that here.</span>")
		return

	var/area/AR = get_area(T)
	if(istype(AR,/area/shuttle/drop1/lz1) || istype(AR,/area/shuttle/drop2/lz2) || istype(AR,/area/sulaco/hangar)) //Bandaid for atmospherics bug when Xenos build around the shuttles
		to_chat(X, "<span class='warning'>You sense this is not a suitable area for expanding the hive.</span>")
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in T

	if(!alien_weeds)
		to_chat(X, "<span class='warning'>You can only shape on weeds. Find some resin before you start building!</span>")
		return

	if(!X.check_alien_construction(T))
		return

	X.use_plasma(plasma_cost)
	playsound(X.loc, "alien_resin_build", 25)
	round_statistics.carrier_traps++
	new /obj/effect/alien/resin/trap(X.loc, X)
	to_chat(X, "<span class='xenonotice'>You place a hugger trap on the weeds, it still needs a facehugger.</span>")