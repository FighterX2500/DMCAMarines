


//APCS, HURRAY
//Read the documentation in cm_transport.dm and multitile.dm before trying to decipher this stuff


/obj/vehicle/multitile/root/cm_transport/apc
	name = "M550-M APC"
	desc = "M550-M Armored Personnel Carrier. Combat transport for delivering and supporting infantry. Entrance on the right side."

	icon = 'icons/obj/apcarrier_NS.dmi'
	icon_state = "apc_base"
	pixel_x = -32
	pixel_y = -32

	var/named = FALSE
	var/list/passengers
	var/mob/gunner
	var/mob/driver

	var/obj/machinery/camera/camera = null	//Yay! Working camera in the apc!

	var/occupant_exiting = 0
	var/next_sound_play = 0

	luminosity = 7

/obj/effect/multitile_spawner/cm_transport/apc

	width = 3
	height = 3
	spawn_dir = EAST

/obj/effect/multitile_spawner/cm_transport/apc/New()

	var/obj/vehicle/multitile/root/cm_transport/apc/R = new(src.loc)
	R.dir = EAST

	var/datum/coords/dimensions = new
	dimensions.x_pos = width
	dimensions.y_pos = height
	var/datum/coords/root_pos = new
	root_pos.x_pos = 1
	root_pos.y_pos = 1

	//Entrance relative to the root object. The apc spawns with the root centered on the marker
	var/datum/coords/entr_mark = new
	entr_mark.x_pos = 0
	entr_mark.y_pos = -2

	R.load_hitboxes(dimensions, root_pos)
	R.load_entrance_marker(entr_mark)
	R.update_icon()

	R.camera = new /obj/machinery/camera(R)
	R.camera.network = list("almayer", "apc")	//changed network from military to almayer,because Cams computers on Almayer have this network
	R.camera.c_tag = "Armored Personnel Carrier ¹[rand(1,10)]" //ARMORED to be at the start of cams list, numbers in case of events with multiple vehicles

	del(src)

//Pretty similar to the previous one
//TODO: Make this code better and less repetetive
//Spawns a apc that has a bunch of broken hardpoints
/obj/effect/multitile_spawner/cm_transport/apc/decrepit/New()

	var/obj/vehicle/multitile/root/cm_transport/apc/R = new(src.loc)
	R.dir = EAST

	var/datum/coords/dimensions = new
	dimensions.x_pos = width
	dimensions.y_pos = height
	var/datum/coords/root_pos = new
	root_pos.x_pos = 1
	root_pos.y_pos = 1

	var/datum/coords/entr_mark = new
	entr_mark.x_pos = 0
	entr_mark.y_pos = -2

	R.load_hitboxes(dimensions, root_pos)
	R.load_entrance_marker(entr_mark)

	//Manually adding those hardpoints
	R.damaged_hps = list(
				"primary",
				"secondary",
				"support")

	R.update_icon()

	R.camera = new /obj/machinery/camera(R)
	R.camera.network = list("almayer", "apc")	//changed network from military to almayer, because Cams computers on Almayer have this network
	R.camera.c_tag = "Armored Personnel Carrier ¹[rand(1,10)]" //ARMORED to be at the start of cams list, numbers in case of events with multiple vehicles

	del(src)


//For the apc, start forcing people out if everything is broken
/obj/vehicle/multitile/root/cm_transport/apc/handle_all_modules_broken()
	deactivate_all_hardpoints()
	var/turf/T = get_turf(entrance)
	to_chat(driver, "<span class='danger'>You cannot breath in all the smoke inside the vehicle so you dismount!</span>")
	gunner.Move(T)
	to_chat(driver, "<span class='danger'>You cannot breath in all the smoke inside the vehicle so you dismount!</span>")
	driver.Move(T)
	if(gunner.client)
		gunner.client.mouse_pointer_icon = initial(gunner.client.mouse_pointer_icon)
	gunner.unset_interaction()
	gunner = null
	driver.unset_interaction()
	driver = null

/obj/vehicle/multitile/root/cm_transport/apc/remove_all_players()
	deactivate_all_hardpoints()
	if(!entrance) //Something broke, uh oh
		if(gunner) gunner.loc = src.loc
		if(driver) driver.loc = src.loc
	else
		if(gunner) gunner.forceMove(entrance.loc)
		if(driver) driver.forceMove(entrance.loc)

	if(gunner.client)
		gunner.client.mouse_pointer_icon = initial(gunner.client.mouse_pointer_icon)
	gunner = null
	driver = null

