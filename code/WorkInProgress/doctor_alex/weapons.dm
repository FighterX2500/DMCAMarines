//-------------------------------------STORMTROOPER------------------------------------------------------//

/obj/item/weapon/twohanded/hammer
	name = "N45 battle hammer"
	desc = "RIP AND TEAR."
	icon_state = "sledgehammer"
	item_state = "sledgehammer"
	force = 30
	flags_item = TWOHANDED|ANTISTRUCTURE
	force_wielded = 45
	w_class = 4
	sharp = IS_SHARP_ITEM_BIG
	flags_equip_slot = SLOT_WAIST|SLOT_BACK

/obj/item/weapon/twohanded/hammer/attack(mob/M, mob/user)
    ..()
    if(flags_item & WIELDED && prob(40) && !M.knocked_down)
        M.KnockDown(6)

/obj/item/weapon/twohanded/hammer/true
	name = "N45 battle hammer"
	desc = "RIP AND TEAR."
	icon_state = "sledgehammer"
	item_state = "sledgehammer"
	force = 30
	flags_item = TWOHANDED
	force_wielded = 45
	w_class = 4
	sharp = IS_SHARP_ITEM_BIG
	flags_equip_slot = SLOT_WAIST|SLOT_BACK

/obj/item/weapon/twohanded/hammer/true/attack(mob/M, mob/user)
    ..()
    if(flags_item & WIELDED && prob(40))
        M.KnockDown(6)

/obj/item/weapon/twohanded/hammer/true/afterattack(atom/A as mob|obj|turf|area, mob/user, proximity)
	if(get_dist(A,user) > 1)
		return

	var/atom/throw_target = get_edge_target_turf(A, get_dir(user, A))
	if(istype(A, /atom/movable))
		var/atom/movable/AM = A
		AM.throw_at(throw_target, 4, 2, user)

	for(var/atom/movable/M in range(A,1))
		if(M == user)
			continue

		if(M == A)
			continue

		if(!M.anchored)
			M.throw_at(throw_target, 2, 3, user)

/obj/item/weapon/shield/montage/marine
	name = "N30-2 standard defensive shield"
	desc = "A heavy shield adept at blocking blunt or sharp objects from connecting with the shield wielder."
	icon = 'icons/obj/items/weapons.dmi'
	icon_state = "marine_shield"
	flags_equip_slot = SLOT_BACK
	block_chance = 85
	force = 15
	throwforce = 6
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed", "slash")
	cooldown = 4 //shield bash cooldown. based on world.time

/obj/item/weapon/shield/montage/marine/attack(mob/M, mob/user)
	. = ..()
	if(isYautja(M))
		return
	var/mob/living/carbon/Xenomorph/X
	if(isXeno(M) && X.tier == 1)
		if(prob(40))
			M.KnockDown(2)
			return
	if(ishuman(M))
		if(prob(20))
			M.KnockOut(15)

//-------------------------------------GUNS------------------------------------------------------//

/obj/item/weapon/gun/shotgun/merc/spec
	name = "spec's super-shotgun"
	desc = "A cobbled-together pile of scrap and alien wood. Point end towards things you want to die. Has a burst fire feature, as if it needed it."
	icon_state = "super_shotgun"
	item_state = "super_shotgun"
	origin_tech = "combat=4;materials=2"
	fire_sound = 'sound/weapons/gun_shotgun_automatic.ogg'
	current_mag = /obj/item/ammo_magazine/internal/shotgun/spec
	attachable_allowed = list(
						/obj/item/attachable/bayonet,
						/obj/item/attachable/reddot)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG|GUN_TRIGGER_SAFETY

/obj/item/weapon/gun/shotgun/merc/New()
	..()
	attachable_offset = list("muzzle_x" = 31, "muzzle_y" = 19,"rail_x" = 10, "rail_y" = 20, "under_x" = 26, "under_y" = 14, "stock_x" = 17, "stock_y" = 14)
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()

