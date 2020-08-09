/mob/living/simple_animal/alien
	name = "alien trooper"
	desc = "Common hivetrooper. Weak, but can overwhelm with numbers"
	icon = 'icons/Xeno/1x1_Xenos.dmi'
	icon_state = "Hunter Running"
	icon_living = "Hunter Running"
	icon_dead = "Hunter Dead"
	icon_gib = "syndicate_gib"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 0.5
	meat_type = /obj/item/reagent_container/food/snacks/xenomeat
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
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
	wall_smash = 0
	status_flags = CANPUSH
	minbodytemp = 0
	heat_damage_per_tick = 20
	stop_automated_movement_when_pulled = 1
	var/break_stuff_probability = 90

	var/last_attack = 0
	var/attack_speed = 10
	melee_damage_lower = 15
	melee_damage_upper = 25
	var/attack_same = 0
	var/list/friends = list()
	var/stance = HOSTILE_STANCE_IDLE
	var/atom/target = null
	var/mob/living/leader
	var/destroy_surroundings = 1
	var/move_to_delay = 3
	var/xeno_forbid_retract = 0
	var/xeno_number = XENO_HIVE_NORMAL

/mob/living/simple_animal/alien/New(loc, number=XENO_HIVE_NORMAL)
	. = ..()
	if(number > 0 && number <= hive_datum.len && z != 2)
		xeno_number = number
		hive_datum[number].xeno_lessers_list += src
		color = hive_datum[number].color
		name = "[hive_datum[number].prefix][name]"

/mob/living/simple_animal/alien/verb/Enter_Bot()
	set category = "Ghost"
	set name = "Possess Lesser Alien"
	set src in oview(usr.client)

	if(!usr)
		return
	if(!isobserver(usr))
		return
	if(stat == DEAD)
		return
	enter_bot(usr)

/mob/living/simple_animal/alien/verb/leave()
	set category = "Ghost"
	set name = "Leave Lesser"
	set desc = "Relinquish your life and enter the land of the dead."

	ghostize(1)

/mob/living/simple_animal/alien/proc/enter_bot(mob/oldmob)
	if(disposed || !oldmob.ckey)
		return
	if(ckey)
		to_chat(oldmob, "<span class='notice'>This alien looks smart enough</span>")
		return
	if(!isobserver(oldmob))
		return

	var/mob/dead/observer/O = oldmob
	if(O.timeofdeath < world.time + 300 SECONDS)
		to_chat(O, "<span class='warning'>This alien deny you entrance!</span>")
		return

	message_admins("[key_name(oldmob)] entering [src]...")
	src.ckey = oldmob.ckey
	oldmob.ckey = null
	src.client.change_view(world.view)
	if(leader)
		leader:bot_followers--
		leader = null
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 8
	sight |= SEE_MOBS
	visible_message("<span class='xenonotice'>This lesser starts look weird...</span>", "<span class='xenonotice'>Supposed intelligence filling your little spinal cord!</span>")
	cdel(oldmob)

/mob/living/simple_animal/alien/IgniteMob()			//Crowd control!
	health = -maxHealth
	death(0)

/mob/living/simple_animal/alien/ex_act(severity)
	switch(severity)
		if(1)
			health = -maxHealth
			death(1)
		if(2, 3)
			health = -maxHealth
			death(0)

/mob/living/simple_animal/alien/bullet_act(obj/item/projectile/Proj)
	if(!Proj || Proj.damage <= 0)
		return 0

	if(Proj.ammo.flags_ammo_behavior & AMMO_BALLISTIC)
		round_statistics.total_bullet_hits_on_xenos++

	if(Proj.ammo.flags_ammo_behavior & AMMO_INCENDIARY)
		visible_message("<span class='xenodanger'>[src] bursts into flames!</span>","", null, 5)
		IgniteMob()
		return 1

	adjustBruteLoss(Proj.damage)

	Proj.play_damage_effect(src)
	if(health <= 0)
		death(0)
	return 1

/mob/living/simple_animal/alien/drone
	name = "alien lesser drone"
	desc = "A hardy worker, who can be beaten by child born on landmine."
	icon_state = "Drone Running"
	icon_living = "Drone Running"
	icon_dead = "Drone Dead"
	maxHealth = 70
	health = 70
	attack_speed = 15
	melee_damage_lower = 5
	melee_damage_upper = 15
	move_to_delay = 2
	speed = 1
	var/max_enemies = 5								//Will run from 5 enemies

// Still using old projectile code - commenting this out for now
// /mob/living/simple_animal/alien//alien/sentinel
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

/mob/living/simple_animal/alien/ravager
	name = "alien tearer"
	desc = "A vile creature, Tearer can shred any foe and survive under heavy fire."
	icon = 'icons/Xeno/2x2_Xenos.dmi'
	icon_state = "Ravager Running"
	icon_living = "Ravager Running"
	icon_dead = "Ravager Dead"
	attack_speed = 7
	speed = 0.7
	melee_damage_lower = 35
	melee_damage_upper = 45
	maxHealth = 400
	health = 400

	pixel_x = -16
	old_x = -16

	var/rage = 0								//The more you hit with bullets, meanier it would be
	var/maxrage = 3

/mob/living/simple_animal/alien/ravager/bullet_act(obj/item/projectile/Proj)
	. = ..()

	if(rage < maxrage)
		if(prob(rage*10))
			visible_message("<span class='xenodanger'>[src] becomes enraged!</span>","", null, 5)
		rage++
		melee_damage_upper += 5*rage
		melee_damage_lower += 5

/mob/living/simple_animal/alien/ravager/IgniteMob()			//May whatever God you worship have mercy on you, tearer will have none
	visible_message("<span class='xenodanger'>[src] roars in rage!</span>","", null, 5)
	for(var/enrage_level in rage+1 to (maxrage+3))
		rage++
		melee_damage_upper += 5*rage
		melee_damage_lower += 5

/obj/item/projectile/neurotox
	damage = 30
	icon_state = "toxin"


/mob/living/simple_animal/alien/leader
	name = "alien alpha trooper"
	desc = "An oversized alien trooper, that have enough cranial capacity to lead its sisters into battle."
	icon = 'icons/Xeno/2x2_Xenos.dmi'
	icon_state = "Warrior Running"
	icon_living = "Warrior Running"
	icon_dead = "Warrior Dead"
	maxHealth = 200
	health = 200
	melee_damage_lower = 25
	melee_damage_upper = 35
	move_to_delay = 2

	var/bot_followers = 0
	var/bot_max = 5
	var/deflect_chance = 25			//He is an alpha for some goddamn reasons

/mob/living/simple_animal/alien/leader/bullet_act(obj/item/projectile/Proj)
	if(prob(deflect_chance))
		visible_message("<span class='avoidharm'>[src] easily deflects bullet!</span>","", null, 5)
		return 1
	return ..()