//Some weapons/equipment that is used only in squad marine kits.

//Mini grenadier belt

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




//Mini expolosive pouch

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





//Pamphlets - learning new skills

//Medical Pamphlet
/obj/item/pamphlet/medical
	icon = 'icons/obj/items/books.dmi'
	name = "Medical Pamphlet"
	desc = "A medical pamphlet which holds a useful information to increase your skills"
	icon_state = "bookMedical"

/obj/item/pamphlet/medical/attack_self(mob/living/carbon/human/H as mob)
	if(H.mind.assigned_role == "Squad Marine")
		H.mind.cm_skills.medical = SKILL_MEDICAL_MEDIC
		to_chat(H, "Your medical skills have been updated.")
		Dispose()
	else
		to_chat(H, "This information is either useless or not that important for you.")


//Engineering Pamphlet
/obj/item/pamphlet/engie
	icon = 'icons/obj/items/books.dmi'
	name = "Engineering Pamphlet"
	desc = "An engineering pamphlet which holds a useful information to increase your skills"
	icon_state = "bookEngineering2"

/obj/item/pamphlet/engie/attack_self(mob/living/carbon/human/H as mob)
	if(H.mind.assigned_role == "Squad Marine")
		H.mind.cm_skills.engineer = SKILL_ENGINEER_ENGI
		H.mind.cm_skills.construction = SKILL_CONSTRUCTION_PLASTEEL
		to_chat(H, "Your engineering skills have been updated.")
		Dispose()
	else
		to_chat(H, "This information is either useless or not that important for you.")


//Sniper Pamphlet
/obj/item/pamphlet/sniper
	icon = 'icons/obj/items/books.dmi'
	name = "Sniper Pamphlet"
	desc = "A sniper-related pamphlet which holds a useful information to increase your skills"
	icon_state = "book"

/obj/item/pamphlet/sniper/attack_self(mob/living/carbon/human/H as mob)
	if(H.mind.assigned_role == "Squad Marine")
		H.mind.cm_skills.spec_weapons = SKILL_SPEC_SNIPER
		to_chat(H, "Your sniper skills have been updated.")
		Dispose()
	else
		to_chat(H, "This information is either useless or not that important for you.")



//L42A - Copy of M42A but with worse stats
/obj/item/weapon/gun/rifle/sniper/L42A
	gun_skill_category = GUN_SKILL_RIFLES
	name = "L42A scoped rifle"
	desc = "A smaller version of M42A, manufactured by Armat Systems. It has a scope system and fires armor penetrating rounds out of a 15-round magazine."
	icon_state = "m42a"
	item_state = "m42a"
	origin_tech = "combat=6;materials=5"
	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/sniper
	force = 10
	wield_delay = 16 //Ends up being 2 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod,
							  /obj/item/attachable/attached_gun/laser_targeting)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_TRIGGER_SAFETY

	New()
		select_gamemode_skin(type, list(MAP_ICE_COLONY = "s_m42a") )
		..()
		attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 20, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)
		var/obj/item/attachable/scope/mini/S = new(src)
		S.attach_icon = "" //Let's make it invisible. The sprite already has one.
		S.icon_state = ""
		S.flags_attach_features &= ~ATTACH_REMOVABLE
		S.Attach(src)
		var/obj/item/attachable/sniperbarrel/Q = new(src)
		Q.Attach(src)
		update_attachables()


/obj/item/weapon/gun/rifle/sniper/L42A/set_gun_config_values()
	fire_delay = config.high_fire_delay*5
	burst_amount = config.min_burst_value
	accuracy_mult = config.base_hit_accuracy_mult
	scatter = config.low_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.low_recoil_value