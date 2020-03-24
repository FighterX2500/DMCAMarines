//////////////////////////////////////////////////////////////
//Mounted TOW launcher

// First thing we need is the ammo. Rockets in our case.
/obj/item/ammo_magazine/rocket/m8_1_tow
	name = "84mm anti-armor TOW rocket"
	desc = "A rocket tube for an M7 TOW Launcher emplacement."
	caliber = "rocket"
	icon_state = "tow_mount_rocket"
	w_class = 3.0
	max_rounds = 1
	default_ammo = /datum/ammo/rocket/tow/m8_1_tow
	gun_type = null
	flags_magazine = NOFLAGS

// The actual gun itself.
/obj/item/device/m8_1_tow_gun
	name = "\improper M8-1 Mounted TOW Launcher"
	desc = "The top half of a M8-1 TOW launcher post. However it ain't much use without the tripod."
	unacidable = TRUE
	w_class = 5
	icon = 'icons/Marine/tow_mount.dmi'
	icon_state = "tow_gun"

/obj/item/device/m8_1_tow_post //Adding this because I was fucken stupid and put a obj/machinery in a box. Realized I couldn't take it out
	name = "\improper M8-1 TOW Launcher folded mount"
	desc = "The folded, foldable tripod mount for the M8-1.\n<span class='notice'>(Place on ground and drag to you to unfold)</span>"
	unacidable = TRUE
	w_class = 5
	icon = 'icons/Marine/tow_mount.dmi'
	icon_state = "folded_mount"

/obj/item/device/m8_1_tow_post/attack_self(mob/user) //click the tripod to unfold it.
	if(!ishuman(usr)) return
	to_chat(user, "<span class='notice'>You deploy [src].</span>")
	var/obj/machinery/m8_1_tow_post/P = new(user.loc)
	P.dir = user.dir
	P.update_icon()
	cdel(src)

//The mount for the weapon.
/obj/machinery/m8_1_tow_post
	name = "\improper M8-1 TOW launcher mount"
	desc = "A foldable tripod mount for the M8-1."
	icon = 'icons/Marine/tow_mount.dmi'
	icon_state = "tow_mount"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_MOB_LAYER
	var/gun_mounted = FALSE //Has the gun been mounted?
	var/health = 100

/obj/machinery/m8_1_tow_post/proc/update_health(damage)
	health -= damage
	if(health <= 0)
		if(prob(30))
			new /obj/item/device/m8_1_tow_post (src)
		cdel(src)

/obj/machinery/m8_1_tow_post/examine(mob/user)
	..()
	if(!gun_mounted)
		to_chat(user, "The <b>M8-1 Mounted TOW launcher</b> is not yet mounted.")

/obj/machinery/m8_1_tow_post/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M))
		return //Larvae can't do shit
	M.visible_message("<span class='danger'>[M] has slashed [src]!</span>",
	"<span class='danger'>You slash [src]!</span>")
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	update_health(rand(M.melee_damage_lower,M.melee_damage_upper))


/obj/machinery/m8_1_tow_post/MouseDrop(over_object, src_location, over_location) //Drag the tripod onto you to fold it.
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr //this is us
	if(over_object == user && in_range(src, user))
		to_chat(user, "<span class='notice'>You fold [src].</span>")
		var/obj/item/device/m8_1_tow_post/P = new(loc)
		if(gun_mounted)
			new /obj/item/device/m8_1_tow_gun(src.loc)
		user.put_in_hands(P)
		cdel(src)

