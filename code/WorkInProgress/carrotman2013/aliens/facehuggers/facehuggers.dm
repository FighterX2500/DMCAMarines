/mob/living/carbon/Xenomorph/facehugger
	name = "alien"
	caste = "Facehugger"
	desc = "It has some sort of a tube at the end of its tail."
	real_name = "alien"

	icon = 'icons/Xeno/Effects.dmi'
	icon_state = "facehugger"

	flags_pass = PASSTABLE | PASSMOB

	maxHealth = 25
	melee_damage_lower = 0
	melee_damage_upper = 0
	health = 25
	plasma_stored = 20
	plasma_max = 20
	tier = 0
	see_in_dark = 8
	speed = -1.4
	crit_health = -15
	gib_chance = 50
	upgrade = -1

	innate_healing = TRUE
	density = FALSE

	var/attached = FALSE
	var/leaping = FALSE
	var/usedLeap = 0

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/xenohide,
		/datum/action/xeno_action/activable/leap,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl
		)


/////////////////////////////////////////////
//Ghost possession (original by polion1232)//
/////////////////////////////////////////////

/obj/item/clothing/mask/facehugger/verb/Enter_facehugger()
	set category = "Ghost"
	set name = "Possess Facehugger"
	set src in oview(usr.client)

	if(!usr)
		return
	if(!isobserver(usr))
		return
	if(src.stat == CONSCIOUS)
		enter_facehugger(usr)


/obj/item/clothing/mask/facehugger/proc/enter_facehugger(mob/oldmob)
	if(disposed)
		return
	if(!isobserver(oldmob))
		return

	var/mob/ghostmob = usr.client.mob
	if(world.time < ghostmob.timeofdeath + 600 SECONDS)
		to_chat(ghostmob, "<span class='warning'>You should wait another [round((ghostmob.timeofdeath + 600 SECONDS - world.time)/10)] seconds!</span>")
		return

	message_admins("[key_name(oldmob)] entering [src]...")

	var/mob/living/carbon/Xenomorph/facehugger/F = new(loc)
	F.ckey = usr.ckey
	cdel(src)
	cdel(ghostmob)
	F.client.change_view(world.view)

	visible_message("<span class='xenonotice'>A facehugger suddenly becomes more active.</span>", "<span class='xenonotice'>You are a facehugger!</span>")

/////////////////////
//Action for a jump//
/////////////////////

/datum/action/xeno_action/activable/leap
	name = "Leap"
	action_icon_state = "fhleap"
	plasma_cost = 5

/datum/action/xeno_action/activable/leap/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/facehugger/X = owner
	X.Leap(A)

/datum/action/xeno_action/activable/leap/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/facehugger/X = owner
	return !X.usedLeap


///////////////
////Procs//////
///////////////

//Leaping. Copypast from original facehuggers.
/mob/living/carbon/Xenomorph/facehugger/proc/leap_at_face(mob/living/carbon/human/C)
	if(!istype(C) || isXeno(C) || isSynth(C) || iszombie(C) || isHellhound(C) || C.stat == DEAD || C.status_flags & XENO_HOST)
		to_chat(src, "<span class='notice'>This creature is incompatible.</span>")
		return


	if(isYautja(C))
		var/catch_chance = 50
		if(C.dir == reverse_dir[dir]) catch_chance += 20
		if(C.lying) catch_chance -= 50
		catch_chance -= ((C.maxHealth - C.health) / 3)
		if(C.get_active_hand()) catch_chance  -= 25
		if(C.get_inactive_hand()) catch_chance  -= 25

		if(!C.stat && C.dir != dir && prob(catch_chance)) //Not facing away
			C.visible_message("<span class='notice'>[C] snatches [src] out of the air and squashes it!")
			src.gib()
			return


	if(C.head && !(C.head.flags_item & NODROP))
		var/obj/item/clothing/head/D = C.head
		if(istype(D))
			if(D.anti_hug > 1)
				C.visible_message("<span class='danger'>[src] smashes against [C]'s [D.name]!")
				return
			else
				C.visible_message("<span class='danger'>[src] smashes against [C]'s [D.name] and rips it off!")
				C.drop_inv_item_on_ground(D)
				if(istype(D, /obj/item/clothing/head/helmet/marine)) //Marine helmets now get a fancy overlay.
					var/obj/item/clothing/head/helmet/marine/m_helmet = D
					m_helmet.add_hugger_damage()
				C.update_inv_head()
				return


	if(C.wear_mask)
		var/obj/item/clothing/mask/W = C.wear_mask
		if(istype(W))
			if(W.flags_item & NODROP)
				return

			if(istype(W, /obj/item/clothing/mask/facehugger))
				var/obj/item/clothing/mask/facehugger/hugger = W
				if(hugger.stat != DEAD)
					return

			if(W.anti_hug > 1)
				C.visible_message("<span class='danger'>[src] smashes against [C]'s [W.name]!</span>")
				return
			else
				C.visible_message("<span class='danger'>[src] smashes against [C]'s [W.name] and rips it off!</span>")
				C.drop_inv_item_on_ground(W)
				return

	var/obj/item/clothing/mask/facehugger/FH = new(loc)
	src.loc = FH
	FH.Attach(C)
	cdel(src)