/obj/item/weapon/gun/shotgun/merc/spec/set_gun_config_values()
	fire_delay = config.high_fire_delay*2
	accuracy_mult = config.base_hit_accuracy_mult - config.med_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.med_hit_accuracy_mult - config.hmed_hit_accuracy_mult
	scatter = config.med_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.low_recoil_value
	recoil_unwielded = config.low_recoil_value

	//Vertical grip
	var/obj/item/attachable/verticalgrip/S = new(src)
	S.attach_icon = ""
	S.icon_state = ""
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)

/obj/item/weapon/gun/shotgun/merc/spec/examine(mob/user)
	..()
	if(in_chamber) to_chat(user, "It has a chambered round.")

/obj/item/weapon/gun/rifle/saiga
	name = "Saiga 22 shotgun"
	desc = "A custom made automatic shotgun,this shotgun can rival tactical shotgun and is only given to elite USCM units."
	icon_state = "saiga"
	item_state = "saiga"
	fire_sound = 'sound/weapons/gun_shotgun.ogg'
	origin_tech = "combat=7;materials=5"
	current_mag = /obj/item/ammo_magazine/rifle/saiga
	type_of_casings = "shell"
	gun_skill_category = GUN_SKILL_SHOTGUNS
	attachable_allowed = list()
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_TRIGGER_SAFETY

/obj/item/weapon/gun/rifle/saiga/New()
	..()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 21,"rail_x" = 15, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)
	//Vertical grip
	var/obj/item/attachable/verticalgrip/S = new(src)
	S.attach_icon = ""
	S.icon_state = ""
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachable(S.slot)
	//scope
	var/obj/item/attachable/reddot/F = new(src)
	F.attach_icon = ""
	F.icon_state = ""
	F.flags_attach_features &= ~ATTACH_REMOVABLE
	F.Attach(src)
	update_attachable(F.slot)


/obj/item/weapon/gun/rifle/saiga/set_gun_config_values()
	fire_delay = config.mhigh_fire_delay*3
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult + config.low_hit_accuracy_mult - config.hmed_hit_accuracy_mult
	scatter = config.med_scatter_value
	scatter_unwielded = config.max_scatter_value
	damage_mult = config.base_hit_damage_mult - config.low_hit_damage_mult
	recoil = config.low_recoil_value
	recoil_unwielded = config.high_recoil_value

/obj/item/weapon/gun/rifle/ak
	name = "AK-4047 heavy rifle"
	desc = "Compact UPP gun with extensive modification capabilities. Mainly used by heavy infantry."
	icon_state = "ak40"
	item_state = "ak40"
	wield_delay = WIELD_DELAY_NORMAL + WIELD_DELAY_VERY_FAST
	origin_tech = "combat=5;materials=4"
	fire_sound = 'sound/weapons/gun_mar40.ogg'
	current_mag = /obj/item/ammo_magazine/rifle/ak
	attachable_allowed = list(
						/obj/item/attachable/extended_barrel,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/bipod,
						/obj/item/attachable/stock/rifle/ak4047,
						/obj/item/attachable/flashlight/ak,
						/obj/item/attachable/heavy_barrel,
						/obj/item/attachable/compensator,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/shotgun,
						)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY|GUN_TRIGGER_SAFETY
	gun_skill_category = GUN_SKILL_HEAVY_WEAPONS

/obj/item/weapon/gun/rifle/ak/New()
	..()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 14,"rail_x" = 17, "rail_y" = 19, "under_x" = 19, "under_y" = 12, "stock_x" = 24, "stock_y" = 13)
	//scope
	var/obj/item/attachable/scope/F = new(src)
	F.attach_icon = ""
	F.icon_state = ""
	F.flags_attach_features &= ~ATTACH_REMOVABLE
	F.Attach(src)
	update_attachable(F.slot)