//megaphone proc. same as in tank
/obj/vehicle/multitile/root/cm_transport/apc/proc/use_megaphone(mob/living/user)
	var/spamcheck = 0
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(user, "\red You cannot speak in IC (muted).")
			return
	if(user.silent)
		return

	if(spamcheck)
		to_chat(user, "\red \The megaphone needs to recharge!")
		return

	var/message = copytext(sanitize(input(user, "Shout a message?", "Megaphone", null)  as text),1,MAX_MESSAGE_LEN)
	if(!message)
		return
	message = capitalize(message)
	log_admin("[key_name(user)] used a apc megaphone to say: >[message]<")
	if (usr.stat == 0)
		for(var/mob/living/carbon/human/O in (range(7,src)))
			if(O.species && O.species.name == "Yautja") //NOPE
				O.show_message("Some loud speech heard from the APC, but you can't understand it.")
				continue
			O.show_message("<B>apc</B> broadcasts, <FONT size=3>\"[message]\"</FONT>",2)
		for(var/mob/dead/observer/O in (range(7,src)))
			O.show_message("<B>apc</B> broadcasts, <FONT size=3>\"[message]\"</FONT>",2)
		for(var/mob/living/carbon/Xenomorph/X in (range(7,src)))
			X.show_message("Some loud tallhost noises heard from the metal turtle, but you can't understand it.")

		spamcheck = 1
		spawn(20)
			spamcheck = 0
		return

//little QoL won't be bad, aight?
/obj/vehicle/multitile/root/cm_transport/apc/verb/megaphone()
	set name = "Use Megaphone"
	set category = "Vehicle"	//changed verb category to new one, because Object category is bad.
	set src in view(0)
	if(usr != gunner && usr != driver)
		return
	use_megaphone(usr)

/*
//Built in smoke launcher system verb.
/obj/vehicle/multitile/root/cm_transport/apc/verb/smoke_cover()
	set name = "Activate Smoke Deploy System"
	set category = "Vehicle"	//changed verb category to new one, because Object category is bad.
	set src in view(0)

	if(usr != gunner && usr != driver)
		return

	if(smoke_ammo_current)
		to_chat(usr, "<span class='warning'>You activate Smoke Deploy System!</span>")
		visible_message("<span class='danger'>You notice two grenades flying in front of the apc!</span>")
		smoke_shot()
	else
		to_chat(usr, "<span class='warning'>Out of ammo! Reload smoke grenades magazine!</span>")
		return
*/

//Naming done right
/obj/vehicle/multitile/root/cm_transport/apc/verb/name_apc()
	set name = "Name The APC (Single Use)"
	set category = "Vehicle"	//changed verb category to new one, because Object category is bad.
	set src in view(0)

	if(usr != gunner && usr != driver)
		return

	if(named)
		to_chat(usr, "<span class='warning'>APC was already named!</span>")
		return
	var/nickname = copytext(sanitize(input(usr, "Name your APC (20 symbols, without \"\", they will be added), russian symbols won't be seen", "Naming", null) as text),1,20)
	if(!nickname)
		to_chat(usr, "<span class='warning'>No text entered!</span>")
		return
	if(!named)
		src.name += " \"[nickname]\""
	else
		to_chat(usr, "<span class='warning'>Other TC was quicker! APC already was named!</span>")
	named = TRUE

/obj/vehicle/multitile/root/cm_transport/apc/can_use_hp(var/mob/M)
	return (M == gunner)

/obj/vehicle/multitile/root/cm_transport/apc/handle_harm_attack(var/mob/M)

	if(M.loc != entrance.loc)	return

	if(!gunner && !driver)
		to_chat(M, "<span class='warning'>There is no one in the vehicle.</span>")
		return

	to_chat(M, "<span class='notice'>You start pulling [driver ? driver : gunner] out of their seat.</span>")

	if(!do_after(M, 200, show_busy_icon = BUSY_ICON_HOSTILE))
		to_chat(M, "<span class='warning'>You stop pulling [driver ? driver : gunner] out of their seat.</span>")
		return

	if(M.loc != entrance.loc) return

	if(!gunner && !driver)
		to_chat(M, "<span class='warning'>There is no longer anyone in the vehicle.</span>")
		return

	M.visible_message("<span class='warning'>[M] pulls [driver ? driver : gunner] out of their seat in [src].</span>",
		"<span class='notice'>You pull [driver ? driver : gunner] out of their seat.</span>")

	var/mob/targ
	if(driver)
		targ = driver
		driver = null
	else
		if(gunner.client)
			gunner.client.mouse_pointer_icon = initial(gunner.client.mouse_pointer_icon)
		targ = gunner
		gunner = null
	to_chat(targ, "<span class='danger'>[M] forcibly drags you out of your seat and dumps you on the ground!</span>")
	targ.forceMove(entrance.loc)
	targ.unset_interaction()
	targ.KnockDown(7, 1)


