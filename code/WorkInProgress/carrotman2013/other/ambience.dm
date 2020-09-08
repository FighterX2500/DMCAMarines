//Almayer
/client/var/last_ambience = null

/area/almayer/medical
	ambiencecooldown = 190
	ambience = list('code/WorkInProgress/carrotman2013/a.isolationsounds/medbay.ogg')

/area/almayer/engineering
	ambiencecooldown = 100
	ambience = list('code/WorkInProgress/carrotman2013/a.isolationsounds/engineering.ogg')

/area/almayer/command
	ambiencecooldown = 140
	ambience = list('code/WorkInProgress/carrotman2013/a.isolationsounds/bridge.ogg')

/area/almayer/command/self_destruct
	..()
	ambiencecooldown = 140
	ambience = list('code/WorkInProgress/carrotman2013/a.isolationsounds/computer_core.ogg')

/area/almayer/hull
	ambiencecooldown = 635
	ambience = list('code/WorkInProgress/carrotman2013/a.isolationsounds/creaking_ambience.ogg')

//Planets

//Ice Colony
/area/ice_colony/exterior/surface
	..()
	ambience = list('code/WorkInProgress/carrotman2013/sounds/ambience/snow/inside/active_mid_all.ogg')

/area/ice_colony/exterior/surface/valley
	..()
	ambience = list('code/WorkInProgress/carrotman2013/sounds/ambience/snow/outside/active_mid_all.ogg')


//LV Jungle
/area/lv624/ground/caves
	..()
	ambience = list('code/WorkInProgress/carrotman2013/sounds/ambience/bigredcave.ogg')

/area/lv624/ground
	..()
	ambience = list('sound/ambience/jungle_amb1.ogg')



//Bigred

/area/bigredv2/outside
	..()
	ambience = list('code/WorkInProgress/carrotman2013/sounds/ambience/bigred.ogg')

/area/bigredv2/caves
	..()
	ambience = list('code/WorkInProgress/carrotman2013/sounds/ambience/bigredcave.ogg')




///////////////////////////////////////
//КАК РАБОТАЕТ ЭМБИЕНС ПРИ КАРРОТМАНЕ//
///////////////////////////////////////

/area/Entered(A,atom/OldLoc)
	var/sound

	if(istype(A, /obj/machinery))
		var/area/newarea = get_area(A)
		var/area/oldarea = get_area(OldLoc)
		oldarea.master.area_machines -= A
		newarea.master.area_machines += A
		return

	if(!istype(A,/mob/living))	return

	var/mob/living/L = A
	if(!L.ckey)	return

	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if((oldarea.has_gravity == 0) && (newarea.has_gravity == 1) && (L.m_intent == MOVE_INTENT_RUN)) // Being ready when you change areas gives you a chance to avoid falling all together.
		thunk(L)
		L.make_floating(0)

	L.lastarea = newarea

	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!(L && L.client && (L.client.prefs.toggles_sound & SOUND_AMBIENCE)))	return

/*
СТАРТ
*/

	if(!src.ambience.len)
		L << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		L.client.ambience_playing = 0
		L.client.last_ambience = null
		return
////////////
///Алмаер///
////////////
	if(istype(src, /area/almayer) && !EvacuationAuthority.dest_already_armed)//Чтоб не было какофонии при СД
		sound = pick(ambience)
		if(L.client?.last_ambience != sound)
			L.client.last_ambience = sound
			L << sound(sound, repeat = 1, wait = 0, volume = 20, channel = 1)
			L.client.ambience_playing = 1
		return

//Теперь планеты

////////////////
///Ice Colony///
////////////////

	if(istype(src, /area/ice_colony/exterior/surface))
		sound = pick(ambience)
		if(L.client?.last_ambience != sound)
			L.client.ambience_playing = 1
			L << sound(sound, repeat = 1, wait = 0, volume = 11, channel = 1)
			L.client.last_ambience = sound
		return

////////////////////
///LV-624 Jungle////
////////////////////

	if(istype(src, /area/lv624/ground))
		sound = pick(ambience)
		if(L.client?.last_ambience != sound)
			L.client.ambience_playing = 1
			L << sound(sound, repeat = 1, wait = 0, volume = 2, channel = 1)
			L.client.last_ambience = sound
		return

////////////////////
///BigRed Outside///
////////////////////

	if(istype(src, /area/bigredv2/outside))
		sound = pick(ambience)
		if(L.client?.last_ambience != sound)

			L.client.ambience_playing = 1
			L << sound(sound, repeat = 1, wait = 0, volume = 10, channel = 1)
			L.client.last_ambience = sound
		return

//////////////////
///BigRed Caves///
//////////////////

	if(istype(src, /area/bigredv2/caves))
		sound = pick(ambience)
		if(L.client?.last_ambience != sound)
			L.client.ambience_playing = 1
			L << sound(sound, repeat = 1, wait = 0, volume = 7, channel = 1)
			L.client.last_ambience = sound
		return

//Если эмбиент не вписан/чет идет не так - то вырубим все звуки и по-старому включится что-то рандомное

	else
		sound = pick(ambience)
		if(world.time > L.client.played + 900)
			L << sound(sound, repeat = 0, wait = 0, volume = 10, channel = 1)
			L.client.played = world.time
			L.client.last_ambience = sound
		else
			L.client.ambience_playing = 0
			L.client.last_ambience = null
			L << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)