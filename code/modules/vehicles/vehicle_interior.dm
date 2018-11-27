//everything vehicle interior related will go here, even if object is not exactly inside of vehicle itself

//////////////////////////////////////////////////////////////////////
/obj/structure/vehicle_interior
	unacidable = 1
	anchored = TRUE

/obj/structure/vehicle_interior/side_door
	name = "Side Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/almayer/dropship2_pilot.dmi'
	icon_state = "door_closed"
	density = TRUE
	opacity = 1
	dir = 8
	var/obj/vehicle/multitile/root/cm_transport/apc/master
	var/side_door_busy = FALSE

/obj/structure/vehicle_interior/side_door/proc/activate(mob/user)

	if(user.loc != master.multitile_interior_exit.loc)
		return

	if(master.tile_blocked_check(get_turf(master.entrance)))
		to_chat(user, "<span class='notice'>Something blocks the door and you can't get out.</span>")
		return

	if(side_door_busy)
		to_chat(user, "<span class='notice'>Someone is in the doorway.</span>")
		return

	var/remove_module_role_entered = FALSE
	var/remove_tank_crewman_entered = FALSE
	var/passengers_left = 0
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/I = H.wear_id
		if(I.rank == "Tank Crewman" && master.tank_crewman_entered)
			remove_tank_crewman_entered = TRUE
		else
			if(I.rank == master.module_role && master.module_role_entered)
				remove_module_role_entered = TRUE
			else
				passengers_left++
	else
		if(!isXeno(user))
			passengers_left++

	var/move_pulling = FALSE
	if(user.pulling && get_dist(src, user.pulling) <= 2)
		move_pulling = TRUE
		if(isliving(user.pulling))
			to_chat(user, "<span class='danger'>user.pulling is alive.</span>")
			var/mob/living/B = user.pulling
			if(B.buckled)
				to_chat(user, "<span class='warning'>You can't fit [user.pulling] on the [B.buckled] through a doorway! Try unbuckling [user.pulling] first.</span>")
				return
			if(ishuman(user.pulling))
				to_chat(user, "<span class='danger'>user.pulling is human</span>")
				var/mob/living/carbon/human/H = user.pulling
				var/obj/item/card/id/I = H.wear_id
				if(I.rank == "Tank Crewman" && master.tank_crewman_entered)
					remove_tank_crewman_entered = TRUE
				else
					if(I.rank == master.module_role && master.module_role_entered)
						remove_module_role_entered = TRUE
					else
						passengers_left++
			else
				if(!isXeno(user.pulling))
					passengers_left++
		if(isobj(user.pulling))
			if((istype(user.pulling, /obj/structure) && !istype(user.pulling, /obj/structure/mortar) && !istype(user.pulling, /obj/structure/closet/bodybag)) || (istype(user.pulling, /obj/machinery) && !istype(user.pulling, /obj/machinery/marine_turret_frame) && !istype(user.pulling, /obj/machinery/marine_turret) && !istype(user.pulling, /obj/machinery/m56d_post) && !istype(user.pulling, /obj/machinery/m56d_hmg)))
				to_chat(user, "<span class='warning'>You can't fit the [user.pulling] through a doorway!</span>")
				return
			to_chat(user, "<span class='danger'>user.pulling is object.</span>")
			var/obj/O = user.pulling
			if(istype(O, /obj/structure/closet/bodybag))
				to_chat(user, "<span class='danger'>pulling bodybag.</span>")
				for(var/mob/living/B in O.contents)
					if(ishuman(B))
						var/mob/living/carbon/human/H = B
						var/obj/item/card/id/I = H.wear_id
						if(I.rank == "Tank Crewman" && master.tank_crewman_entered)
							remove_tank_crewman_entered = TRUE
						else
							if(I.rank == master.module_role && master.module_role_entered)
								remove_module_role_entered = TRUE
							else
								passengers_left++
					else
						if(!isXeno(user.pulling))
							passengers_left++
			if(O.buckled_mob)
				to_chat(user, "<span class='warning'>You can't fit [O.buckled_mob] on the [O] through a doorway! Try unbuckling [user.pulling] first.</span>")
				return

	side_door_busy = TRUE
	visible_message(user, "<span class='notice'>[user] starts climbing out of [src].</span>",
		"<span class='notice'>You start climbing out of [src].</span>")
	if(!do_after(user, 20, needhand = FALSE, show_busy_icon = TRUE))
		to_chat(user, "<span class='notice'>Something interrupted you while getting out.</span>")
		side_door_busy = FALSE
		return

	if(user.blinded || user.lying || user.buckled || user.anchored)
		side_door_busy = FALSE
		return

	if(user.loc != master.multitile_interior_exit.loc)
		to_chat(user, "<span class='notice'>You stop getting in.</span>")
		side_door_busy = FALSE
		return

	if(move_pulling)
		if(isliving(user.pulling))
			var/mob/living/P = user.pulling
			P.forceMove(master.entrance.loc) //Cannot use forceMove method on pulls! Move manually
			user.forceMove(master.entrance.loc)
			user.start_pulling(P)
		else
			var/obj/O = user.pulling
			O.forceMove(master.entrance.loc)
			user.forceMove(master.entrance.loc)
			user.start_pulling(O)
	else
		user.forceMove(master.entrance.loc)

	if(remove_module_role_entered)
		master.module_role_entered = FALSE
	if(remove_tank_crewman_entered)
		master.tank_crewman_entered = FALSE
	master.passengers -= passengers_left

	side_door_busy = FALSE
	return

