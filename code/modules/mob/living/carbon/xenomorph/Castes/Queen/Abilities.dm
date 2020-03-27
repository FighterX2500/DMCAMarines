//Queen Abilities

/datum/action/xeno_action/grow_ovipositor
	name = "Grow Ovipositor (700)"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 700

/datum/action/xeno_action/grow_ovipositor/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	var/turf/current_turf = get_turf(X)
	if(!current_turf || !istype(current_turf))
		return

	if(X.ovipositor_cooldown > world.time)
		to_chat(X, "<span class='xenowarning'>You're still recovering from detaching your old ovipositor. Wait [round((X.ovipositor_cooldown-world.time)*0.1)] seconds</span>")
		return

	var/obj/effect/alien/weeds/alien_weeds = locate() in current_turf

	if(!alien_weeds)
		to_chat(X, "<span class='xenowarning'>You need to be on resin to grow an ovipositor.</span>")
		return

	if(!X.check_alien_construction(current_turf))
		return

	if(X.action_busy)
		return

	if(X.check_plasma(plasma_cost))
		X.visible_message("<span class='xenowarning'>\The [X] starts to grow an ovipositor.</span>", \
		"<span class='xenowarning'>You start to grow an ovipositor...(takes 20 seconds, hold still)</span>")
		if(!do_after(X, 200, TRUE, 20, BUSY_ICON_FRIENDLY) && X.check_plasma(plasma_cost))
			return
		if(!X.check_state()) return
		if(!locate(/obj/effect/alien/weeds) in current_turf)
			return

		X.use_plasma(plasma_cost)
		X.visible_message("<span class='xenowarning'>\The [X] has grown an ovipositor!</span>", \
		"<span class='xenowarning'>You have grown an ovipositor!</span>")
		X.mount_ovipositor()

/datum/action/xeno_action/remove_eggsac
	name = "Remove Eggsac"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 0

/datum/action/xeno_action/remove_eggsac/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return

	if(X.action_busy) return
	var/answer = alert(X, "Are you sure you want to remove your ovipositor? (5min cooldown to grow a new one)", , "Yes", "No")
	if(answer != "Yes")
		return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.visible_message("<span class='xenowarning'>\The [X] starts detaching itself from its ovipositor!</span>", \
		"<span class='xenowarning'>You start detaching yourself from your ovipositor.</span>")
	if(!do_after(X, 50, FALSE, 10, BUSY_ICON_HOSTILE)) return
	if(!X.check_state())
		return
	if(!X.ovipositor)
		return
	X.dismount_ovipositor()

/datum/action/xeno_action/activable/screech
	name = "Screech (250)"
	action_icon_state = "screech"
	ability_name = "screech"

/datum/action/xeno_action/activable/screech/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	return !X.has_screeched

/datum/action/xeno_action/activable/screech/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	X.queen_screech()

/datum/action/xeno_action/activable/gut
	name = "Gut (200)"
	action_icon_state = "gut"
	ability_name = "gut"

/datum/action/xeno_action/activable/gut/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	X.queen_gut(A)

/datum/action/xeno_action/psychic_whisper
	name = "Psychic Whisper"
	action_icon_state = "psychic_whisper"
	plasma_cost = 0

/datum/action/xeno_action/psychic_whisper/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	var/list/target_list = list()
	for(var/mob/living/possible_target in view(7, X))
		if(possible_target == X || !possible_target.client) continue
		target_list += possible_target

	var/mob/living/M = input("Target", "Send a Psychic Whisper to whom?") as null|anything in target_list
	if(!M) return

	if(!X.check_state())
		return

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_directed_talk(X, M, msg, LOG_SAY, "psychic whisper")
		to_chat(M, "<span class='alien'>You hear a strange, alien voice in your head. \italic \"[msg]\"</span>")
		to_chat(X, "<span class='xenonotice'>You said: \"[msg]\" to [M]</span>")

/datum/action/xeno_action/watch_xeno
	name = "Watch Xenomorph"
	action_icon_state = "watch_xeno"
	plasma_cost = 0