/mob/living/carbon/Xenomorph/facehugger/proc/Leap(atom/T)

	if(!T) return

	if(T.layer >= FLY_LAYER)//anything above that shouldn't be pounceable (hud stuff)
		return

	if(!isturf(loc))
		to_chat(src, "<span class='xenowarning'>You can't leap from here!</span>")
		return

	if(!check_state())
		return

	if(usedLeap)
		to_chat(src, "<span class='xenowarning'>You must wait before a jump.</span>")
		return

	if(!check_plasma(10))
		return

	visible_message("<span class='xenowarning'>\The [src] leaps at [T]!</span>", \
	"<span class='xenowarning'>You leap at [T]!</span>")
	usedLeap = 1
	src.icon_state = "facehugger_thrown"
	flags_pass = PASSTABLE | PASSMOB
	use_plasma(10)
	throw_at(T, 4, 2, src) //Victim, distance, speed
	spawn(2)
		src.icon_state = "facehugger"
		if(T.loc == src.loc)
			leap_at_face(T)

	spawn(20)
		usedLeap = 0
		to_chat(src, "<span class='notice'>You get ready to leap again.</span>")
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()

	return 1

/////////////
//Mob stuff//
/////////////

/mob/living/carbon/Xenomorph/facehugger/UnarmedAttack(atom/A)
	a_intent = "help" //Forces help intent for all interactions.
	. = ..()

/mob/living/carbon/Xenomorph/facehugger/update_icons()
	var/name_prefix = ""

	var/datum/hive_status/hive
	if(hivenumber && hivenumber <= hive_datum.len)
		hive = hive_datum[hivenumber]
	else
		hivenumber = XENO_HIVE_NORMAL
		hive = hive_datum[hivenumber]

	color = hive.color
	if(name_prefix == "Corrupted ")
		add_language("English")
	else
		remove_language("English") // its hacky doing it here sort of

	real_name = name
	if(mind)
		mind.name = name //This gives them the proper name in deadchat if they explode on death. It's always the small things

	if(stat == DEAD)
		icon_state = "facehugger_dead"
	else if(lying || resting)
		icon_state = "facehugger_inactive"
	else
		icon_state = "facehugger"

	name = "alien ([nicknumber])"

/mob/living/carbon/Xenomorph/facehugger/start_pulling(atom/movable/AM)
	to_chat(src, "<span class='warning'>You are too small to pull anything.</span>")
	return

/mob/living/carbon/Xenomorph/facehugger/pull_response(mob/puller)
	return TRUE

/atom/proc/attack_facehugger(mob/user)
	return

/obj/machinery/door/airlock/attack_facehugger(mob/living/carbon/Xenomorph/facehugger/M)
	for(var/atom/movable/AM in get_turf(src))
		if(AM != src && AM.density && !AM.CanPass(M, M.loc))
			to_chat(M, "<span class='warning'>\The [AM] prevents you from squeezing under \the [src]!</span>")
			return
	if(locked || welded) //Can't pass through airlocks that have been bolted down or welded
		to_chat(M, "<span class='warning'>\The [src] is locked down tight. You can't squeeze underneath!</span>")
		return
	M.visible_message("<span class='warning'>\The [M] scuttles underneath \the [src]!</span>", \
	"<span class='warning'>You squeeze and scuttle underneath \the [src].</span>", null, 5)
	M.forceMove(loc)

////////////////
///No Talking///
////////////////

/mob/living/carbon/Xenomorph/facehugger/say(var/message)
	return

/mob/living/carbon/Xenomorph/facehugger/whisper()
	return

/mob/living/carbon/Xenomorph/facehugger/emote()
	return
