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
	var/last_use
	var/cooldown = 300
	var/enemy_count = 0

/datum/action/xeno_action/reap/action_activate()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	if(!X.check_state())
		return
	if(world.time < last_use + cooldown)
		to_chat(X, "<span class='xenowarning'>You are too exhausted to hate again! Try after [world.time - (last_use + cooldown)]</span>")
		return

/datum/action/xeno_action/enrage
	name = "Carnage (100)"
	plasma_cost = 100
	var/last_use
	var/cooldown = 600
	var/enemy_count = 0
	action_icon_state = "carnage"

/datum/action/xeno_action/enrage/action_activate()
	var/mob/living/carbon/Xenomorph/Ravager/X = owner
	if(!X.check_state())
		return
	if(world.time < last_use + cooldown)
		to_chat(X, "<span class='xenowarning'>You are too exhausted to hate again! Try after [((last_use + cooldown) - world.time)]</span>")
		return

	last_use = world.time
	for(var/mob/living/carbon/human/H in view(7))
		if(H.stat != DEAD)
			enemy_count++
		if(enemy_count >= 5)
			break
	world << "health is [X.health]"
	X.health += min(enemy_count * BUFF_PER_ENEMY, X.maxHealth)
	X.speed -= enemy_count/5
	X.visible_message("<span class='danger'>[X] wounds healed in the blink of an eye!</span>", "<span class='xenodanger'>Your muscles flex!</span>")
	world << "health is [X.health]"

	spawn(last_use + 60)
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