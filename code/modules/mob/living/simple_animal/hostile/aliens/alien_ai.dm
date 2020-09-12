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
/mob/living/simple_animal/alien/say(var/message)
	return

/mob/living/simple_animal/alien/whisper()
	return

/mob/living/simple_animal/alien/emote()
	return

/mob/living/simple_animal/alien/start_pulling(atom/movable/AM, lunge, no_msg)
	return

/mob/living/simple_animal/alien/Life()				//I deserve to burn in hell@polion1232
	. = ..()

	if(!.)
		walk(src, 0)
		if(timeofdeath >= 5 MINUTES)
			visible_message("<span class='xenowarning'>[src]'s body sizzle a little and fall apart!</span>", "")
			cdel(src)
		return 0

	var/obj/effect/alien/weeds/W = locate() in src.loc
	if(W != null && stat != DEAD)
		health = min(maxHealth, health+5)

	handle_special_behavior()

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

		if(isMech(A))
			var/obj/vehicle/walker/W = A
			stance = HOSTILE_STANCE_ATTACK
			T = W
			continue					//Too hard of a target. Will attack if no other options present

		if(isTank(A))
			var/obj/vehicle/multitile/hitbox/cm_armored/Tank = A
			if(Tank.root.health == 0)
				continue
			stance = HOSTILE_STANCE_ATTACK
			T = Tank
			continue					//Too hard of a target. Will attack if no other options present

		if(isliving(A))
			var/mob/living/L = A
			if(A.alpha <  125)
				continue
			if(L in friends)
				continue
			else if (isrobot(L))
				continue
			else if(ismonkey(L))
				continue
			else if(isXenoBot(L))
				if(L.stat)
					continue
				if(istype(src, /mob/living/simple_animal/alien/leader))
					continue
				else if(leader)
					continue
				else if(!istype(L, /mob/living/simple_animal/alien/leader))
					continue
				else
					var/mob/living/simple_animal/alien/leader/lead = L
					if(lead.bot_followers < lead.bot_max)
						leader = lead
						lead.bot_followers++
						stance = HOSTILE_STANCE_FOLLOW
					continue
			else if(isXeno(L))
				if(L.stat)
					continue
				if(leader)
					if(isXenoBot(leader))
						continue
					else
						if(isXeno(leader))
							var/mob/living/carbon/Xenomorph/X = leader
							if(X.call_lesser)
								continue
							stance = HOSTILE_STANCE_IDLE
							X.bot_followers--
							leader = null
							walk(src,0)
							X = L
							if(X.call_lesser)
								if(X.bot_followers >= X.tier + X.upgrade)
									continue
								leader = X
								X.bot_followers++
								stance = HOSTILE_STANCE_FOLLOW
								continue
				if(stance == HOSTILE_STANCE_ATTACK || stance == HOSTILE_STANCE_ATTACKING)
					continue
				var/mob/living/carbon/Xenomorph/X = L
				if(X.call_lesser)
					if(X.bot_followers >= X.tier + X.upgrade)
						continue
					leader = X
					X.bot_followers++
					stance = HOSTILE_STANCE_FOLLOW
					continue
			else if(isSynth(L))
				continue
			else
				if(!L.stat)
					var/obj/item/alien_embryo/embryo = locate() in L
					if(embryo)
						continue
					stance = HOSTILE_STANCE_ATTACK
					T = L
					if(leader)
						if(isXeno(leader))
							var/mob/living/carbon/Xenomorph/X = leader
							X.bot_followers--
							leader = null
						if(isXenoBot(leader))
							var/mob/living/simple_animal/alien/leader/b = leader
							b.bot_followers--
							leader = null
					break
	return T


/mob/living/simple_animal/alien/proc/Found(var/atom/A)
	return

/mob/living/simple_animal/alien/proc/MoveToTarget()
	stop_automated_movement = 1
	if(!target || SA_attackable(target))
		stance = HOSTILE_STANCE_IDLE
	if(target in ListTargets(10))
		stance = HOSTILE_STANCE_ATTACKING
		walk_to(src, target, 1, move_to_delay)
	else
		LoseTarget()

