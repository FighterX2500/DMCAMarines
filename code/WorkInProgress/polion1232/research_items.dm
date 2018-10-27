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