/obj/item/weapon/gun/rifle/ak/set_gun_config_values()
	fire_delay = config.med_fire_delay
	burst_amount = config.med_burst_value
	burst_delay = config.mlow_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.max_hit_accuracy_mult
	scatter = config.low_scatter_value
	scatter_unwielded = config.max_scatter_value * 2
	damage_mult = config.base_hit_damage_mult
	recoil_unwielded = config.med_recoil_value

//L42A - Another one, but by me
/obj/item/weapon/gun/rifle/sniper/L42A2
	gun_skill_category = GUN_SKILL_RIFLES
	name = "L42A scoped rifle"
	desc = "A smaller version of M42A, manufactured by Armat Systems. It has a scope system and fires armor penetrating rounds out of a 15-round magazine."
	icon_state = "l42a"
	item_state = "l42a"
	origin_tech = "combat=6;materials=5"
	fire_sound = 'sound/weapons/gun_sniper.ogg'
	current_mag = /obj/item/ammo_magazine/l42a
	force = 10
	wield_delay = 16 //Ends up being 2 seconds due to scope
	zoomdevicename = "scope"
	attachable_allowed = list(/obj/item/attachable/bipod,
							  /obj/item/attachable/attached_gun/laser_targeting,
							  /obj/item/attachable/verticalgrip,
							  /obj/item/attachable/lasersight)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_TRIGGER_SAFETY

/obj/item/weapon/gun/rifle/sniper/L42A2/New()
	..()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 20, "under_x" = 25, "under_y" = 15, "stock_x" = 19, "stock_y" = 14)
	var/obj/item/attachable/scope/S = new(src)
	S.attach_icon = "" //Let's make it invisible. The sprite already has one.
	S.icon_state = ""
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	var/obj/item/attachable/sniperbarrel/Q = new(src)
	Q.attach_icon = ""
	Q.icon_state = ""
	Q.flags_attach_features &= ~ATTACH_REMOVABLE
	Q.Attach(src)
	update_attachables()


/obj/item/weapon/gun/rifle/sniper/L42A2/set_gun_config_values()
	fire_delay = config.med_fire_delay
	burst_amount = config.min_burst_value
	accuracy_mult = config.base_hit_accuracy_mult
	scatter = config.low_scatter_value
	damage_mult = config.base_hit_damage_mult
	recoil = config.min_recoil_value

//-------------------------------------AMMO & MAGS------------------------------------------------------//

/obj/item/ammo_magazine/l42a
	name = "L42A marksman magazine (10x28mm Caseless)"
	desc = "A magazine of sniper rifle ammo."
	caliber = "10x28mm"
	icon_state = "l42a"
	w_class = 3
	max_rounds = 15
	default_ammo = /datum/ammo/bullet/l42
	gun_type = /obj/item/weapon/gun/rifle/sniper/L42A2

	New()
		..()
		reload_delay = config.low_fire_delay

/obj/item/ammo_magazine/l42a/incendiary
	name = "L42A incendiary magazine (10x28mm)"
	default_ammo = /datum/ammo/bullet/l42/incendiary
	icon_state = "l42a_incendiary"

/obj/item/ammo_magazine/l42a/ap
	name = "L42A AP magazine (10x28mm)"
	default_ammo = /datum/ammo/bullet/l42/ap
	icon_state = "l42a_AP"

/datum/ammo/bullet/l42
	name = "sniper bullet"
	damage_falloff = 0
	iff_signal = ACCESS_IFF_MARINE
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SKIPS_HUMANS|AMMO_SNIPER
	accurate_range_min = 10

/datum/ammo/bullet/l42/New()
	..()
	accurate_range = config.min_shell_range
	max_range = config.max_shell_range
	scatter = -config.med_scatter_value
	damage = config.med_hit_damage
	penetration= config.mhigh_armor_penetration
	shell_speed = config.ultra_shell_speed