/datum/action/xeno_action/watch_xeno/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	var/list/possible_xenos = list()
	for(var/mob/living/carbon/Xenomorph/T in living_mob_list)
		if(T.z != ADMIN_Z_LEVEL && T.caste != "Queen" && X.hivenumber == T.hivenumber)
			possible_xenos += T

	var/mob/living/carbon/Xenomorph/selected_xeno = input(X, "Target", "Watch which xenomorph?") as null|anything in possible_xenos
	if(!selected_xeno || selected_xeno.disposed || selected_xeno == X.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z == ADMIN_Z_LEVEL || !X.check_state())
		if(X.observed_xeno)
			X.set_queen_overwatch(X.observed_xeno, TRUE)
	else
		X.set_queen_overwatch(selected_xeno)

/datum/action/xeno_action/toggle_queen_zoom
	name = "Toggle Queen Zoom"
	action_icon_state = "toggle_queen_zoom"
	plasma_cost = 0

/datum/action/xeno_action/toggle_queen_zoom/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.is_zoomed)
		X.zoom_out()
	else
		X.zoom_in(0, 12)

/datum/action/xeno_action/set_xeno_lead
	name = "Choose/Follow Xenomorph Leaders"
	action_icon_state = "xeno_lead"
	plasma_cost = 0

/datum/action/xeno_action/set_xeno_lead/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	var/datum/hive_status/hive
	if(X.hivenumber && X.hivenumber <= hive_datum.len)
		hive = hive_datum[X.hivenumber]
	else
		return
	if(X.observed_xeno)
		if(X.queen_ability_cooldown > world.time)
			to_chat(X, "<span class='xenowarning'>You're still recovering from your last overwatch ability. Wait [round((X.queen_ability_cooldown-world.time)*0.1)] seconds.</span>")
			return
		if(X.queen_leader_limit <= hive.xeno_leader_list.len && !X.observed_xeno.queen_chosen_lead)
			to_chat(X, "<span class='xenowarning'>You currently have [hive.xeno_leader_list.len] promoted leaders. You may not maintain additional leaders until your power grows.</span>")
			return
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno
		T.queen_chosen_lead = !T.queen_chosen_lead
		T.hud_set_queen_overwatch()
		X.queen_ability_cooldown = world.time + 150 //15 seconds
		if(T.queen_chosen_lead)
			to_chat(X, "<span class='xenonotice'>You've selected [T] as a Hive Leader.</span>")
			to_chat(T, "<span class='xenoannounce'>[X] has selected you as a Hive Leader. The other Xenomorphs must listen to you. You will also act as a beacon for the Queen's pheromones.</span>")
			hive.xeno_leader_list += T
		else
			to_chat(X, "<span class='xenonotice'>You've demoted [T] from Lead.</span>")
			to_chat(T, "<span class='xenoannounce'>[X] has demoted you from Hive Leader. Your leadership rights and abilities have waned.</span>")
			hive.xeno_leader_list -= T
		T.handle_xeno_leader_pheromones(X)
	else
		var/list/possible_xenos = list()
		for(var/mob/living/carbon/Xenomorph/T in hive.xeno_leader_list)
			possible_xenos += T

		if(possible_xenos.len > 1)
			var/mob/living/carbon/Xenomorph/selected_xeno = input(X, "Target", "Watch which xenomorph leader?") as null|anything in possible_xenos
			if(!selected_xeno || !selected_xeno.queen_chosen_lead || selected_xeno == X.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z != X.z || !X.check_state())
				return
			X.set_queen_overwatch(selected_xeno)
		else if(possible_xenos.len)
			X.set_queen_overwatch(possible_xenos[1])
		else
			to_chat(X, "<span class='xenowarning'>There are no Xenomorph leaders. Overwatch a Xenomorph to make it a leader.</span>")

/datum/action/xeno_action/queen_heal
	name = "Heal Xenomorph (600)"
	action_icon_state = "heal_xeno"
	plasma_cost = 600

