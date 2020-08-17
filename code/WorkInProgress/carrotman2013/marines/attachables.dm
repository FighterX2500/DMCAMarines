//Attachable Laser Targeting System.


/obj/item/attachable/attached_gun/laser_targeting
	name = "laser targeting system"
	desc = "A small weapon-mounted laser targeting system. Recommended to use it with a scope."
	icon = 'code/WorkInProgress/carrotman2013/marines/icons/attachables.dmi'
	icon_state = "lastarg"
	attach_icon = "lastarg_a"
	slot = "under"
	flags_attach_features = ATTACH_REMOVABLE|ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON
	current_rounds = 1
	max_rounds = 1
	ammo = /obj/item/cell
	attachment_firing_delay = 0
	var/laser_cooldown = 0
	var/cooldown_duration = 3600 //Если КАС выстрелит - кулдаун 6 минут (у биноклей 8 секунд) - баланс от бога, дабы не спамили ксенов ударами.
	var/obj/effect/overlay/temp/laser_target/laser
	var/obj/effect/overlay/temp/laser_coordinate/coord
	var/target_acquisition_delay = 60 //6 секунд, вместо стандартных 3
	var/mode = 0 //Изначальный режим. 0 - КАС, 1 - Просто координаты
	var/changable = 0 //0 - можно переключаться между КАСом и координатами.



/obj/item/attachable/attached_gun/laser_targeting/examine(mob/user) // Заряжена ли батарейка - можно узнать через examine.
	..()
	if(world.time < laser_cooldown)
		to_chat(user, "It's battery is recharging.")
	else
		to_chat(user, "It's battery is fully charged.")



/obj/item/attachable/attached_gun/laser_targeting/activate_attachment(obj/item/weapon/gun/G, mob/living/user, turn_off)
	if(G.active_attachable == src)
		if(user)
			to_chat(user, "<span class='notice'>You disable the [src].</span>")
			playsound(user, 'sound/machines/click.ogg', 35)
		G.active_attachable = null
		if(laser)
			cdel(laser)
			laser = null
		if(coord)
			cdel(coord)
			coord = null
		icon_state = initial(icon_state)
	else if(!turn_off)
		if(user)
			to_chat(user, "<span class='notice'>You activate the [src].</span>")
			playsound(user, 'sound/machines/click.ogg', 35)
		G.active_attachable = src
		icon_state += "-on"

	for(var/X in G.actions)
		var/datum/action/A = X
		A.update_button_icon()
	return TRUE

/obj/item/attachable/attached_gun/laser_targeting/fire_attachment(atom/target, obj/item/weapon/gun/gun, mob/living/user)
	if(world.time < laser_cooldown)
		to_chat(user, "<span class='warning'>The battery is recharging!</span>")
		return
	else
		acquire_target(target, user)


//Так и не допер, как дать возможность переключать режимы прямо на оружии - поэтому сначала снимаем аттач, затем перенастраиваем.
/obj/item/attachable/attached_gun/laser_targeting/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Laser Mode"
	var/mob/living/user
	if(isliving(loc))
		user = loc
	else
		return

	if(!zoom)
		mode = !mode
		to_chat(user, "<span class='notice'>You recalibrate the [src]. Current mode is: [mode? "range finder" : "CAS marking" ].</span>")
		playsound(usr, 'sound/machines/beepalert.ogg', 20)



//"МАМ ТОЧКА ТОЧКА ТОЧКА МАМА ТОЧКА ТАМ ТОЧКА МАМ"
/obj/item/attachable/attached_gun/laser_targeting/proc/acquire_target(atom/A, mob/living/carbon/human/user)

	if(laser || coord)
		to_chat(user, "<span class='warning'>You're already targeting something.</span>")
		return

	if(world.time < laser_cooldown)
		to_chat(user, "<span class='warning'>[src]'s laser battery is recharging.</span>")
		return

	if(!user.mind)
		return

	var/acquisition_time = target_acquisition_delay
	if(user.mind.cm_skills.leadership)//Проскилованные-марины целятся быстрее.обычных.
		acquisition_time = 35 //3.5 секунды (на бинокле 1.5)

	var/datum/squad/S = user.assigned_squad

	var/laz_name = ""
	if(S) laz_name = S.name

	var/turf/TU = get_turf(A)
	var/area/targ_area = get_area(A)
	if(!istype(TU)) return
	var/is_outside = FALSE
	if(TU.z == 1)
		switch(targ_area.ceiling)
			if(CEILING_NONE)
				is_outside = TRUE
			if(CEILING_GLASS)
				is_outside = TRUE
	if(!is_outside & !mode) // For CAS laser
		to_chat(user, "<span class='warning'>INVALID TARGET: target must be visible from high altitude.</span>")
		return
	if(user.action_busy)
		return
	playsound(src, 'sound/effects/nightvision.ogg', 35)
	to_chat(user, "<span class='notice'>INITIATING LASER TARGETING. Stand still.</span>")
	if(!do_after(user, acquisition_time, TRUE, 5, BUSY_ICON_GENERIC) || world.time < laser_cooldown || laser)
		return
	if(mode)
		var/obj/effect/overlay/temp/laser_coordinate/LT = new (TU, laz_name)
		coord = LT
		to_chat(user, "<span class='notice'>SIMPLIFIED COORDINATES OF TARGET. LONGITUDE [coord.x]. LATITUDE [coord.y].</span>")
		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(coord)
			if(!do_after(user, 50, TRUE, 5, BUSY_ICON_GENERIC))
				if(coord)
					cdel(coord)
					coord = null
				break
	else
		to_chat(user, "<span class='notice'>TARGET ACQUIRED. LASER TARGETING IS ONLINE. DON'T MOVE.</span>")
		var/obj/effect/overlay/temp/laser_target/LT = new (TU, laz_name)
		laser = LT
		playsound(src, 'sound/effects/binoctarget.ogg', 35)
		while(laser)
			if(!do_after(user, 50, TRUE, 5, BUSY_ICON_GENERIC))
				if(laser)
					cdel(laser)
					laser = null
				break