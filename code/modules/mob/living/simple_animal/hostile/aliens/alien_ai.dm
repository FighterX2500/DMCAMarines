/////////////////////////////
//A special AI for xenobots//
/////////////////////////////

/*
#define HOSTILE_STANCE_IDLE 1
#define HOSTILE_STANCE_ALERT 2
#define HOSTILE_STANCE_ATTACK 3
#define HOSTILE_STANCE_ATTACKING 4
#define HOSTILE_STANCE_TIRED 5
*/

#define HOSTILE_STANCE_AWAY 6
#define HOSTILE_STANCE_GUARD 7
#define HOSTILE_STANCE_FOLLOW 8

//Common procs
/mob/living/simple_animal/alien/Life()				//I deserve to burn in hell@polion1232
	. = ..()

	if(!.)
		walk(src, 0)
		return 0

	var/obj/effect/alien/weeds/W = locate() in src.loc
	if(W != null && stat != DEAD)
		health = min(maxHealth, health+5)

	if(client)
		return 0

	if(!stat)
		handle_bot_alien_behavior()

	return 1

/mob/living/simple_animal/alien/proc/FindTarget()

	var/atom/T = null
	stop_automated_movement = 0
	for(var/atom/A in ListTargets(10))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if (istype(src, /mob/living/simple_animal/alien) && (isrobot(L)))
				continue
			else if(isXeno(L))
				if(leader || stance == HOSTILE_STANCE_ATTACK || stance == HOSTILE_STANCE_ATTACKING)
					continue
				var/mob/living/carbon/Xenomorph/X = L
				if(X.queen_chosen_lead)
					if(X.bot_followers >= X.tier + X.upgrade)
						continue
					leader = X
					leader.bot_followers++
					stance = HOSTILE_STANCE_FOLLOW
					continue
			else
				if(!L.stat)
					stance = HOSTILE_STANCE_ATTACK
					T = L
					if(leader)
						leader.bot_followers--
						leader = null
					break
	return T


/mob/living/simple_animal/alien/proc/Found(var/atom/A)
	return

/mob/living/simple_animal/alien/proc/MoveToTarget()
	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob in ListTargets(10))
		stance = HOSTILE_STANCE_ATTACKING
		walk_to(src, target_mob, 1, move_to_delay)
	else
		LoseTarget()

/mob/living/simple_animal/alien/proc/AttackTarget()

	stop_automated_movement = 1
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in ListTargets(10)))
		LostTarget()
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		return 1

/mob/living/simple_animal/alien/proc/AttackingTarget()
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_animal(src)
		return L

/mob/living/simple_animal/alien/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)

/mob/living/simple_animal/alien/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)


/mob/living/simple_animal/alien/proc/ListTargets(var/dist = 7)
	var/list/L = hearers(src, dist)
	return L

/mob/living/simple_animal/alien/proc/handle_bot_alien_behavior()
	switch(stance)
		if(HOSTILE_STANCE_IDLE, HOSTILE_STANCE_AWAY)
			target_mob = FindTarget()

		if(HOSTILE_STANCE_ATTACK)
			if(destroy_surroundings)
				DestroySurroundings()
			MoveToTarget()

		if(HOSTILE_STANCE_ATTACKING)
			if(destroy_surroundings)
				DestroySurroundings()
			AttackTarget()

		if(HOSTILE_STANCE_FOLLOW)
			handle_follow()

	return

/mob/living/simple_animal/alien/proc/handle_follow()
	target_mob = FindTarget()
	if(target_mob)
		return

	if(!leader)
		stance = HOSTILE_STANCE_IDLE
		return

	if(!(leader in ListTargets(10)))
		leader.bot_followers--
		leader = null
		stance = HOSTILE_STANCE_IDLE
		return

	if(get_dist(src, leader) > 5)					//Too close
		walk_to(src, leader, 2, move_to_delay+2)

/mob/living/simple_animal/alien/proc/DestroySurroundings()
	if(prob(break_stuff_probability))
		for(var/dir in cardinal) // North, South, East, West
			for(var/obj/structure/window/obstacle in get_step(src, dir))
				if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_animal(src)
					return
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille) || istype(obstacle, /obj/structure/barricade))
				obstacle.attack_animal(src)

/mob/living/simple_animal/alien/death(gibbed, deathmessage = "lets out a waning guttural screech, green blood bubbling from its maw.")
	. = ..()
	if(!.) return //If they were already dead, it will return.
	if(leader)
		leader.bot_followers--
		leader = null
	playsound(src, 'sound/voice/alien_death.ogg', 50, 1)

// Drone things

/mob/living/simple_animal/alien/drone/handle_bot_alien_behavior()
	var/obj/effect/alien/weeds/W = locate() in range(4, loc)
	var/obj/effect/alien/weeds/node/N = locate() in range(6, loc)
	if(!W || !N)
		var/turf/T = src.loc
		if(!istype(T) || !T.is_weedable())
			return

		new /obj/effect/alien/weeds/node(src.loc, src, null)
		playsound(src.loc, "alien_resin_build", 25)

	return ..()

/mob/living/simple_animal/alien/drone/FindTarget()
	var/list/enemies = new/list()
	for(var/atom/A in ListTargets(7))
		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if (istype(src, /mob/living/simple_animal/alien) && (isrobot(L)))
				continue
			else if(isXeno(L))
				return ..()
			else
				enemies+=L
	if(enemies.len > max_enemies)
		stance = HOSTILE_STANCE_AWAY
		target_mob = null
		walk_away(src, pick(ListTargets(7)), 7, move_to_delay)
		return null
	else
		return ..()

/mob/living/simple_animal/alien/drone/MoveToTarget()
	var/list/enemies = new/list()
	for(var/atom/A in ListTargets(7))
		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if (istype(src, /mob/living/simple_animal/alien) && (isrobot(L)))
				continue
			else if(isXeno(L))
				return ..()
			else
				enemies+=L
	if(enemies.len > max_enemies)
		stance = HOSTILE_STANCE_AWAY
		target_mob = null
		walk_away(src, pick(ListTargets(7)), 7, move_to_delay)
		return null
	else
		return ..()

/mob/living/simple_animal/alien/drone/AttackTarget()
	var/list/enemies = new/list()
	for(var/atom/A in ListTargets(7))
		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else if (istype(src, /mob/living/simple_animal/alien) && (isrobot(L)))
				continue
			else if(isXeno(L))
				return ..()
			else
				enemies+=L
	if(enemies.len > max_enemies)
		stance = HOSTILE_STANCE_AWAY
		target_mob = null
		walk_away(src, pick(ListTargets(7)), 7, move_to_delay)
		return 0
	else
		return ..()

// Tearer things

/mob/living/simple_animal/alien/ravager/handle_bot_alien_behavior()
	. = ..()

	if(rage > 0)
		melee_damage_upper -= 5*rage
		melee_damage_lower -= 5
		rage--