/mob/living/simple_animal/alien/proc/AttackTarget()
	stop_automated_movement = 1
	if(!target || SA_attackable(target))
		LoseTarget()
		return 0
	if(!(target in ListTargets(10)))
		LostTarget()
		return 0
	if(isTank(target))
		var/obj/vehicle/multitile/hitbox/cm_armored/TNK = target
		if(TNK.root.health == 0)
			LoseTarget()
			return 0
	if(get_dist(src, target) <= 1)	//Attacking
		makeStatement()
		AttackingTarget()
		return 1

/mob/living/simple_animal/alien/proc/AttackingTarget()
	if(!Adjacent(target))
		return
	if(isliving(target))
		var/mob/living/L = target
		L.attack_animal(src)
		animation_attack_on(L)
		return L
	if(isMech(target))
		var/obj/vehicle/walker/W = target
		W.attack_animal(src)
		animation_attack_on(W)
		return W
	if(isTank(target))
		var/obj/vehicle/multitile/hitbox/cm_armored/TNK = target
		TNK.attack_animal(src)
		animation_attack_on(TNK)
		return TNK

/mob/living/simple_animal/alien/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target = null
	walk(src, 0)

/mob/living/simple_animal/alien/proc/LostTarget()
	stance = HOSTILE_STANCE_IDLE
	walk(src, 0)

