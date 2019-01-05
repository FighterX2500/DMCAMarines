


//-------------------------------------------------------
//M41A PULSE RIFLE AMMUNITION

/obj/item/ammo_magazine/rifle
	name = "M41A magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine."
	caliber = "10x24mm"
	icon_state = "m41a"
	w_class = 3
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/m41a

/obj/item/ammo_magazine/rifle/extended
	name = "M41A extended magazine (10x24mm)"
	desc = "A 10mm assault extended rifle magazine."
	max_rounds = 60
	bonus_overlay = "m41a_ex"

/obj/item/ammo_magazine/rifle/incendiary
	name = "M41A incendiary magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine."
	icon_state = "m41a_incendiary"
	default_ammo = /datum/ammo/bullet/rifle/incendiary

/obj/item/ammo_magazine/rifle/ap
	name = "M41A AP magazine (10x24mm)"
	desc = "A 10mm armor piercing magazine."
	icon_state = "m41a_AP"
	default_ammo = /datum/ammo/bullet/rifle/ap


//-------------------------------------------------------
//M41A TRUE AND ORIGINAL

/obj/item/ammo_magazine/rifle/m41aMK1
	name = "M41AMK1 magazine (10x24mm)"
	desc = "A semi-rectangular box of rounds for the original M41A Pulse Rifle."
	max_rounds = 95
	gun_type = /obj/item/weapon/gun/rifle/m41aMK1



//-------------------------------------------------------
//MAR-40 AK CLONE //AK47 and FN FAL together as one.

/obj/item/ammo_magazine/rifle/mar40
	name = "MAR magazine (7.62x39mm)"
	desc = "A 7.62x39mm magazine for the MAR series of firearms."
	caliber = "7.62x39mm"
	icon_state = "mar40"
	default_ammo = /datum/ammo/bullet/rifle/mar40
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/mar40

/obj/item/ammo_magazine/rifle/mar40/extended
	name = "MAR extended magazine (7.62x39mm)"
	desc = "A 7.62x39mm MAR magazine, this one carries more rounds than the average magazine."
	max_rounds = 60
	bonus_overlay = "mar40_ex"



//-------------------------------------------------------
//M16 RIFLE

/obj/item/ammo_magazine/rifle/m16
	name = "M16 magazine (5.56x45mm)"
	desc = "A 5.56x45mm magazine for the M16 assault rifle."
	caliber = "5.56x45mm"
	icon_state = "mar40" //PLACEHOLDER
	default_ammo = /datum/ammo/bullet/rifle
	max_rounds = 20 //Also comes in 30 and 100 round Beta-C mag.
	gun_type = /obj/item/weapon/gun/rifle/m16


//-------------------------------------------------------
//M41AE2 HEAVY PULSE RIFLE

/obj/item/ammo_magazine/rifle/lmg
	name = "M41AE2 ammo box (10x24mm)"
	desc = "A semi-rectangular box of rounds for the M41AE2 Heavy Pulse Rifle."
	icon_state = "m41ae2"
	max_rounds = 300
	gun_type = /obj/item/weapon/gun/rifle/lmg


//-------------------------------------------------------
//UPP TYPE 71 RIFLE

/obj/item/ammo_magazine/rifle/type71
	name = "Type 71 magazine (7.62x39mm)"
	desc = "A 7.62x39mm magazine that fits in the Type 71 rifle."
	caliber = "7.62x39mm"
	icon_state = "type_71"
	default_ammo = /datum/ammo/bullet/rifle/mar40
	max_rounds = 40
	gun_type = /obj/item/weapon/gun/rifle/type71
	
//-------------------------------------------------------
//UPP Saiga shotgun
	
/obj/item/ammo_magazine/rifle/saiga
	name = "Saiga 22 slug magazine"
	desc = "A slug magazine that fits in the Saiga 22 shotgun."
	caliber = "12g"
	icon_state = "saiga_slug"
	default_ammo = /datum/ammo/bullet/shotgun/slug
	max_rounds = 10
	gun_type = /obj/item/weapon/gun/rifle/saiga/
//-------------------------------------------------------
/obj/item/ammo_magazine/rifle/saiga/buckshot
	name = "Saiga 22 buckshot magazine"
	desc = "A buckshot magazine that fits in the Saiga 22 shotgun."
	caliber = "12g"
	icon_state = "saiga_buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	max_rounds = 10
	bonus_overlay = "saiga_buckshot_over"
	gun_type = /obj/item/weapon/gun/rifle/saiga/
//-------------------------------------------------------
/obj/item/ammo_magazine/rifle/saiga/incendiary
	name = "Saiga 22 incendiary magazine"
	desc = "A incendiary magazine that fits in the Saiga 22 shotgun."
	caliber = "12g"
	icon_state = "saiga_incendiary"
	default_ammo = /datum/ammo/bullet/shotgun/incendiary
	max_rounds = 10
	bonus_overlay = "saiga_incendiary_over"
	gun_type = /obj/item/weapon/gun/rifle/saiga/

	


