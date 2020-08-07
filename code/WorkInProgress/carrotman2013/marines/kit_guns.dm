//Grenadier belt
/obj/item/storage/belt/grenade_mini
	name="M276 pattern M40 grenade rig"
	desc="The M276 is the standard load-bearing equipment of the USCM. It consists of a modular belt with various clips. This version is designed to carry bulk quantities of M40 Grenades."
	icon_state="grenadebelt" // temp
	item_state="s_marine"
	w_class = 4
	storage_slots = 9
	max_w_class = 3
	max_storage_space = 12
	can_hold = list("/obj/item/explosive/grenade")

/obj/item/storage/belt/grenade_mini/New()
	..()
	spawn(1)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/incendiary(src)
		new /obj/item/explosive/grenade/frag(src)
		new /obj/item/explosive/grenade/frag(src)
		new /obj/item/explosive/grenade/frag(src)


//Expolosive pouch
/obj/item/storage/pouch/explosive_mini
	name = "explosive pouch"
	desc = "It can contain grenades, plastiques, mine boxes, and other explosives."
	icon_state = "large_explosive"
	storage_slots = 3
	max_w_class = 3
	can_hold = list(
					"/obj/item/explosive/plastique",
					"/obj/item/explosive/mine",
					"/obj/item/explosive/grenade",
					"/obj/item/storage/box/explosive_mines"
					)

/obj/item/storage/pouch/explosive_mini/full/New()
	..()
	new /obj/item/explosive/plastique(src)
	new /obj/item/explosive/plastique(src)
	new /obj/item/explosive/grenade/frag(src)


//JTAC stuff

/obj/item/device/encryptionkey/JTAC
	name = "JTAC radio encryption key"
	icon_state = "cypherkey"
	channels = list("JTAC" = 1)



//Pamphlets - huynya dlya bistrogo polucheniya skillov

//Medical Pamphlet(src)

