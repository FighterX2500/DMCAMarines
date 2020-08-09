/obj/item/storage/kit
	icon = 'icons/Marine/Marinekits.dmi'
	w_class = 5
	foldable = null

//Kits
/obj/item/storage/kit/grenadier
	name = "Frontline M40 Grenadier kit"
	desc = "A marine kit that gives you a belt of grenades for all your explosive needs."
	icon_state = "Grenadier_kit"
	storage_slots = 2
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/storage/belt/grenade_mini(src)
			new /obj/item/storage/pouch/explosive_mini/full(src)


/obj/item/storage/kit/ak //Admin only
	name = "Experimental AK Kit"
	desc = "This marine kit gives you access to the limited AK-4047 with extra magazines and attachments to go with it."
	icon_state = "Exp_trooper_kit"
	storage_slots = 8
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/weapon/gun/rifle/ak(src)
			new /obj/item/ammo_magazine/rifle/ak(src)
			new /obj/item/ammo_magazine/rifle/ak/ap(src)
			new /obj/item/ammo_magazine/rifle/ak/incendiary(src)
			new /obj/item/attachable/stock/rifle/ak4047(src)
			new /obj/item/attachable/extended_barrel(src)
			new /obj/item/attachable/stock/rifle/ak4047(src)
			new /obj/item/attachable/flashlight/ak(src)

/obj/item/storage/kit/Heavy_Support
	name = "Forward HPR Shield Kit"
	desc = "This marine kit offers the powerful Heavy Pulse Rifle."//as well as a folding barricade for quick defensive placement and firepower.
	icon_state = "Heavy_Support_kit"
	storage_slots = 7
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/weapon/gun/rifle/lmg(src)
			new /obj/item/ammo_magazine/rifle/lmg(src)
			new /obj/item/ammo_magazine/rifle/lmg(src)
			new /obj/item/attachable/bipod(src)
			new /obj/item/weapon/shield/riot(src)
			new /obj/item/clothing/glasses/welding(src)
			new /obj/item/tool/weldingtool(src)

//obj/item/storage/box/kit/Intel
//	name = "Field Intelligence Support Kit"
//	desc = "This marine kit gives you equipment for scavenging the Area of Operations for Intel and retrieving it."
//	icon_state = "Intel_kit"
//	storage_slots =
//	max_storage_space =
//
//	New()
//		..()
//		spawn(1)


/obj/item/storage/kit/Sniper
	name = "L42A Sniper Kit"
	desc = "This marine kit comes with a L42 Battle Rifle along with a free attachment and 3 types of magazines."
	icon_state = "Mini_Sniper_kit"
	storage_slots = 6
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/pamphlet/sniper(src)
			new /obj/item/weapon/gun/rifle/sniper/L42A(src)
			new /obj/item/ammo_magazine/sniper(src)
			new	/obj/item/ammo_magazine/sniper/incendiary(src)
			new	/obj/item/ammo_magazine/sniper/flak(src)
			new /obj/item/attachable/attached_gun/laser_targeting(src)


/obj/item/storage/kit/Pyro
	name = "M240 Pyrotechnician Support Kit"
	desc = "A marine kit that gives you access to the powerful M240 Flamethrower along with equipment to refuel it and to extinguish any friendly fiery incidents."
	icon_state = "Mini_Pyro_kit"
	storage_slots = 7
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/weapon/gun/flamer(src)
			new /obj/item/storage/backpack/marine/engineerpack/flamethrower(src)
			new /obj/item/ammo_magazine/flamer_tank(src)
			new /obj/item/ammo_magazine/flamer_tank(src)
			new /obj/item/ammo_magazine/flamer_tank(src)
			new /obj/item/tool/extinguisher/mini(src)
			new /obj/item/tool/extinguisher/mini(src)

