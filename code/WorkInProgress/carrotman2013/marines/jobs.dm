/*
1) DJ profession
1.2) DJ radio/intercom
1.3) Music station

2) Cook profession
*/

////////////////////////
/////DJ and his stuff///
////////////////////////
/datum/job/civilian/DJ
	title = "Disc Jokey"
	comm_title = "DJ"
	paygrade = "C"
	flag = ROLE_MARINE_DJ
	department_flag = ROLEGROUP_MARINE_SQUAD_MARINES
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting commander"
	selection_color = "#4A68E6"
	access = list(ACCESS_IFF_MARINE)
	minimal_access = list(ACCESS_IFF_MARINE)
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	skills_type = /datum/skills/civilian

	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/marine,
				WEAR_BODY = /obj/item/clothing/under/suit_jacket/really_black,
				WEAR_FEET = /obj/item/clothing/shoes/black,
				WEAR_EYES = /obj/item/clothing/glasses/sunglasses,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
				WEAR_R_STORE = /obj/item/storage/wallet/random,
				WEAR_L_STORE = /obj/item/device/radio/DJ,
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You are a civilian, working as a DJ for USCM Radio Service.
You are tasked with such things as motivating, entertaining the marines during the spec-ops. A special radio channel and office at almayer have been designated to you for these purposes.
Your role involves a lot of roleplaying, and though your supervisor is the military chain of command - you are still just a civillian with no extraordinary skills."}

////////////////////
///DJ radio stuff///
////////////////////
/obj/item/device/radio/intercom/DJ
	name = "DJ-Station intercom"
	desc = "Talk through this. To speak directly into an intercom next to you, use :i."
	icon_state = "intercom"
	frequency = DJ_FREQ

/obj/item/device/radio/DJ
	name = "DJ-Station radio"
	frequency = DJ_FREQ

//////////////////////
/////Music Station////
//////////////////////

/obj/machinery/musicstation
	name = "Music Station"
	icon = 'code/WorkInProgress/carrotman2013/icons/radiostation.dmi'
	icon_state = "tapedeck"
	desc = "A music station which allows you to transmit music from it."
	density = 1
	anchored = 1.0
	use_power = 1
	var/obj/item/device/cassette/casseta = null
	var/playing = 0

	var/msg


/obj/machinery/musicstation/Topic(href, href_list)
	if(href_list["globalmusicstop"])
		var/client/C = usr.client
		C << sound(null, repeat = 1, wait = 0, volume = 0, channel = 800)

/obj/machinery/musicstation/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/device/cassette))
		if(casseta)
			to_chat(user, "<span class='warning'>There is already cassette inside.</span>")
			return
		if(user.drop_inv_item_to_loc(I, src))
			casseta = I
			visible_message("<span class='notice'>[user] insert cassette into [src].</span>")
			playsound(get_turf(src), 'code/WorkInProgress/carrotman2013/sounds/music/bominside.ogg', 15, 1)
			return
	..()


/obj/machinery/musicstation/MouseDrop(obj/over_object)
	if(ishuman(usr))
		if(over_object == usr && Adjacent(usr)) // this must come before the screen objects only block
			eject()



/obj/machinery/musicstation/proc/eject()
	if(usr.is_mob_incapacitated())
		return
	if(!casseta)
		to_chat(usr, "<span class='warning'>There is no cassette inside.</span>")
		return

	if(playing)
		StopPlaying()
	visible_message("<span class='notice'>[usr] ejects cassette from [src].</span>")
	playsound(get_turf(src), 'code/WorkInProgress/carrotman2013/sounds/music/bominside.ogg', 15, 1)
	usr.put_in_hands(casseta)
	casseta = null

/obj/machinery/musicstation/attack_hand(mob/user)
	if(!casseta)
		return
	if(playing)
		StopPlaying()
		playsound(get_turf(src), 'code/WorkInProgress/carrotman2013/sounds/music/bomclick.ogg', 15, 1)
		return
	else
		StartPlaying()
		playsound(get_turf(src), 'code/WorkInProgress/carrotman2013/sounds/music/bomclick.ogg', 15, 1)


/obj/machinery/musicstation/proc/StopPlaying()
	playing = 0
	for(var/mob/living/carbon/human/H in living_mob_list)
		H << sound(null, repeat = 1, wait = 0, volume = 8, channel = 800)

