/obj/machinery/computer/cargodrop
	name = "Crate Drop Console"
	desc = "Console for dropping supply crates."
	icon_state = "dummy"
	req_access = list(ACCESS_MARINE_CARGO)

	var/datum/squad/current_squad = null
	var/x_offset_s = 0
	var/y_offset_s = 0
	var/busy = 0

/obj/machinery/computer/cargodrop/attackby(var/obj/I as obj, var/mob/user as mob)  //Can't break or disassemble.
	return

/obj/machinery/computer/cargodrop/bullet_act(var/obj/item/projectile/Proj) //Can't shoot it
	return 0

/obj/machinery/computer/cargodrop/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)


/obj/machinery/computer/cargodrop/attack_paw(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/cargodrop/attack_hand(mob/user)
	if(..())  //Checks for power outages
		return

	user.set_interaction(src)
	if(!allowed(user))
		to_chat(user, "\red You don't have access.")
		return

	var/dat = "<head><title>Crate Drop Console</title></head><body>"
	if(!current_squad) //No squad has been set yet. Pick one.
		dat += "Current Squad: <A href='?src=\ref[src];operation=pick_squad'>----------</A><BR>"
	else
		dat += "Current Squad: <A href='?src=\ref[src];operation=cancel_squad'>[current_squad.name] Squad</A><BR>"
		dat += "<B>Current Supply Drop Status:</B> "
		var/cooldown_left = (current_squad.supply_cooldown + 5000) - world.time
		if(cooldown_left > 0)
			dat += "Launch tubes resetting ([round(cooldown_left/10)] seconds)<br>"
		else
			dat += "<font color='green'>Ready!</font><br>"
		dat += "<B>Launch Pad Status:</b> "
		var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc
		if(C)
			dat += "<font color='green'>Supply crate loaded</font><BR>"
		else
			dat += "Empty<BR>"
		dat += "<B>Supply Beacon Status:</b> "
		if(current_squad.sbeacon)
			if(istype(current_squad.sbeacon.loc,/turf))
				dat += "<font color='green'>Transmitting!</font><BR>"
			else
				dat += "Not Transmitting<BR>"
		else
			dat += "Not Transmitting<BR>"
		dat += "<B>X-Coordinate Offset:</B> [x_offset_s] <A href='?src=\ref[src];operation=supply_x'>\[Change\]</a><BR>"
		dat += "<B>Y-Coordinate Offset:</B> [y_offset_s] <A href='?src=\ref[src];operation=supply_y'>\[Change\]</a><BR>"
		dat += "<A href='?src=\ref[src];operation=dropsupply'>\[LAUNCH!\]</a>"
	dat += "<BR>----------------------<BR></Body>"
	dat += "<A href='?src=\ref[src];operation=refresh'>{Refresh}</a></Body>"

	user << browse((dat), "window=supplydrop;size=550x550")
	onclose(user, "supplydrop")
	return

/obj/machinery/computer/cargodrop/Topic(href, href_list)
	if(..())
		return

	if(!href_list["operation"])
		return

	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_interaction(src)

	switch(href_list["operation"])
		if("pick_squad")
			if(current_squad)
				to_chat(usr, "<span class='warning'>\icon[src] You are already selecting a squad.</span>")
			else
				var/list/squad_list = list()
				for(var/datum/squad/S in RoleAuthority.squads)
					if(S.usable)
						squad_list += S.name

				var/name_sel = input("To which squad would you like to drop the crate?") as null|anything in squad_list
				if(!name_sel) return
				if(current_squad)
					to_chat(usr, "<span class='warning'>\icon[src] You are already selecting a squad.</span>")
					return
				var/datum/squad/selected = get_squad_by_name(name_sel)
				if(selected)
					current_squad = selected
					attack_hand(usr)
					if(!current_squad.drop_pad) //Why the hell did this not link?
						for(var/obj/structure/supply_drop/S in item_list)
							S.force_link() //LINK THEM ALL!

				else
					to_chat(usr, "\icon[src] <span class='warning'>Invalid input. Aborting.</span>")
		if("supply_x")
			var/input = input(usr,"What X-coordinate offset between -5 and 5 would you like? (Positive means east)","X Offset",0) as num
			if(input > 5) input = 5
			if(input < -5) input = -5
			to_chat(usr, "\icon[src] <span class='notice'>X-offset is now [input].</span>")
			src.x_offset_s = input
		if("supply_y")
			var/input = input(usr,"What Y-coordinate offset between -5 and 5 would you like? (Positive means north)","Y Offset",0) as num
			if(input > 5) input = 5
			if(input < -5) input = -5
			to_chat(usr, "\icon[src] <span class='notice'>Y-offset is now [input].</span>")
			y_offset_s = input
		if("refresh")
			src.attack_hand(usr)
		if("dropsupply")
			if(current_squad)
				if((current_squad.supply_cooldown + 5000) > world.time)
					to_chat(usr, "\icon[src] <span class='warning'>Supply drop not yet available!</span>")
				else
					handle_supplydrop()
		if("cancel_squad")
			if(current_squad)
				current_squad = null
			else
				to_chat(usr, "<span class='warning'>\icon[src] Squad is not selected.</span>")
	attack_hand(usr)

/obj/machinery/computer/cargodrop/proc/handle_supplydrop()
	if(!usr)
		return

	if(busy)
		to_chat(usr, "\icon[src] <span class='warning'>The [name] is busy processing another action!</span>")
		return

	if(!current_squad.sbeacon)
		to_chat(usr, "\icon[src] <span class='warning'>No supply beacon detected!</span>")
		return

	var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc //This thing should ALWAYS exist.
	if(!istype(C))
		to_chat(usr, "\icon[src] <span class='warning'>No crate was detected on the drop pad. Get Requisitions on the line!</span>")
		return

	if(!isturf(current_squad.sbeacon.loc))
		to_chat(usr, "\icon[src] <span class='warning'>The [current_squad.sbeacon.name] was not detected on the ground.</span>")
		return

	var/area/A = get_area(current_squad.bbeacon)
	if(A && A.ceiling >= CEILING_DEEP_UNDERGROUND)
		to_chat(usr, "\icon[src] <span class='warning'>The [current_squad.sbeacon.name]'s signal is too weak. It is probably deep underground.</span>")
		return

	var/turf/T = get_turf(current_squad.sbeacon)

	if(istype(T, /turf/open/space) || T.density)
		to_chat(usr, "\icon[src] <span class='warning'>The [current_squad.sbeacon.name]'s landing zone appears to be obstructed or out of bounds.</span>")
		return

	var/x_offset = x_offset_s
	var/y_offset = y_offset_s
	x_offset = round(x_offset)
	y_offset = round(y_offset)
	if(x_offset < -5 || x_offset > 5) x_offset = 0
	if(y_offset < -5 || y_offset > 5) y_offset = 0
	x_offset += rand(-2,2) //Randomize the drop zone a little bit.
	y_offset += rand(-2,2)

	busy = 1

	visible_message("\icon[src] <span class='boldnotice'>'[C.name]' supply drop is now loading into the launch tube! Stand by!</span>")
	C.visible_message("<span class='warning'>\The [C] begins to load into a launch tube. Stand clear!</span>")
	C.anchored = TRUE //to avoid accidental pushes
	send_to_squad("Supply Drop Incoming!")
	current_squad.sbeacon.visible_message("\icon[src] <span class='boldnotice'>The [current_squad.sbeacon.name] begins to beep!</span>")
	var/datum/squad/S = current_squad //in case the operator changes the overwatched squad mid-drop
	spawn(100)
		if(!C || C.loc != S.drop_pad.loc) //Crate no longer on pad somehow, abort.
			if(C) C.anchored = FALSE
			to_chat(usr, "\icon[src] <span class='warning'>Launch aborted! No crate detected on the drop pad.</span>")
			return
		S.supply_cooldown = world.time

		if(S.sbeacon)
			cdel(S.sbeacon) //Wipe the beacon. It's only good for one use.
			S.sbeacon = null
		playsound(C.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehh
		C.anchored = FALSE
		C.z = T.z
		C.x = T.x + x_offset
		C.y = T.y + x_offset
		var/turf/TC = get_turf(C)
		TC.ceiling_debris_check(3)
		playsound(C.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehhhhhhhhh.
		C.visible_message("\icon[C] <span class='boldnotice'>The [C.name] falls from the sky!</span>")
		visible_message("\icon[src] <span class='boldnotice'>'[C.name]' supply drop launched! Another launch will be available in five minutes.</span>")
		busy = 0

/obj/machinery/computer/cargodrop/proc/send_to_squad(var/txt = "", var/plus_name = 0, var/only_leader = 0)
	if(txt == "" || !current_squad) return //Logic

	var/text = copytext(sanitize(txt), 1, MAX_MESSAGE_LEN)
	var/nametext = ""
	if(plus_name)
		nametext = "[usr.name] transmits: "
		text = "<font size='3'><b>[text]<b></font>"

	for(var/mob/living/carbon/human/M in current_squad.marines_list)
		if(!M.stat && M.client) //Only living and connected people in our squad
			if(!only_leader)
				if(plus_name)
					M << sound('sound/effects/radiostatic.ogg')
				to_chat(M, "\icon[src] <font color='blue'><B>\[Overwatch\]:</b> [nametext][text]</font>")
			else
				if(current_squad.squad_leader == M)
					if(plus_name)
						M << sound('sound/effects/radiostatic.ogg')
					to_chat(M, "\icon[src] <font color='blue'><B>\[SL Overwatch\]:</b> [nametext][text]</font>")
					return