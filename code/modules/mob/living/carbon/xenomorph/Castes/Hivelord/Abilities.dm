/datum/action/xeno_action/activable/secrete_resin/hivelord
	name = "Secrete Resin (100)"
	resin_plasma_cost = 100

/datum/action/xeno_action/emit_pheromones
	name = "Emit Pheromones (30)"
	action_icon_state = "emit_pheromones"
	plasma_cost = 30

/datum/action/xeno_action/emit_pheromones/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.is_mob_incapacitated() && !X.lying && !X.buckled && (!X.current_aura || X.plasma_stored >= plasma_cost) && !X.stagger)
		return TRUE

/datum/action/xeno_action/emit_pheromones/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state())
		return

	if(X.current_aura)
		X.current_aura = null
		X.visible_message("<span class='xenowarning'>\The [X] stops emitting pheromones.</span>", \
		"<span class='xenowarning'>You stop emitting pheromones.</span>", null, 5)
	else
		if(!X.check_plasma(30))
			return
		var/choice = input(X, "Choose a pheromone") in X.aura_allowed + "help" + "cancel"
		if(choice == "help")
			to_chat(X, "<span class='notice'><br>Pheromones provide a buff to all Xenos in range at the cost of some stored plasma every second, as follows:<br><B>Frenzy</B> - Increased run speed, damage and tackle chance.<br><B>Warding</B> - Increased armor, reduced incoming damage and critical bleedout.<br><B>Recovery</B> - Increased plasma and health regeneration.<br></span>")
			return
		if(choice == "cancel") return
		if(!X.check_state()) return
		if(X.current_aura) //If they are stacking windows, disable all input
			return
		if(!X.check_plasma(30))
			return
		X.use_plasma(30)
		X.current_aura = choice
		X.visible_message("<span class='xenowarning'>\The [X] begins to emit strange-smelling pheromones.</span>", \
		"<span class='xenowarning'>You begin to emit '[choice]' pheromones.</span>", null, 5)
		playsound(X.loc, "alien_drool", 25)

	if(X.hivenumber && X.hivenumber <= hive_datum.len)
		var/datum/hive_status/hive = hive_datum[X.hivenumber]

		if(isXenoQueen(X) && hive.xeno_leader_list.len && X.anchored)
			var/mob/living/carbon/Xenomorph/Queen/Q = X
			for(var/mob/living/carbon/Xenomorph/L in hive.xeno_leader_list)
				L.handle_xeno_leader_pheromones(Q)

/datum/action/xeno_action/activable/transfer_plasma/hivelord
	plasma_transfer_amount = 200
	transfer_delay = 5
	max_range = 7

/datum/action/xeno_action/toggle_speed
	name = "Resin Walker (50)"
	action_icon_state = "toggle_speed"
	plasma_cost = 50

/datum/action/xeno_action/toggle_speed/can_use_action()
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(X && !X.is_mob_incapacitated() && !X.lying && !X.buckled && (X.speed_activated || X.plasma_stored >= plasma_cost) && !X.stagger)
		return TRUE

/datum/action/xeno_action/toggle_speed/action_activate()
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(!X.check_state())
		return

	if(X.speed_activated)
		to_chat(X, "<span class='warning'>You feel less in tune with the resin.</span>")
		X.speed_activated = 0
		return

	if(!X.check_plasma(50))
		return
	X.speed_activated = 1
	X.use_plasma(50)
	to_chat(X, "<span class='notice'>You become one with the resin. You feel the urge to run!</span>")

/datum/action/xeno_action/build_tunnel
	name = "Dig Tunnel (200)"
	action_icon_state = "build_tunnel"
	plasma_cost = 200

/datum/action/xeno_action/build_tunnel/can_use_action()
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(X.tunnel_delay) return FALSE
	return ..()

/datum/action/xeno_action/build_tunnel/action_activate()
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(!X.check_state())
		return

	if(X.action_busy)
		to_chat(X, "<span class='warning'>You should finish up what you're doing before digging.</span>")
		return

	var/turf/T = X.loc
	if(!istype(T)) //logic
		to_chat(X, "<span class='warning'>You can't do that from there.</span>")
		return

	if(!T.can_dig_xeno_tunnel())
		to_chat(X, "<span class='warning'>You scrape around, but you can't seem to dig through that kind of floor.</span>")
		return

	if(locate(/obj/structure/tunnel) in X.loc)
		to_chat(X, "<span class='warning'>There already is a tunnel here.</span>")
		return

	if(X.tunnel_delay)
		to_chat(X, "<span class='warning'>You are not ready to dig a tunnel again.</span>")
		return

	if(X.get_active_hand())
		to_chat(X, "<span class='xenowarning'>You need an empty claw for this!</span>")
		return

	if(!X.check_plasma(200))
		return

	X.visible_message("<span class='xenonotice'>[X] begins digging out a tunnel entrance.</span>", \
	"<span class='xenonotice'>You begin digging out a tunnel entrance.</span>", null, 5)
	if(!do_after(X, 100, TRUE, 5, BUSY_ICON_BUILD))
		to_chat(X, "<span class='warning'>Your tunnel caves in as you stop digging it.</span>")
		return
	if(!X.check_plasma(200))
		return
	if(!X.start_dig) //Let's start a new one.
		X.visible_message("<span class='xenonotice'>\The [X] digs out a tunnel entrance.</span>", \
		"<span class='xenonotice'>You dig out the first entrance to your tunnel.</span>", null, 5)
		X.start_dig = new /obj/structure/tunnel(T)
	else
		to_chat(X, "<span class='xenonotice'>You dig your tunnel all the way to the original entrance, connecting both entrances!</span>")
		var/obj/structure/tunnel/newt = new /obj/structure/tunnel(T)
		newt.other = X.start_dig
		X.start_dig.other = newt //Link the two together
		X.start_dig = null //Now clear it
		X.tunnel_delay = 1
		spawn(2400)
			to_chat(X, "<span class='notice'>You are ready to dig a tunnel again.</span>")
			X.tunnel_delay = 0
		var/msg = copytext(sanitize(input("Add a description to the tunnel:", "Tunnel Description") as text|null), 1, MAX_MESSAGE_LEN)
		if(msg)
			newt.other.tunnel_desc = msg
			newt.tunnel_desc = msg

	X.use_plasma(200)
	playsound(X.loc, 'sound/weapons/pierce.ogg', 25, 1)

//Make some xenobots
/datum/action/xeno_action/plant_spawner
	name = "Plant Colony (500)"
	action_icon_state = "dug_spawner"
	plasma_cost = 500

/datum/action/xeno_action/plant_spawner/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X.check_state()) return

	var/turf/T = X.loc

	if(!istype(T) || X.z == 3 || istype(T, /turf/open/floor/plating/almayer) || istype(T, /turf/open/shuttle))
		to_chat(X, "<span class='warning'>You can't do that here.</span>")
		return

	var/obj/structure/alien_spawner/SPW = locate() in range(15)
	if(SPW)
		to_chat(X, "<span class='warning'>There is tunnel nearby!</span>")
		return

	if(!T.is_weedable())
		to_chat(X, "<span class='warning'>Bad place for a colony!</span>")
		return

	if(locate(/obj/effect/alien/weeds) in T)
		X.use_plasma(500)
		X.visible_message("<span class='xenonotice'>\The [X] dug a tunnel on the ground!</span>", \
		"<span class='xenonotice'>You dug a tunnel on the ground!</span>", null, 5)
		new /obj/structure/alien_spawner(X.loc)
		return
	else
		to_chat(X, "<span class='warning'>We can dig a tunnel only in weed's presense!</span>")
		return