/obj/machinery/musicstation/proc/StartPlaying()
	StopPlaying()
	if(isnull(casseta))
		return
	if(!casseta.sound_inside)
		return

	for(var/mob/living/carbon/human/H in living_mob_list)
		if(istype(H.wear_ear, /obj/item/device/radio/headset))
			H << sound(casseta.sound_inside, repeat = 1, wait = 0, volume = 10, channel = 800)
			msg = "Your hear music playing from your headset(<A HREF='?\ref[src];globalmusicstop=\ref[src]'> Stop</a>)"
			to_chat(H, msg)
	for(var/mob/dead/observer/O in world)
		O << sound(casseta.sound_inside, repeat = 1, wait = 0, volume = 10, channel = 800)
		msg = "Your hear music playing from your headset(<A HREF='?\ref[src];globalmusicstop=\ref[src]'> Stop</a>)"
		to_chat(O, msg)

	playing = 1

/obj/item/device/cassette
	name = "cassette tape"
	desc = "A tape. Contains some bumping tunes on it."
	icon = 'code/WorkInProgress/carrotman2013/icons/cassette.dmi'
	icon_state = "cassette_0"
	var/sound/sound_inside
	w_class = 1
	var/uploader_idiot
	var/current_side = 1
	var/sound/a_side
	var/sound/b_side

/obj/item/device/cassette/New()
	icon_state = "cassette_[rand(0,12)]"

/obj/item/device/cassette/attack_self(mob/user)
	. = ..()
	if(current_side == 1)
		sound_inside = b_side
		current_side = 2
		to_chat(user, "<span class='notice'>You flip the cassette over to the b-side.")
	else
		sound_inside = a_side
		current_side = 1
		to_chat(user, "<span class='notice'>You flip the cassette over to the a-side.")

/obj/item/device/cassette/tape1/New()
	..()
	name = "\"The World\'s Greatest Hits Vol.1\" magn-o-tape"
	a_side = pick('code/WorkInProgress/carrotman2013/sounds/music/boombox1.ogg','code/WorkInProgress/carrotman2013/sounds/music/boombox2.ogg')
	b_side = 'code/WorkInProgress/carrotman2013/sounds/music/boombox3.ogg'
	sound_inside = a_side

/obj/item/device/cassette/tape2/New()
	..()
	name = "\"The World\'s Greatest Hits Vol.2\" magn-o-tape"
	a_side = pick('code/WorkInProgress/carrotman2013/sounds/music/boombox4.ogg', 'code/WorkInProgress/carrotman2013/sounds/music/boombox5.ogg')
	b_side = 'code/WorkInProgress/carrotman2013/sounds/music/boombox6.ogg'
	sound_inside = a_side

/obj/item/device/cassette/tape3/New()
	..()
	name = "\"The World\'s Greatest Hits Vol.3\" magn-o-tape"
	a_side = 'code/WorkInProgress/carrotman2013/sounds/music/boombox7.ogg'
	b_side = 'code/WorkInProgress/carrotman2013/sounds/music/boombox8.ogg'
	sound_inside = a_side



///////////////
//////Cook/////
///////////////

/datum/job/civilian/cook
	title = "Cook"
	comm_title = "Cook"
	paygrade = "C"
	flag = ROLE_MARINE_COOK
	department_flag = ROLEGROUP_MARINE_SQUAD_MARINES
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting commander"
	selection_color = "#FDD24C"
	access = list(ACCESS_IFF_MARINE)
	minimal_access = list(ACCESS_IFF_MARINE)
	idtype = /obj/item/card/id/silver
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	skills_type = /datum/skills/civilian/survivor/chef

	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/marine,
				WEAR_BODY = /obj/item/clothing/under/rank/chef,
				WEAR_FEET = /obj/item/clothing/shoes/white,
				WEAR_HANDS = /obj/item/clothing/gloves/latex,
				WEAR_JACKET = /obj/item/clothing/suit/chef,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
				WEAR_HEAD = /obj/item/clothing/head/chefhat
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You are a civilian, working as a cook on USS Almayer.
You are tasked with cooking food and making sure the marines are well-fed.
Your role involves a lot of roleplaying, and though your supervisor is the military chain of command - you are still just a civillian with no extraordinary skills."}