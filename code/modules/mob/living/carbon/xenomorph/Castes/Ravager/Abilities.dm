//Ravager Abilities
#define BUFF_PER_ENEMY 15

/datum/action/xeno_action/activable/charge
	name = "Charge (20)"
	action_icon_state = "charge"
	ability_name = "charge"

/datum/action/xeno_action/activable/charge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	X.charge(A)

/datum/action/xeno_action/activable/charge/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	return !X.usedPounce

/datum/action/xeno_action/reap
	name = "Reap (50)"
	plasma_cost = 50
	action_icon_state = "reap"
	var/can_use = 1
	var/cooldown = 300

/datum/action/xeno_action/reap/can_use_action()
	if(!can_use)
		return 0
	else
		. = ..()

/datum/action/xeno_action/reap/action_activate()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	if(!X.check_state())
		return
	if(!can_use || !X.check_plasma(plasma_cost))
		to_chat(X, "<span class='xenowarning'>You are too exhausted to hate again!</span>")
		return

	X.use_plasma(plasma_cost)

	can_use = 0
	spawn(cooldown)
		can_use = 1

	X.visible_message("<span class='danger'>[X] roared in rage!</span>", "<span class='xenodanger'>You flailing your scythes around!</span>")
	for(var/mob/living/carbon/human/H in range(1))
		H.attack_alien(X, rand(15, 25))

/datum/action/xeno_action/enrage
	name = "Carnage (100)"
	plasma_cost = 100
	var/can_use = 1
	var/cooldown = 600
	var/enemy_count = 0
	action_icon_state = "carnage"

/datum/action/xeno_action/enrage/can_use_action()
	if(!can_use)
		return 0
	else
		. = ..()

/datum/action/xeno_action/enrage/action_activate()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	if(!X.check_state())
		return
	if(!can_use || !X.check_plasma(plasma_cost))
		to_chat(X, "<span class='xenowarning'>You are too exhausted to hate again!</span>")
		return

	X.use_plasma(plasma_cost)

	for(var/mob/living/carbon/human/H in view(7))
		if(H.stat != DEAD)
			enemy_count++
		if(enemy_count >= 5)
			break
	X.health += min(enemy_count * BUFF_PER_ENEMY, X.maxHealth)
	X.speed -= enemy_count/5
	X.visible_message("<span class='danger'>[X] wounds healed in the blink of an eye!</span>", "<span class='xenodanger'>Your muscles flex!</span>")

	can_use = 0
	spawn(cooldown)
		can_use = 1

	spawn(20)
		X.speed += enemy_count/5
		to_chat(X, "<span class='xenonotice'>Your muscles relaxed...</span>")
		enemy_count = 0

//Ravenger

/datum/action/xeno_action/activable/breathe_fire
	name = "Breathe Fire"
	action_icon_state = "breathe_fire"
	ability_name = "breathe fire"

/datum/action/xeno_action/activable/breathe_fire/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Ravager/ravenger/X = owner
	X.breathe_fire(A)

/datum/action/xeno_action/activable/breathe_fire/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Ravager/ravenger/X = owner
	if(world.time > X.used_fire_breath + 75) return TRUE

#undef BUFF_PER_ENEMY