/obj/structure/vehicle_interior/side_door/attack_hand(mob/user)
	activate(user)
	return

/obj/structure/vehicle_interior/side_door/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/explosive/grenade))
		var/obj/item/explosive/grenade/G = O
		user.visible_message("<span class='warning'>[user] takes position to throw [G] outside.</span>",
		"<span class='warning'>You take position to throw [G] outside.</span>")
		if(do_after(user, 10, TRUE, 5, BUSY_ICON_HOSTILE))
			user.visible_message("<span class='warning'>[user] throws [G] outside!</span>",
			"<span class='warning'>You throw [G] outside!</span>")
			user.drop_held_item()
			G.forceMove(master.entrance.loc)
			var/dir = turn(master.dir, -90)
			var/turf/T = get_step(master.entrance.loc, dir)
			G.throw_at(T, 3, 1, master, 0)
			G.det_time = 20
			if(!G.active)
				G.activate(user)
		return
	if(istype(O, /obj/item/device/flashlight))
		var/obj/item/device/flashlight/flare/F = O
		user.visible_message("<span class='warning'>[user] takes position to throw [F] outside.</span>",
		"<span class='warning'>You take position to throw [F] outside.</span>")
		if(do_after(user, 10, TRUE, 5, BUSY_ICON_HOSTILE))
			user.visible_message("<span class='warning'>[user] throws [F] outside!</span>",
			"<span class='warning'>You throw [F] outside!</span>")
			F.attack_self(user)
			user.drop_held_item()
			F.forceMove(master.entrance.loc)
			var/dir = turn(master.dir, -90)
			var/turf/T = get_step(master.entrance.loc, dir)
			F.throw_at(T, 3, 1, master, 0)
		return
	activate(user)
	return

/obj/structure/vehicle_interior/side_door/attack_alien(mob/living/carbon/Xenomorph/X)
	activate(X)
	return

/obj/structure/vehicle_interior/cabin_door
	name = "Cabin Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/almayer/dropship2_side.dmi'
	icon_state = "door_closed"
	density = TRUE
	opacity = 1
	var/obj/vehicle/multitile/root/cm_transport/apc/master

//Two seats, gunner and driver
//Only driver requires skills
/obj/structure/vehicle_interior/cabin_door/proc/activate(mob/user)

	if(isXenoLarva(user))
		return

	if(user.a_intent == "hurt" || isXeno(user))
		master.pulling_out_crew(user)
		return

	master.handle_player_entrance(user)

/obj/structure/vehicle_interior/cabin_door/attack_hand(mob/user)
	activate(user)
	return

/obj/structure/vehicle_interior/cabin_door/attack_alien(mob/living/carbon/Xenomorph/X)
	activate(X)
	return

/obj/structure/vehicle_interior/supply_receiver
	name = "Supply Drop Receiver Pad"
	desc = "Crates sent to APC will appear here."
	icon = 'icons/effects/warning_stripes.dmi'
	density = 0
	layer = ABOVE_TURF_LAYER

	var/obj/vehicle/multitile/root/cm_transport/apc/master

/obj/structure/vehicle_interior/supply_sender
	name = "Supply Drop Pad"
	desc = "Sends crate to working APC Receiver Pad."
	icon = 'icons/effects/warning_stripes.dmi'
	density = 0
	layer = ABOVE_TURF_LAYER

/obj/machinery/vehicle_interior/supply_sender_control
	name = "Send Supply Drop"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	req_one_access_txt = "1;21"
	anchored = 1
	unacidable = 1
	var/busy
	var/next_use = 0
	var/obj/structure/vehicle_interior/supply_sender/master
	var/obj/structure/vehicle_interior/supply_receiver/destination