/obj/machinery/m8_1_tow_post/attackby(obj/item/O, mob/user)
	if(!ishuman(user)) //first make sure theres no funkiness
		return

	if(istype(O,/obj/item/tool/wrench)) //rotate the mount
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		user.visible_message("<span class='notice'>[user] rotates [src].</span>","<span class='notice'>You rotate [src].</span>")
		dir = turn(dir, -90)
		return

	if(istype(O,/obj/item/device/m8_1_tow_gun)) //lets mount the MG onto the mount.
		var/obj/item/device/m8_1_tow_gun/TOW = O
		to_chat(user, "You begin mounting [TOW]..")
		if(do_after(user,30, TRUE, 5, BUSY_ICON_BUILD) && !gun_mounted && anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message("\blue [user] installs [TOW] into place.","\blue You install [TOW] into place.")
			gun_mounted = TRUE
			user.temp_drop_inv_item(TOW)
			icon_state = "tow_e"
			cdel(TOW)
		return

	if(istype(O,/obj/item/tool/crowbar))
		if(!gun_mounted)
			to_chat(user, "<span class='warning'>There is no gun mounted.</span>")
			return
		to_chat(user, "You begin dismounting [src]'s gun..")
		if(do_after(user,30, TRUE, 5, BUSY_ICON_BUILD) && gun_mounted)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message("\blue [user] removes [src]'s gun.","\blue You remove [src]'s gun.")
			new /obj/item/device/m8_1_tow_gun(loc)
			gun_mounted = FALSE
			icon_state = "tow_mount"
		return

	if(istype(O,/obj/item/tool/screwdriver))
		if(gun_mounted)
			to_chat(user, "You're securing the M8-1 into place")
			if(do_after(user,30, TRUE, 5, BUSY_ICON_BUILD))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message("\blue [user] screws the M8-1 into the mount.","\blue You finalize the M8-1 mounted TOW launcher.")
				var/obj/machinery/m8_1_tow/T = new(src.loc) //Here comes our new turret.
				T.visible_message("\icon[T] <B>[T] is now complete!</B>") //finished it for everyone to
				T.dir = src.dir //make sure we face the right direction
				T.update_icon()
				cdel(src)

	return ..()

// The actual TOW itself, going to borrow some stuff from current sentry code to make sure it functions. Also because they're similiar.
/obj/machinery/m8_1_tow
	name = "\improper M8-1 Mounted TOW Launcher"
	desc = "A deployable, mounted TOW launcher. Shoots 84mm anti-armor TOW rockets. Is manufactured to be deployed in forward bases to obtain superiority against heavy support vehicles and tanks. Undergoing field testes in the hands of USCM.\n<span class='notice'>!!Has safety enabled by default.</span>\n<span class='danger'>!!Clear backblast area!</span>"
	icon = 'icons/Marine/tow_mount.dmi'
	icon_state = "tow"
	anchored = TRUE
	unacidable = TRUE //stop the xeno me(l)ta.
	density = TRUE
	layer = ABOVE_MOB_LAYER //no hiding the hmg beind corpse
	use_power = 0
	var/locked = FALSE
	var/rocket = FALSE //Have it be empty upon spawn.
	var/next_shot = 0
	var/fire_delay = 150
	var/safety = TRUE //Weapon safety, 0 is weapons hot, 1 is safe.
	var/health = 200
	var/health_max = 200 //Why not just give it sentry-tier health for now.
	var/atom/target = null // required for shooting at things.
	var/icon_full = "tow" // Put this system in for other MGs or just other mounted weapons in general, future proofing.
	var/icon_empty = "tow_e" //Empty
	var/view_tile_offset = 0	//this is amount of tiles we shift our vision towards MG direction
	var/view_tiles = 12		//this is amount of tiles we want person to see in each direction (7 by default)

	New()
		update_icon()

	Dispose() //Make sure we pick up our trash.
		if(operator)
			operator.unset_interaction()
		SetLuminosity(0)
		processing_objects.Remove(src)
		. = ..()

/obj/machinery/m8_1_tow/examine(mob/user) //Let us see how much ammo we got in this thing.
	..()
	if(!ishuman(user))
		return
	if(rocket)
		to_chat(usr, "It has a rocket loaded.")
	else
		to_chat(usr, "It seems to be empty.")
	if(safety)
		to_chat(usr, "Safety is on. (Toggle it in Weapons tab).")
	else
		to_chat(usr, "Safety is off.")

/obj/machinery/m8_1_tow/update_icon() //Lets generate the icon based on how much ammo it has.
	if(!rocket)
		icon_state = "[icon_empty]"
	else
		icon_state = "[icon_full]"
	return

/obj/machinery/m8_1_tow/attackby(var/obj/item/O as obj, mob/user as mob) //This will be how we take it apart.
	if(!ishuman(user))
		return ..()

	if(isnull(O))
		return

	if(istype(O,/obj/item/tool/wrench)) // Let us rotate this stuff.
		if(locked)
			to_chat(user, "This one is anchored in place and cannot be rotated.")
			return
		else
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message("[user] rotates the [src].","You rotate the [src].")
			dir = turn(dir, -90)
		return

	if(istype(O, /obj/item/tool/screwdriver)) // Lets take it apart.
		if(locked)
			to_chat(user, "This one cannot be disassembled.")
		else
			to_chat(user, "You begin disassembling the M8-1 mounted TOW launcher")
			if(do_after(user,15, TRUE, 5, BUSY_ICON_BUILD))
				user.visible_message("<span class='notice'> [user] disassembles [src]! </span>","<span class='notice'> You disassemble [src]!</span>")
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				new /obj/item/device/m8_1_tow_gun(src.loc) //Here we generate our disassembled mg.
				new /obj/item/device/m8_1_tow_post(src.loc)
				if(rocket)
					new /obj/item/ammo_magazine/rocket/m8_1_tow(src.loc)
				cdel(src) //Now we clean up the constructed gun.
				return

	if(istype(O, /obj/item/ammo_magazine/rocket/m8_1_tow)) // RELOADING DOCTOR FREEMAN.
		if(!user.mind || !user.mind.cm_skills)
			to_chat(user, "<span class='warning'>You have no idea how to reload [src].</span>")
			return
		if(rocket)
			to_chat(user, "<span class='warning'>There is already a rocket loaded.</span>")
			return
		if(user.action_busy)
			return
		if(!do_after(user, 30, TRUE, 5, BUSY_ICON_FRIENDLY))
			return
		user.visible_message("<span class='notice'> [user] loads [src]! </span>","<span class='notice'> You load [src]!</span>")
		playsound(loc, 'sound/weapons/gun_mortar_reload.ogg', 25, 1) //!!replace this sound!!
		rocket = TRUE
		update_icon()
		user.temp_drop_inv_item(O)
		cdel(O)
		return
	return ..()

/obj/machinery/m8_1_tow/proc/update_health(damage) //Negative damage restores health.
	health -= damage
	if(health <= 0)
		var/destroyed = rand(0,1) //Ammo cooks off or something. Who knows.
		playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		if(!destroyed) new /obj/machinery/m8_1_tow_post(loc)
		else
			new /obj/item/device/m8_1_tow_gun(loc)
			if(rocket)
				new /obj/item/ammo_magazine/rocket/m8_1_tow(loc)
		cdel(src)
		return

	if(health > health_max)
		health = health_max
	update_icon()

/obj/machinery/m8_1_tow/bullet_act(var/obj/item/projectile/Proj) //Nope.
	if(prob(30)) // What the fuck is this from sentry gun code. Sorta keeping it because it does make sense that this is just a gun, unlike the sentry.
		return 0

	visible_message("\The [src] is hit by the [Proj.name]!")
	update_health(round(Proj.damage / 10)) //Universal low damage to what amounts to a post with a gun.
	return 1

/obj/machinery/m8_1_tow/attack_alien(mob/living/carbon/Xenomorph/M) // Those Ayy lmaos.
	if(isXenoLarva(M))
		return //Larvae can't do shit
	M.visible_message("<span class='danger'>[M] has slashed [src]!</span>",
	"<span class='danger'>You slash [src]!</span>")
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	update_health(rand(M.melee_damage_lower,M.melee_damage_upper))

/obj/machinery/m8_1_tow/proc/process_shot()
	set waitfor = 0

	if(isnull(target))
		return //Acqure our victim.

	if(!rocket)
		update_icon() //safeguard.
		return

	if(target)
		fire_shot()

	target = null

/obj/machinery/m8_1_tow/proc/fire_shot() //Bang Bang
	if(!rocket)
		return //No ammo.
	if(next_shot > world.time)
		to_chat(usr, "<span class='warning'>Weapon is still cooling down from previous shot!</span>")
		return

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)

	if (!istype(T) || !istype(U))
		return

	var/obj/item/ammo_magazine/rocket/m8_1_tow/ammo = new
	var/obj/item/projectile/P = new
	P.generate_bullet(new ammo.default_ammo)
	P.fire_at(U, src, null, P.ammo.max_range, P.ammo.shell_speed)
	//playsound(src.loc, 'sound/weapons/gun_rifle.ogg', 75, 1)		REPLACE SOUND
	if(target)
		var/angle = round(Get_Angle(src,target))
		muzzle_flash(angle)
	rocket = FALSE
	visible_message("<span class='notice'> \icon[src] \The M8-1 beeps steadily and its ammo light blinks red.</span>")
	playsound(src.loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)
	update_icon() //final safeguard.
	next_shot = world.time + fire_delay

	var/datum/effect_system/smoke_spread/smoke = new
	var/backblast_loc = get_turf(get_step(src, turn(src.dir, 180)))
	smoke.set_up(1, 0, backblast_loc, turn(src.dir, 180))
	smoke.start()
	for(var/mob/living/carbon/C in backblast_loc)
		if(!C.lying) //Have to be standing up to get the fun stuff
			step_away(C, src, 0)
			C.adjustBruteLoss(30) //The shockwave hurts, quite a bit. It can knock unarmored targets unconscious in real life
			C.adjustFireLoss(15)
			C.KnockDown(2) //For good measure
			C.emote("pain")
	return

