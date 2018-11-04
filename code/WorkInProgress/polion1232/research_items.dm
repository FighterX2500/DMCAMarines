/obj/item/reagent_container/spray/anti_weed
	name = "Weed-B-Gone Sprayer"
	desc = "Sprayer and canister, filled with Plant-B-Gone to burst. Spraying distance is horrifyingly large. Those xeno scums will definatly hate you."
	icon = 'code/WorkInProgress/polion1232/polionresearch.dmi'
	icon_state = "weed-killer"
	item_state = "weed-killer"

	throwforce = 3
	spray_size = 3
	w_class = 4.0
	possible_transfer_amounts = null
	volume = 1000

/obj/item/reagent_container/spray/anti_weed/New()
	..()
	reagents.add_reagent("plantbgone", 1000)

/obj/item/reagent_container/spray/anti_weed/Spray_at(atom/A)
	var/obj/effect/decal/chempuff/D = new/obj/effect/decal/chempuff(get_turf(src))
	D.create_reagents(spray_size * amount_per_transfer_from_this)
	reagents.trans_to(D, amount_per_transfer_from_this, 1/spray_size)
	D.color = mix_color_from_reagents(D.reagents.reagent_list)

	var/direction = get_dir(src, A)
	var/turf/A_center = get_turf(A)//BS12
	var/turf/A_left = get_step(A_center, turn(direction, 90))
	var/turf/A_right = get_step(A_center, turn(direction, -90))

	var/obj/effect/decal/chempuff/Right = new/obj/effect/decal/chempuff(get_turf(src))
	Right.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(Right, amount_per_transfer_from_this, 1/spray_size, 1)
	Right.color = mix_color_from_reagents(D.reagents.reagent_list)
	Right.dir = turn(direction, -45)

	var/obj/effect/decal/chempuff/Left = new/obj/effect/decal/chempuff(get_turf(src))
	Left.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(Left, amount_per_transfer_from_this, 1/spray_size, 1)
	Left.color = mix_color_from_reagents(D.reagents.reagent_list)
	Left.dir = turn(direction, 45)

	var/spray_dist = spray_size
	spawn(0)
		for(var/i=0, i<spray_dist, i++)
			step_towards(D,A)
			step(Right, Right.dir)
			step(Left, Left.dir)
			Right.dir = direction
			Left.dir = direction
			D.reagents.reaction(get_turf(D))
			Right.reagents.reaction(get_turf(Right))
			Left.reagents.reaction(get_turf(Left))
			for(var/atom/T in get_turf(D))
				D.reagents.reaction(T)

				// When spraying against the wall, also react with the wall, but
				// not its contents. BS12
				if(get_dist(D, A_center) == 1 && A_center.density)
					D.reagents.reaction(A_center)
			for(var/atom/T in get_turf(Left))
				Left.reagents.reaction(T)
				if(get_dist(Left, A_left) == 1 && A_left.density)
					Left.reagents.reaction(A_left)
			for(var/atom/T in get_turf(Right))
				Right.reagents.reaction(T)
				if(get_dist(Right, A_right) == 1 && A_right.density)
					Right.reagents.reaction(A_right)
				sleep(2)
			sleep(3)
		cdel(D)
		cdel(Left)
		cdel(Right)

////////////

/obj/item/anti_acid
	name = "Acid-Kill Spray"
	desc = "Small sprayer, filled with special mixture of alkalies that can neutralize even xenomorphs' acids."
	icon = 'code/WorkInProgress/polion1232/polionresearch.dmi'
	icon_state = "anti-acid"
	item_state = "anti-acid"
	var/max_use = 10
	var/use_time				//1 against weak acid, 5 - acid, Strong acid is unpurgeable

/obj/item/anti_acid/New()
	..()
	use_time = max_use

/////////////
/*
/obj/item/weapon/gun/energy/tesla			//ZZZZZZZZZAP
	name = "HEW-2 \"Zeus\""
	//name = "ESW MKIV \"Paralyzer\""		//
	des = "The actual firearm in 2-piece HEW(Heavy Electrical Weapon) system MKII. Being civilian-grade gun system, primary used by scientific divisions, that gun can still be useful for USCM in limited numbers."
	icon_state = "m56"
	item_state = "m56"
	ammo = /datum/ammo/energy/taser/tesla
	var/charge_cost = 100
	var/overcharge_cost = 200
	var/charge = 0			//prepered charge
	var/overcharge = 0		//If you want kill xeno tho. But only 50 burn
	gun_skill_category = GUN_SKILL_SMARTGUN		//Heavy as fuck
	flags_gun_features = GUN_INTERNAL_MAG|GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/energy/tesla/set_gun_config_values()
	fire_delay = config.max_fire_delay * 2
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult
	scatter = config.med_scatter_value
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult

/obj/item/weapon/gun/tesla/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user)) return 0
		var/mob/living/carbon/human/H = user
		if(user.mind && user.mind.cm_skills && user.mind.cm_skills.smartgun < SKILL_SMART_USE)
			to_chat(user, "<span class='warning'>You don't seem to know how to use [src]...</span>")
			return 0

/obj/item/weapon/gun/tesla/proc/auto_reload()
	set waitfor = 0
	sleep(5)
	if(power_pack && power_pack.loc)
		power_pack.attack_self(smart_gunner, TRUE)
*/