/obj/item/storage/kit/Medic
	name = "First Response Medical Support Kit"
	desc = "The marine kit gives you the ability to heal other people with more effectiveness as well as common medical supplies as what a regular combat medic uses."
	icon_state = "Mini_Medic_kit"
	storage_slots = 6
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/pamphlet/medical(src)
			new /obj/item/storage/belt/combatLifesaver(src)
			new /obj/item/storage/pouch/firstaid/full(src)
			new /obj/item/clothing/glasses/hud/health(src)
			new /obj/item/roller(src)
			new /obj/item/device/encryptionkey/med(src)

/obj/item/storage/kit/JTAC
	name = "JTAC Radio Kit"
	desc = "his marine kit gives you access to the special JTAC channel for coordinating airstrikes as well as calling them in with tactical binoculars."//and signal flare packs as well as a flare gun
	icon_state = "Mini_JTAC_kit"
	storage_slots = 3
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/device/binoculars/tactical(src)
			new /obj/item/device/encryptionkey/JTAC(src)
			new /obj/item/attachable/attached_gun/laser_targeting(src)
//			new M82-F Flare Gun
//			new M276 pattern M82F flare gun holster rig
//			new 2x Signal flares packs

/obj/item/storage/kit/Engie
	name = "Combat Technician Support Kit"
	desc = "This marine kit gives you the ability to construct defences such as metal barricades, as well as a starter construction kit for immediate defence."
	icon_state = "Mini_Engie_kit"
	storage_slots = 9
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/pamphlet/engie(src)
			new /obj/item/storage/backpack/marine/engineerpack(src)
			new /obj/item/storage/belt/utility/full(src)
			new /obj/item/clothing/gloves/yellow(src)
			new /obj/item/tool/shovel/etool(src)
			new /obj/item/clothing/glasses/welding(src)
			new /obj/item/storage/box/sentry(src)
			new /obj/item/device/encryptionkey/engi(src)

/obj/item/storage/kit/Personal_Def
	name = "Personal Defense Kit"
	desc = "This marine kit comes with an VP70 pistol which is a formidable hand gun with attachments and a holster to make it yours."
	icon_state = "Personal_Def_kit"
	storage_slots = 2
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/storage/belt/gun/m4a3/vp70(src)
			new /obj/item/attachable/lasersight(src)

/obj/item/storage/kit/Saiga
	name = "Saiga Field Test Kit"
	desc = "This marine kit gives you access to the limited Saiga shotgun as well as different types of ammo for it."
	icon_state = "Sapper_kit"
	storage_slots = 4
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/weapon/gun/rifle/saiga(src)
			new /obj/item/ammo_magazine/rifle/saiga(src)
			new /obj/item/ammo_magazine/rifle/saiga(src)
			new /obj/item/ammo_magazine/rifle/saiga/buckshot(src)

/obj/item/storage/kit/Pursuit
	name = "M39 Point Man Kit"
	desc = "This marine kit gives the M39 SMG, allowing it to chase after targets with more ease."//with the SMG Arm Brace
	icon_state = "Pursuit_kit"
	storage_slots = 5
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/weapon/gun/smg/m39(src)
			new /obj/item/ammo_magazine/smg/m39(src)
			new /obj/item/ammo_magazine/smg/m39/extended(src)
			new /obj/item/attachable/magnetic_harness(src)
			new /obj/item/storage/large_holster/machete/full(src)

/obj/item/storage/kit/Veteran
	name = "Veteran Kit"
	desc = "This marine kit give you access to the old MK1 Pulse Rifle as well as spare magazines for it and under barrel attachments."
	icon_state = "Veteran_kit"
	storage_slots = 8
	can_hold = list()

	New()
		..()
		spawn(1)
			new /obj/item/weapon/gun/rifle/m41aMK1(src)
			new /obj/item/ammo_magazine/rifle/m41aMK1(src)
			new /obj/item/ammo_magazine/rifle/m41aMK1(src)
			new /obj/item/ammo_magazine/rifle/m41aMK1(src)
			new /obj/item/ammo_magazine/rifle/m41aMK1(src)
			new /obj/item/ammo_magazine/rifle/m41aMK1(src)
			new /obj/item/attachable/attached_gun/flamer(src)
			new /obj/item/attachable/attached_gun/shotgun(src)