/datum/action/xeno_action/queen_heal/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.queen_ability_cooldown > world.time)
		to_chat(X, "<span class='xenowarning'>You're still recovering from your last overwatch ability. Wait [round((X.queen_ability_cooldown-world.time)*0.1)] seconds.</span>")
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/target = X.observed_xeno
		if(X.loc.z != target.loc.z)
			to_chat(X, "<span class='xenowarning'>They are too far away to do this.</span>")
			return
		if(target.stat != DEAD)
			if(target.health < target.maxHealth)
				if(X.check_plasma(600))
					X.use_plasma(600)
					target.adjustBruteLoss(-50)
					X.queen_ability_cooldown = world.time + 150 //15 seconds
					to_chat(X, "<span class='xenonotice'>You channel your plasma to heal [target]'s wounds.</span>")
			else

				to_chat(X, "<span class='warning'>[target] is at full health.</span>")
	else
		to_chat(X, "<span class='warning'>You must overwatch the xeno you want to give healing to.</span>")

/datum/action/xeno_action/queen_give_plasma
	name = "Give Plasma (600)"
	action_icon_state = "queen_give_plasma"
	plasma_cost = 600

/datum/action/xeno_action/queen_give_plasma/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.queen_ability_cooldown > world.time)
		to_chat(X, "<span class='xenowarning'>You're still recovering from your last overwatch ability. Wait [round((X.queen_ability_cooldown-world.time)*0.1)] seconds.</span>")
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/target = X.observed_xeno
		if(target.stat != DEAD)
			if(target.plasma_stored < target.plasma_max)
				if(X.check_plasma(600))
					X.use_plasma(600)
					target.gain_plasma(100)
					X.queen_ability_cooldown = world.time + 150 //15 seconds
					to_chat(X, "<span class='xenonotice'>You transfer some plasma to [target].</span>")

			else

				to_chat(X, "<span class='warning'>[target] is at full plasma.</span>")
	else
		to_chat(X, "<span class='warning'>You must overwatch the xeno you want to give plasma to.</span>")

/datum/action/xeno_action/queen_order
	name = "Give Order (100)"
	action_icon_state = "queen_order"
	plasma_cost = 100

/datum/action/xeno_action/queen_order/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/target = X.observed_xeno
		if(target.stat != DEAD && target.client)
			if(X.check_plasma(100))
				var/input = stripped_input(X, "This message will be sent to the overwatched xeno.", "Queen Order", "")
				if(!input)
					return
				var/queen_order = "<span class='xenoannounce'><b>[X]</b> reaches you:\"[input]\"</span>"
				if(!X.check_state() || !X.check_plasma(100) || X.observed_xeno != target || target.stat == DEAD)
					return
				if(target.client)
					X.use_plasma(100)
					to_chat(target, "[queen_order]")
					log_admin("[queen_order]")
					message_admins("[key_name_admin(X)] has given the following Queen order to [target]: \"[input]\"", 1)

	else
		to_chat(X, "<span class='warning'>You must overwatch the Xenomorph you want to give orders to.</span>")

/datum/action/xeno_action/deevolve
	name = "De-Evolve a Xenomorph"
	action_icon_state = "xeno_deevolve"
	plasma_cost = 600