/mob/living/simple_animal/alien/proc/makeStatement()
	if(statement >= world.time + 25 SECONDS || !(xeno_number > 0 && xeno_number <= hive_datum.len))
		return
	statement = world.time
	var/msg = pick("FOR THE HIVE!", "ATTACK!", "WE HAVE NO FEAR!", "NO RETREAT!", "PREY!")
	var/datum/hive_status/hive = hive_datum[xeno_number]
	if(!hive.living_xeno_queen)
		return

	var/rendered = "<i><span class='game say'>Hivemind, <span class='name'>[name]</span> <span class='message'> hisses, '[msg]'</span></span></i>"
	for (var/mob/S in player_list)
		if(!isnull(S) && (isXeno(S) || S.stat == DEAD) && !istype(S,/mob/new_player))
			if(istype(S,/mob/dead/observer))
				if(S.client.prefs && S.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
					var/track = "(<a href='byond://?src=\ref[S];track=\ref[src]'>follow</a>)"
					var/ghostrend = "<i><span class='game say'>Hivemind, <span class='name'>[name]</span> [track]<span class='message'> hisses, '[msg]'</span></span></i>"
					S.show_message(ghostrend, 2)
			else if(xeno_number == xeno_hivenumber(S))
				S.show_message(rendered, 2)


/mob/living/simple_animal/alien/proc/ListTargets(var/dist = 7)
	var/list/L = hearers(src, dist)
	var/obj/vehicle/walker/V = locate(/obj/vehicle/walker) in view(dist, src)
	var/obj/vehicle/multitile/root/cm_armored/TNK = locate(/obj/vehicle/multitile/root/cm_armored) in view(dist, src)
	if(V)
		L += V
	if(TNK)
		for(var/targ in TNK.linked_objs)
			if(isTank(TNK.linked_objs[targ]))
				L += TNK.linked_objs[targ]
				break
	return L

/mob/living/simple_animal/alien/proc/handle_bot_alien_behavior()
	switch(stance)
		if(HOSTILE_STANCE_IDLE, HOSTILE_STANCE_AWAY)
			target = FindTarget()

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

/mob/living/simple_animal/alien/proc/handle_special_behavior()
	return

/mob/living/simple_animal/alien/proc/handle_follow()
	target = FindTarget()
	if(target)
		return

	if(!leader)
		stance = HOSTILE_STANCE_IDLE
		return

	if(leader.stat == DEAD)
		stance = HOSTILE_STANCE_IDLE
		return

	if(!(leader in ListTargets(10)))
		if(isXeno(leader))
			var/mob/living/carbon/Xenomorph/X = leader
			X.bot_followers--
			leader = null
			stance = HOSTILE_STANCE_IDLE
			return
		if(isXenoBot(leader))
			var/mob/living/simple_animal/alien/leader/b = leader
			b.bot_followers--
			leader = null
			stance = HOSTILE_STANCE_IDLE
			return

	if(get_dist(src, leader) > 5)					//Too close
		walk_to(src, leader, 2, move_to_delay+2)
	else
		walk(src, 0)

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
	walk(src, 0)
	stat = DEAD
	if(xeno_number > 0 && xeno_number <= hive_datum.len)
		hive_datum[xeno_number].xeno_lessers_list -= src
	if(leader)
		if(isXeno(leader))
			var/mob/living/carbon/Xenomorph/X = leader
			X.bot_followers--
			leader = null
		else
			var/mob/living/simple_animal/alien/leader/lead = leader
			lead.bot_followers--
			leader = null
	playsound(src, 'sound/voice/alien_death.ogg', 50, 1)
	return 1

/mob/living/simple_animal/alien/spawn_gibs()
	xgibs(loc, null, null)

// Drone things

/mob/living/simple_animal/alien/drone/handle_special_behavior()
	var/obj/effect/alien/weeds/W = locate() in range(4, loc)
	var/obj/effect/alien/weeds/node/N = locate() in range(6, loc)
	if(!W || !N)
		var/turf/T = src.loc
		if(!istype(T) || !T.is_weedable())
			return

		new /obj/effect/alien/weeds/node(src.loc, src, null)
		playsound(src.loc, "alien_resin_build", 25)

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
		target = null
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
		target = null
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
		target = null
		walk_away(src, pick(ListTargets(7)), 7, move_to_delay)
		return 0
	else
		return ..()

// Tearer things

/mob/living/simple_animal/alien/ravager/handle_special_behavior()
	if(prob(50))
		return

	if(rage > 0)
		melee_damage_upper -= 5*rage
		melee_damage_lower -= 5
		rage--
	if(rage >= maxrage)
		if(health < maxHealth)
			health += min(25, 5*rage)

// Alpha things

/mob/living/simple_animal/alien/leader/AttackingTarget()
	if(!Adjacent(target))
		return
	if(isliving(target))
		var/mob/living/L = target
		if(prob(10))
			tail_sweep(target)
		else
			L.attack_animal(src)
		return L

/mob/living/simple_animal/alien/leader/proc/tail_sweep(var/mob/living/enemy)
	round_statistics.defender_tail_sweeps++
	visible_message("<span class='xenowarning'>\The [src] sweeps it's tail in a wide circle!</span>", \
	"")

	spin_circle()

	if(ishuman(enemy))
		var/mob/living/carbon/human/HE = enemy
		HE.apply_damage(5)
		HE.KnockDown(2, 1)
		to_chat(HE, "<span class='xenowarning'>You are struck by \the [src]'s tail sweep!</span>")
		playsound(HE,'sound/weapons/alien_claw_block.ogg', 50, 1)

// Suicider Things

/mob/living/simple_animal/alien/explosive/death(gibbed, deathmessage = "lets out a waning guttural screech, green blood bubbling from its maw.")
	. = ..()
	if(!.)
		return

	explode(get_turf(src))
	if(!gibbed)
		spawn_gibs()
		cdel(src)

/mob/living/simple_animal/alien/explosive/AttackingTarget()
	if(!Adjacent(target))
		return
	gib()

/mob/living/simple_animal/alien/explosive/proc/explode(turf/T)
	var/damage = 100				//He is a hellova bang

	visible_message("<span class='danger'>[src] begins to bulge grotesquely, and explodes in a cloud of corrosive gas!</span>")
	smoke.set_up(2, 0, get_turf(src))
	smoke.start()

	for(var/atom/movable/AM in oview(4, T))
		if(isXeno(AM) || isXenoBot(AM))
			continue

		var/actualDamage = damage/(get_dist(AM,src))

		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			H.take_limb_damage(0, actualDamage)
			to_chat(H, "<span class='danger'>You've been hit by acid splash!</span>")
			continue

		var/obj/vehicle/V = locate(/obj/vehicle) in src.loc
		if(V)
			if(istype(V,/obj/vehicle/multitile/root/cm_armored))
				var/obj/vehicle/multitile/root/cm_armored/Tank = V
				Tank.take_damage_type(actualDamage, "acid")
			if(isMech(V))
				var/obj/vehicle/walker/W = V
				W.take_damage(actualDamage, "acid")
			continue