/obj/machinery/vehicle_interior/supply_sender_control/attack_hand(mob/user)
	add_fingerprint(user)
	if(istype(user,/mob/living/carbon/Xenomorph))
		return

	icon_state = "doorctrl1"
	add_fingerprint(user)

	spawn(15)
		icon_state = "doorctrl0"

	if(busy)
		src.visible_message("<span class='boldnotice'>Request is being processed, standby.</span>")
		return
	busy = TRUE
	if(!free_modules.Find("Supply Modification") && destination.master.special_module_working || !destination || !master)
		var/obj/structure/closet/crate/C = locate(/obj/structure/closet/crate) in range(0, master)
		if(C && !C.opened)
			var/area/AR = get_area(destination.master)
			if(AR.ceiling < CEILING_METAL)
				if(next_use < world.time)
					var/apc_location = destination.master.loc
					src.visible_message("<span class='notice'>Supply Drop Receiver is found. Connection established. Calculating trajectiry... Complete.</span>")
					src.visible_message("<span class='boldnotice'>Supply drop is now loading into the launch tube! Stand by!</span>")
					playsound(master, pick('sound/machines/hydraulics_1.ogg', 'sound/machines/hydraulics_2.ogg'), 40, 1)
					spawn(100)
					if(destination.master.loc != apc_location)
						playsound(destination.master.loc,'sound/effects/bamf.ogg', 50, 1)
						destination.master.visible_message("\icon[src] <span class='boldnotice'>You notice [C.name] deploing on top of [destination.master] and gets loaded inside.</span>")
						C.forceMove(get_turf(destination))
						C.visible_message("\icon[C] <span class='boldnotice'>The [C.name] descends on elevator from [destination.master] roof through a hatch!</span>")
						playsound(destination, pick('sound/machines/hydraulics_1.ogg', 'sound/machines/hydraulics_2.ogg'), 40, 1)
						sleep(10)
						playsound(master, 'sound/machines/twobeep.ogg', 15, 1)
						src.visible_message("<span class='boldnotice'>Supply Drop Receiver confirmed receiving supply drop.</span>")
					else
						playsound(apc_location,'sound/effects/bamf.ogg', 50, 1)
						C.forceMove(get_turf(apc_location))
						sleep(10)
						playsound(master, 'sound/machines/twobeep.ogg', 15, 1)
						C.visible_message("\icon[C] <span class='boldnotice'>The [C.name] falls from the sky!</span>")
						src.visible_message("<span class='boldnotice'>Error. Supply Drop Receiver didn't confirm receiving supply drop.</span>")
					src.visible_message("<span class='boldnotice'>Supply drop launched! Another launch will be available in 2 minutes.</span>")

					next_use = world.time + 1200
					busy = FALSE
				else
					src.visible_message("<span class='warning'>Launch tubes resetting, please, standby.</span>")
					busy = FALSE
					return
			else
				src.visible_message("<span class='warning'>Unable to calculate trajectory! Receiver must be in open area!</span>")
				busy = FALSE
				return
		else
			src.visible_message("<span class='warning'>Crate is not prepared for drop.</span>")
			busy = FALSE
			return
	else
		src.visible_message("<span class='warning'>No active Receiver Pad located!</span>")
		busy = FALSE
		return



/obj/structure/bed/chair/comfy/beige/apc
	unacidable = 1

/obj/structure/bed/chair/comfy/beige/apc/attack_alien(mob/living/carbon/Xenomorph/M)
	return

/obj/structure/bed/chair/comfy/beige/apc/attackby(obj/item/W, mob/user)
	return

/obj/structure/bed/chair/comfy/black/apc
	unacidable = 1

/obj/structure/bed/chair/comfy/black/apc/attack_alien(mob/living/carbon/Xenomorph/M)
	return

/obj/structure/bed/chair/comfy/black/apc/attackby(obj/item/W, mob/user)
	return




// interior walls

/turf/closed/wall/indestructible/vehicle
	name = "vehicle hull"
	desc = "Armored hull of a vehicle."
	icon = 'icons/turf/walls_vehicle.dmi'
	icon_state = "hull"
	walltype = "metal"
	junctiontype //when walls smooth with one another, the type of junction each wall is.

	damage = 0
	damage_cap = 10000 //Wall will break down to girders if damage reaches this point

	max_temperature = 50000 //K, walls will take damage if they're next to a fire hotter than this