/datum/action/xeno_action/deevolve/action_activate()
	var/mob/living/carbon/Xenomorph/Queen/X = owner
	if(!X.check_state())
		return
	if(X.observed_xeno)
		var/mob/living/carbon/Xenomorph/T = X.observed_xeno
		if(!X.check_plasma(600)) return

		if(T.is_ventcrawling)
			to_chat(X, "<span class='warning'>[T] can't be deevolved here.</span>")
			return

		if(!isturf(T.loc))
			to_chat(X, "<span class='warning'>[T] can't be deevolved here.</span>")
			return

		if(T.health <= 0)
			to_chat(X, "<span class='warning'>[T] is too weak to be deevolved.</span>")
			return

		var/newcaste = ""

		switch(T.caste)
			if("Hivelord")
				newcaste = "Drone"
			if("Carrier")
				newcaste = "Drone"
			if("Crusher")
				newcaste = "Warrior"
			if("Ravager")
				newcaste = "Lurker"
			if("Praetorian")
				newcaste = "Warrior"
			if("Boiler")
				newcaste = "Spitter"
			if("Spitter")
				newcaste = "Sentinel"
			if("Lurker")
				newcaste = "Runner"
			if("Warrior")
				newcaste = "Defender"

		if(!newcaste)
			to_chat(X, "<span class='xenowarning'>[T] can't be deevolved.</span>")
			return

		var/confirm = alert(X, "Are you sure you want to deevolve [T] from [T.caste] to [newcaste]?", , "Yes", "No")
		if(confirm == "No")
			return

		var/reason = stripped_input(X, "Provide a reason for deevolving this xenomorph, [T]")
		if(isnull(reason))
			to_chat(X, "<span class='xenowarning'>You must provide a reason for deevolving [T].</span>")
			return

		if(!X.check_state() || !X.check_plasma(600) || X.observed_xeno != T)
			return

		if(T.is_ventcrawling)
			return

		if(!isturf(T.loc))
			return

		if(T.health <= 0)
			return

		to_chat(T, "<span class='xenowarning'>The queen is deevolving you for the following reason: [reason]</span>")

		var/xeno_type

		switch(newcaste)
			if("Runner")
				xeno_type = /mob/living/carbon/Xenomorph/Runner
			if("Drone")
				xeno_type = /mob/living/carbon/Xenomorph/Drone
			if("Sentinel")
				xeno_type = /mob/living/carbon/Xenomorph/Sentinel
			if("Spitter")
				xeno_type = /mob/living/carbon/Xenomorph/Spitter
			if("Lurker")
				xeno_type = /mob/living/carbon/Xenomorph/Lurker
			if("Warrior")
				xeno_type = /mob/living/carbon/Xenomorph/Warrior
			if("Defender")
				xeno_type = /mob/living/carbon/Xenomorph/Defender

		//From there, the new xeno exists, hopefully
		var/mob/living/carbon/Xenomorph/new_xeno = new xeno_type(get_turf(T))

		if(!istype(new_xeno))
			//Something went horribly wrong!
			to_chat(X, "<span class='warning'>Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!</span>")
			if(new_xeno)
				cdel(new_xeno)
			return

		if(T.mind)
			T.mind.transfer_to(new_xeno)
		else
			new_xeno.key = T.key
			if(new_xeno.client)
				new_xeno.client.change_view(world.view)
				new_xeno.client.pixel_x = 0
				new_xeno.client.pixel_y = 0

		//Pass on the unique nicknumber, then regenerate the new mob's name now that our player is inside
		new_xeno.nicknumber = T.nicknumber
		new_xeno.generate_name()

		if(T.xeno_mobhud)
			var/datum/mob_hud/H = huds[MOB_HUD_XENO_STATUS]
			H.add_hud_to(new_xeno) //keep our mobhud choice
			new_xeno.xeno_mobhud = TRUE

		new_xeno.middle_mouse_toggle = T.middle_mouse_toggle //Keep our toggle state

		for(var/obj/item/W in T.contents) //Drop stuff
			T.drop_inv_item_on_ground(W)

		T.empty_gut()
		new_xeno.visible_message("<span class='xenodanger'>A [new_xeno.caste] emerges from the husk of \the [T].</span>", \
		"<span class='xenodanger'>[X] makes you regress into your previous form.</span>")

		if(T.queen_chosen_lead)
			new_xeno.queen_chosen_lead = TRUE
			new_xeno.hud_set_queen_overwatch()

		var/datum/hive_status/hive = hive_datum[X.hivenumber]

		if(hive.living_xeno_queen && hive.living_xeno_queen.observed_xeno == T)
			hive.living_xeno_queen.set_queen_overwatch(new_xeno)

		new_xeno.upgrade_xeno(TRUE, min(T.upgrade+1,3)) //a young Crusher de-evolves into a MATURE Hunter

		message_admins("[key_name_admin(X)] has deevolved [key_name_admin(T)]. Reason: [reason]")
		log_admin("[key_name_admin(X)] has deevolved [key_name_admin(T)]. Reason: [reason]")

		round_statistics.total_xenos_created-- //so an evolved xeno doesn't count as two.
		cdel(T)
		X.use_plasma(600)

	else
		to_chat(X, "<span class='warning'>You must overwatch the xeno you want to de-evolve.</span>")