// New proc for MGs and stuff replaced handle_manual_fire(). Same arguements though, so alls good.
/obj/machinery/m8_1_tow/handle_click(mob/living/carbon/human/user, atom/A, var/list/mods)
	if(!operator)
		return FALSE
	if(operator != user)
		return FALSE
	if(istype(A,/obj/screen))
		return FALSE
	if(user.lying || !Adjacent(user) || user.is_mob_incapacitated())
		user.unset_interaction()
		return FALSE
	if(user.get_active_hand())
		to_chat(usr, "<span class='warning'>You need a free hand to shoot the [src].</span>")
		return FALSE
	if(safety)
		to_chat(usr, "<span class='danger'>Switch safety off! (Weapons tab).</span>")
		return FALSE
	target = A
	if(!istype(target))
		return FALSE

	if(target.z != src.z || target.z == 0 || src.z == 0 || isnull(operator.loc) || isnull(src.loc))
		return FALSE

	if(get_dist(target,src.loc) > 15)
		return FALSE

	if(get_dist(target,src.loc) < 3)
		to_chat(usr, "<span class='danger'>You aim too close!</span>")
		return FALSE

	if(mods["middle"] || mods["shift"] || mods["alt"] || mods["ctrl"])
		return FALSE

	var/angle = get_dir(src,target)
	//we can only fire in a 90 degree cone
	if((dir & angle) && target.loc != src.loc && target.loc != operator.loc)

		if(!rocket)
			to_chat(user, "<span class='warning'><b>*click*</b></span>")
			playsound(src, 'sound/weapons/gun_empty.ogg', 25, 1, 5)
		else
			process_shot()
		return 1

	return 0

