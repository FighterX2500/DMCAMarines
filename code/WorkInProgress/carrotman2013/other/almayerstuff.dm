//////////////
////Alarms////
//////////////

//Red lights
/area/proc/emergency()
	if(name == "Space") //no fire alarms in space
		return
	if(!(flags_alarm_state & ALARM_WARNING_RED))
		flags_alarm_state |= ALARM_WARNING_RED
		master.flags_alarm_state |= ALARM_WARNING_RED	//used for firedoor checks
		updateicon()
		mouse_opacity = 0

/area/proc/resetemergency()
	if(flags_alarm_state & ALARM_WARNING_RED)
		flags_alarm_state &= ~ALARM_WARNING_RED
		master.flags_alarm_state &= ~ALARM_WARNING_RED	//used for firedoor checks
		mouse_opacity = 0
		updateicon()


////////////////////////////////////////
//////Emergencies through fire Alarms///
///////////////////////////////////////
/obj/machinery/firealarm
	var/emergon

/obj/machinery/firealarm/proc/startemergency()
	if (!( src.working ))
		return
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.emergency()
	emergon = 1
	update_icon()
	return

/obj/machinery/firealarm/proc/resetemergency()
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.resetemergency()
	emergon = 0
	update_icon()
	return


////////////////////////
//////SD effects////////
////////////////////////

/datum/authority/branch/evacuation
	var/list/pick_turfs = list()
	var/list/pick_pipe = list()


/datum/authority/branch/evacuation/proc/count_turfs()
	for(var/turf/open/floor/T in world)
		if(T.z == MAIN_SHIP_Z_LEVEL)
			pick_turfs += T

	for(var/obj/machinery/atmospherics/pipe/simple/S in machines)
		if(S.z == MAIN_SHIP_Z_LEVEL)
			pick_pipe += S

/datum/authority/branch/evacuation/proc/spawn_sd_effects()
	set background = 1

	var/effectstage1
	var/effectstage9

	spawn while(NUKE_EXPLOSION_ACTIVE)

		if(!dest_already_armed || world.time >= dest_start_time + 6000)
			for(var/obj/machinery/firealarm/FA in machines)
				if(FA.z == MAIN_SHIP_Z_LEVEL)
					FA.resetemergency()
			break

		if(!effectstage1 && world.time <= dest_start_time + 2400) //1 //Спаун тревоги
			for(var/obj/machinery/firealarm/FA in machines)
				if(FA.z == MAIN_SHIP_Z_LEVEL)
					FA.startemergency()
			for(var/mob/living/L in mob_list)
				if(L.z == MAIN_SHIP_Z_LEVEL)
					L << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
			effectstage1 = 1
			count_turfs()


		if(world.time >= dest_start_time + 2400) //2  //Всякие глюки и сбои со звуком
			pick(pick_pipe).burst()

		if(world.time >= dest_start_time + 3000) //3  //Тряска камеры и дымка
			var/datum/effect_system/smoke_spread/bad/S = new /datum/effect_system/smoke_spread/bad()
			S.set_up(4, 0, pick(pick_turfs), null, 400)
			S.start()
			S.set_up(4, 0, pick(pick_turfs), null, 400)
			S.start()


		if(world.time >= dest_start_time + 3300) //4  //первый взрыв
			for(var/mob/living/carbon/M in mob_list)
				shake_camera(M, 25, 1)
			explosion(pick(pick_turfs), 0, 1, 3, 0)


		if(world.time >= dest_start_time + 3500) //5  //тряска сильнее и взрывы c более сильной
			for(var/mob/living/carbon/M in mob_list)
				if(prob(10))
					M.KnockDown(3)
					to_chat(M, "\red The floor jolts under your feet!")
			if(prob(20))
				explosion(pick(pick_turfs), 1, 5, 4, 0)


		if(world.time >= dest_start_time + 3600) //6  //взрыв каждые 10-15 секунд
			if(prob(30))
				explosion(pick(pick_turfs), 1, 4, 5, 0)
			sleep(20)
			if(prob(70))
				explosion(pick(pick_turfs), 1, 3, 4, 0)


		if(world.time >= dest_start_time + 4200) //7  //жесткий взрыв, 5-10 секунд
			for(var/mob/living/carbon/M in mob_list)
				shake_camera(M, 100, 2)
				if(prob(30))
					M.KnockDown(3)
					to_chat(M, "\red The floor jolts under your feet!")
			explosion(pick(pick_turfs), 1, 4, 5, 1)


		if(world.time >= dest_start_time + 4800) //8  //дым почти везде, мало что видно
			var/datum/effect_system/smoke_spread/bad/S = new /datum/effect_system/smoke_spread/bad()
			S.set_up(8, 0, pick(pick_turfs), null, 400)
			S.start()


		if(!effectstage9 && world.time >= dest_start_time + 5300) //9  //пара очень жестких взрывов
			explosion(pick(pick_turfs), 6, 6, 6, 2)
			sleep(30)
			explosion(pick(pick_turfs), 6, 6, 6, 2)
			effectstage9 = 1


		if(world.time >= dest_start_time + 5400) //10  //все в дыму
			var/datum/effect_system/smoke_spread/bad/S = new /datum/effect_system/smoke_spread/bad()
			S.set_up(15, 0, pick(pick_turfs), null, 400)
			S.start()

		sleep(60)