/datum/ammo/bullet/l42/incendiary
	name = "incendiary sniper bullet"
	damage_type = BURN
	iff_signal = ACCESS_IFF_MARINE
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_INCENDIARY|AMMO_SKIPS_HUMANS|AMMO_SNIPER

/datum/ammo/bullet/l42/incendiary/New()
	..()
	accuracy = config.hmed_hit_accuracy
	max_range = config.norm_shell_range
	scatter = config.low_scatter_value
	damage = config.low_hit_damage
	penetration= config.low_armor_penetration

/datum/ammo/bullet/l42/ap
	name = "AP sniper bullet"
	iff_signal = ACCESS_IFF_MARINE

/datum/ammo/bullet/l42/ap/New()
	..()
	accuracy = config.hmed_hit_accuracy
	max_range = config.norm_shell_range
	scatter = config.low_scatter_value
	damage = config.lmed_hit_damage
	penetration = config.high_armor_penetration

/obj/item/ammo_magazine/rifle/saiga
	name = "Saiga 22 slug magazine"
	desc = "A slug magazine that fits in the Saiga 22 shotgun."
	caliber = "12g"
	icon_state = "saiga_slug"
	default_ammo = /datum/ammo/bullet/shotgun/slug
	max_rounds = 10
	gun_type = /obj/item/weapon/gun/rifle/saiga/

/obj/item/ammo_magazine/rifle/saiga/buckshot
	name = "Saiga 22 buckshot magazine"
	desc = "A buckshot magazine that fits in the Saiga 22 shotgun."
	caliber = "12g"
	icon_state = "saiga_buckshot"
	default_ammo = /datum/ammo/bullet/shotgun/buckshot
	max_rounds = 10
	bonus_overlay = "saiga_buckshot_over"
	gun_type = /obj/item/weapon/gun/rifle/saiga/

/obj/item/ammo_magazine/rifle/saiga/incendiary
	name = "Saiga 22 incendiary magazine"
	desc = "A incendiary magazine that fits in the Saiga 22 shotgun."
	caliber = "12g"
	icon_state = "saiga_incendiary"
	default_ammo = /datum/ammo/bullet/shotgun/incendiary
	max_rounds = 10
	bonus_overlay = "saiga_incendiary_over"
	gun_type = /obj/item/weapon/gun/rifle/saiga/

/obj/item/ammo_magazine/rifle/ak
	name = "AK-4047 magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine."
	caliber = "10x24mm"
	icon_state = "akfuture"
	w_class = 3
	default_ammo = /datum/ammo/bullet/rifle/ak
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/ak

/obj/item/ammo_magazine/rifle/ak/incendiary
	name = "AK-4047 incendiary magazine (10x24mm)"
	desc = "A 10mm assault rifle magazine."
	icon_state = "akfuture_incendiary"
	default_ammo = /datum/ammo/bullet/rifle/ak/incendiary

/obj/item/ammo_magazine/rifle/ak/ap
	name = "AK-4047 AP magazine (10x24mm)"
	desc = "A 10mm armor piercing magazine."
	icon_state = "akfuture_AP"
	default_ammo = /datum/ammo/bullet/rifle/ak/ap

/datum/ammo/bullet/rifle/ak
	name = "rifle bullet"

/datum/ammo/bullet/rifle/ak/New()
	..()
	accurate_range = config.min_shell_range
	damage = config.med_hit_damage
	penetration = config.mlow_armor_penetration

/datum/ammo/bullet/rifle/ak/ap
	name = "armor-piercing rifle bullet"

/datum/ammo/bullet/rifle/ak/ap/New()
	..()
	damage = config.lmed_hit_damage
	penetration = config.high_armor_penetration

/datum/ammo/bullet/rifle/ak/incendiary
	name = "incendiary rifle bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_INCENDIARY

/datum/ammo/bullet/rifle/ak/incendiary/New()
	..()
	accurate_range = config.short_shell_range