/obj/machinery/m8_1_tow/proc/muzzle_flash(var/angle) // Might as well keep this too.
	if(isnull(angle)) return

	if(prob(65))
		var/img_layer = layer + 0.1

		var/image/reusable/I = rnew(/image/reusable, list('icons/obj/items/projectiles.dmi', src, "muzzle_flash",img_layer))
		var/matrix/rotate = matrix() //Change the flash angle.
		rotate.Translate(0,5)
		angle = turn(angle, 180)
		rotate.Turn(angle)
		I.transform = rotate

		I.flick_overlay(src, 3)

/obj/machinery/m8_1_tow/MouseDrop(over_object, src_location, over_location) //Drag the TOW to us to man it.
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr //this is us
	src.add_fingerprint(usr)
	if((over_object == user && (in_range(src, user) || locate(src) in user))) //Make sure its on ourselves
		if(user.interactee == src)
			user.unset_interaction()
			visible_message("\icon[src] <span class='notice'>[user] decided to let someone else have a go </span>")
			to_chat(usr, "<span class='notice'>You decided to let someone else have a go on the MG </span>")
			return
		if(!Adjacent(user))
			to_chat(usr, "<span class='warning'>Something is between you and [src].</span>")
			return
		if(get_step(src,turn(dir, 90)) != user.loc)
			to_chat(user, "<span class='warning'>You should be on the left side of [src] to man it!</span>")
			return
		if(operator) //If there is already a operator then they're manning it.
			if(operator.interactee == null)
				operator = null //this shouldn't happen, but just in case
			else
				to_chat(user, "Someone's already controlling it.")
				return
		else
			if(user.interactee) //Make sure we're not manning two guns at once, tentacle arms.
				to_chat(user, "You're already manning something!")
				return
			if(isSynth(user) && !config.allow_synthetic_gun_use)
				to_chat(user, "<span class='warning'>Your programming restricts operating heavy weaponry.</span>")
				return
			if(user.get_active_hand() != null)
				to_chat(user, "<span class='warning'>You need a free hand to man the [src].</span>")
			else
				visible_message("\icon[src] <span class='notice'>[user] mans the M56D!</span>")
				to_chat(user, "<span class='notice'>You man the gun!</span>")
				user.set_interaction(src)


