/mob/living/simple_animal/hostile/alien
	name = "alien trooper"
	icon = 'icons/Xeno/1x1_Xenos.dmi'
	icon_state = "Hunter Running"
	icon_living = "Hunter Running"
	icon_dead = "Hunter Dead"
	icon_gib = "syndicate_gib"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = -1
	meat_type = /obj/item/reagent_container/food/snacks/xenomeat
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 35
	attacktext = "slashes"
	a_intent = "harm"
	attack_sound = 'sound/weapons/alien_claw_flesh1.ogg'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = "alien"
	wall_smash = 1
	status_flags = CANPUSH
	minbodytemp = 0
	heat_damage_per_tick = 20
	stop_automated_movement_when_pulled = 1
	break_stuff_probability = 90

/mob/living/simple_animal/hostile/alien/IgniteMob()			//Crowd control!
	health = -maxHealth

/mob/living/simple_animal/hostile/alien/Life()				//I deserve to burn in hell@polion1232
	. = ..()
	if(!.)
		return 0

	var/obj/effect/alien/weeds/W = locate() in src.loc
	if(W != null && stat != DEAD)
		health = min(maxHealth, health+5)
	handle_bot_alien_behavior()
	return 1

/mob/living/simple_animal/hostile/alien/proc/handle_bot_alien_behavior()
	return

/mob/living/simple_animal/hostile/alien/drone
	name = "alien lesser drone"
	icon_state = "Drone Running"
	icon_living = "Drone Running"
	icon_dead = "Drone Dead"
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 25

/mob/living/simple_animal/hostile/alien/drone/handle_bot_alien_behavior()
	var/obj/effect/alien/weeds/W = locate() in range(4, loc)
	var/obj/effect/alien/weeds/node/N = locate() in range(6, loc)
	if(!W || !N)
		var/turf/T = src.loc
		if(!istype(T) && !T.is_weedable())
			return

		new /obj/effect/alien/weeds/node(src.loc, src, null)
		playsound(src.loc, "alien_resin_build", 25)

// Still using old projectile code - commenting this out for now
// /mob/living/simple_animal/hostile/alien/sentinel
// 	name = "alien sentinel"
// 	icon_state = "Sentinel Running"
// 	icon_living = "Sentinel Running"
// 	icon_dead = "Sentinel Dead"
// 	health = 120
// 	melee_damage_lower = 15
// 	melee_damage_upper = 15
// 	ranged = 1
// 	projectiletype = /obj/item/projectile/neurotox
// 	projectilesound = 'sound/weapons/pierce.ogg'

/mob/living/simple_animal/hostile/alien/ravager
	name = "alien tearer"
	icon = 'icons/Xeno/2x2_Xenos.dmi'
	icon_state = "Ravager Running"
	icon_living = "Ravager Running"
	icon_dead = "Ravager Dead"
	melee_damage_lower = 35
	melee_damage_upper = 45
	maxHealth = 200
	health = 200

	var/rage = 0								//The more you hit with bullets, meanier it would be
	var/maxrage = 3

/mob/living/simple_animal/hostile/alien/ravager/bullet_act(obj/item/projectile/Proj)
	. = ..()

	if(rage < maxrage)
		if(prob(rage*10))
			visible_message("<span class='xenodanger'>[src] becomes enraged!</span>","", null, 5)
		rage++
		melee_damage_upper += 5*rage
		melee_damage_lower += 5


/mob/living/simple_animal/hostile/alien/ravager/handle_bot_alien_behavior()
	if(rage > 0)
		melee_damage_upper -= 5*rage
		melee_damage_lower -= 5
		rage--

/obj/item/projectile/neurotox
	damage = 30
	icon_state = "toxin"

/mob/living/simple_animal/hostile/alien/death(gibbed, deathmessage = "lets out a waning guttural screech, green blood bubbling from its maw.")
	. = ..()
	if(!.) return //If they were already dead, it will return.
	playsound(src, 'sound/voice/alien_death.ogg', 50, 1)