//Two seats, gunner and driver
//Must have the skills to do so
/obj/vehicle/multitile/root/cm_transport/apc/handle_player_entrance(var/mob/M)
	var/loc_check = M.loc
	var/slot = input("Select a seat") in list("Driver", "Gunner")

	if(!M || M.client == null) return

	if(!M.mind || !(!M.mind.cm_skills || M.mind.cm_skills.large_vehicle >= SKILL_LARGE_VEHICLE_TRAINED))
		to_chat(M, "<span class='notice'>You have no idea how to operate this thing.</span>")
		return

	to_chat(M, "<span class='notice'>You start climbing into [src].</span>")

	switch(slot)
		if("Driver")

			if(driver != null)
				to_chat(M, "<span class='notice'>That seat is already taken.</span>")
				return

			if(!do_after(M, 100, needhand = FALSE, show_busy_icon = TRUE))
				to_chat(M, "<span class='notice'>Something interrupted you while getting in.</span>")
				return

			if(M.loc != loc_check)
				to_chat(M, "<span class='notice'>You stop getting in.</span>")
				return

			if(driver != null)
				to_chat(M, "<span class='notice'>Someone got into that seat before you could.</span>")
				return
			driver = M
			M.Move(src)
			if(loc_check == entrance.loc)
				to_chat(M, "<span class='notice'>You enter the driver's seat.</span>")
			else
				to_chat(M, "<span class='notice'>You climb onto the apc and enter the driver's seat through an auxiliary top hatchet.</span>")

			M.set_interaction(src)
			return

		if("Gunner")

			if(gunner != null)
				to_chat(M, "<span class='notice'>That seat is already taken.</span>")
				return

			if(!do_after(M, 100, needhand = FALSE, show_busy_icon = TRUE))
				to_chat(M, "<span class='notice'>Something interrupted you while getting in.</span>")
				return

			if(M.loc != loc_check)
				to_chat(M, "<span class='notice'>You stop getting in.</span>")
				return

			if(gunner != null)
				to_chat(M, "<span class='notice'>Someone got into that seat before you could.</span>")
				return

			if(!M.client) return //Disconnected while getting in
			gunner = M
			//M.loc = src
			M.Move(src)
			deactivate_binos(gunner)
			if(loc_check == entrance.loc)
				to_chat(M, "<span class='notice'>You enter the driver's seat.</span>")
			else
				to_chat(M, "<span class='notice'>You climb onto the apc and enter the driver's seat through an auxiliary top hatchet.</span>")
			M.set_interaction(src)
			if(M.client)
				M.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")


			return

//Deposits you onto the exit marker
//TODO: Sometimes when the entrance marker is on the wall or somewhere you can't move to, it still deposits you there
//Fix that bug at somepoint ^^
/obj/vehicle/multitile/root/cm_transport/apc/handle_player_exit(var/mob/M)

	if(M != gunner && M != driver) return

	if(occupant_exiting)
		to_chat(M, "<span class='notice'>Someone is already getting out of the vehicle.</span>")
		return

	to_chat(M, "<span class='notice'>You start climbing out of [src].</span>")

	occupant_exiting = 1
	sleep(50)
	occupant_exiting = 0

	if(tile_blocked_check(entrance.loc))
		to_chat(M, "<span class='notice'>Something is blocking you from exiting.</span>")
		return
	else
		if(M == gunner)
			deactivate_all_hardpoints()
			if(M.client)
				M.client.mouse_pointer_icon = initial(M.client.mouse_pointer_icon)
			M.Move(entrance.loc)

			gunner = null
		else
			if(M == driver)
				M.Move(entrance.loc)
				driver = null
		M.unset_interaction()
		to_chat(M, "<span class='notice'>You climb out of [src].</span>")

//No one but the driver can drive
/obj/vehicle/multitile/root/cm_transport/apc/relaymove(var/mob/user, var/direction)
	if(user != driver) return

	. = ..(user, direction)

	if(next_sound_play < world.time)
		playsound(src, 'sound/ambience/tank_driving.ogg', vol = 20, sound_range = 30)
		next_sound_play = world.time + 21

//No one but the driver can turn
/obj/vehicle/multitile/root/cm_transport/apc/try_rotate(var/deg, var/mob/user, var/force = 0)

	if(user != driver) return

	. = ..(deg, user, force)


/obj/vehicle/multitile/hitbox/cm_transport/apc/Bump(var/atom/A)
	. = ..()
	if(isliving(A))
		var/mob/living/M = A
		var/obj/vehicle/multitile/root/cm_transport/apc/T
		log_attack("[T ? T.driver : "Someone"] drove over [M] with [root]")