/obj/machinery/m8_1_tow/on_set_interaction(mob/user)
	flags_atom |= RELAY_CLICK
	user.client.change_view(view_tiles)
	switch(dir)
		if(NORTH)
			user.client.pixel_x = 0
			user.client.pixel_y = view_tile_offset * 32
		if(SOUTH)
			user.client.pixel_x = 0
			user.client.pixel_y = -1 * view_tile_offset * 32
		if(EAST)
			user.client.pixel_x = view_tile_offset * 32
			user.client.pixel_y = 0
		if(WEST)
			user.client.pixel_x = -1 * view_tile_offset * 32
			user.client.pixel_y = 0
	operator = user

/obj/machinery/m8_1_tow/on_unset_interaction(mob/user)
	flags_atom &= ~RELAY_CLICK
	if(user.client)
		user.client.change_view(world.view)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
	if(operator == user)
		operator = null

/obj/machinery/m8_1_tow/check_eye(mob/user)
	if(user.lying || !Adjacent(user) || user.is_mob_incapacitated() || !user.client)
		user.unset_interaction()

/obj/machinery/m8_1_tow/verb/toggle_tow_safety()
	set name = "Toggle TOW Safety"
	set category = "Weapons"
	set src in orange(1)

	if (operator != usr)
		return

	safety = !safety
	to_chat(usr, "<span class='notice'>You toggle the safety [safety ? "<b>on</b>" : "<b>off</b>"].</span>")
	playsound(usr, 'sound/machines/click.ogg', 15, 1)

	return ..()

/obj/machinery/m8_1_tow/tow_turret //mapbound version with zoom feature for WO
	name = "\improper M8-1 Mounted TOW Launcher Nest"
	desc = "A M8-1 TOW launcher mounted upon a small reinforced post with sandbags for all your defense purpose needs. Shoots 84mm anti-armor TOW rockets. Is manufactured to be deployed in forward bases to obtain superiority against heavy support vehicles and tanks. Undergoing field testes in the hands of USCM.\n<span class='notice'>!!Has safety enabled by default.</span>\n<span class='danger'>!!Clear backblast area!</span>"
	locked = TRUE
	icon = 'icons/Marine/tow_mount.dmi'
	icon_full = "tow_nest"
	icon_empty = "tow_nest_e"
	fire_delay = 50
	view_tile_offset = 8
	view_tiles = 12

/obj/structure/closet/crate/m8_1_tow_ammo

	name = "M8-1 TOW ammo crate"
	desc = "A crate containing rockets for M8-1 TOW emplacement. DO NOT DROP. KEEP AWAY FROM FIRE SOURCES."
	icon = 'icons/Marine/mortar.dmi'
	icon_state = "closed_mortar_crate"
	icon_opened = "open_mortar_crate"
	icon_closed = "closed_mortar_crate"

/obj/structure/closet/crate/m8_1_tow_ammo/full/New()
	..()
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)

/obj/structure/closet/crate/m8_1_tow_ammo/m8_1_tow_kit
	name = "M8-1 TOW kit"
	desc = "A crate containing a basic set of a M8-1 TOW launcher and some rockets, to get an engineer started."

/obj/structure/closet/crate/m8_1_tow_ammo/m8_1_tow_kit/New()
	..()
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/ammo_magazine/rocket/m8_1_tow(src)
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/device/m8_1_tow_gun(src)
	new /obj/item/device/m8_1_tow_post(src)