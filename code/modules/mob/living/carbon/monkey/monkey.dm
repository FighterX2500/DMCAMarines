/mob/living/carbon/monkey
	name = "monkey"
	voice_name = "monkey"
	speak_emote = list("chimpers")
	icon_state = "monkey1"
	icon = 'icons/mob/monkey.dmi'
	gender = NEUTER
	flags_pass = PASSTABLE
	hud_possible = list(STATUS_HUD_XENO_INFECTION)

	var/obj/item/card/id/wear_id = null // Fix for station bounced radios -- Skie
	var/greaterform = "Human"                  // Used when humanizing a monkey.
	icon_state = "monkey1"
	//var/uni_append = "12C4E2"                // Small appearance modifier for different species.
	var/list/uni_append = list(0x12C,0x4E2)    // Same as above for DNA2.
	var/update_muts = 1                        // Monkey gene must be set at start.
	var/env_low_temp_resistance = T0C + 10 //lowest temperature the monkey can handle without taking dmg (used by yiren)


/mob/living/carbon/monkey/prepare_huds()
	..()
	med_hud_set_status()
	add_to_all_mob_huds()


/mob/living/carbon/monkey/tajara
	name = "farwa"
	voice_name = "farwa"
	speak_emote = list("mews")
	icon_state = "tajkey1"
	greaterform = "Tajara"
	uni_append = list(0x0A0,0xE00) // 0A0E00

/mob/living/carbon/monkey/skrell
	name = "neaera"
	voice_name = "neaera"
	speak_emote = list("squicks")
	icon_state = "skrellkey1"
	greaterform = "Skrell"
	uni_append = list(0x01C,0xC92) // 01CC92

/mob/living/carbon/monkey/unathi
	name = "stok"
	voice_name = "stok"
	speak_emote = list("hisses")
	icon_state = "stokkey1"
	greaterform = "Unathi"
	uni_append = list(0x044,0xC5D) // 044C5D

/mob/living/carbon/monkey/New()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	species = all_species[greaterform]
	add_language(species.language)

	if(name == initial(name)) //To stop Pun-Pun becoming generic.
		name = "[name] ([rand(1, 1000)])"
		real_name = name

	if (!(dna))
		if(gender == NEUTER)
			gender = pick(MALE, FEMALE)
		dna = new /datum/dna( null )
		dna.real_name = real_name
		dna.ResetSE()
		dna.ResetUI()
		//dna.uni_identity = "00600200A00E0110148FC01300B009"
		//dna.SetUI(list(0x006,0x002,0x00A,0x00E,0x011,0x014,0x8FC,0x013,0x00B,0x009))
		//dna.struc_enzymes = "43359156756131E13763334D1C369012032164D4FE4CD61544B6C03F251B6C60A42821D26BA3B0FD6"
		//dna.SetSE(list(0x433,0x591,0x567,0x561,0x31E,0x137,0x633,0x34D,0x1C3,0x690,0x120,0x321,0x64D,0x4FE,0x4CD,0x615,0x44B,0x6C0,0x3F2,0x51B,0x6C6,0x0A4,0x282,0x1D2,0x6BA,0x3B0,0xFD6))
		dna.unique_enzymes = md5(name)

		// We're a monkey
		dna.SetSEState(MONKEYBLOCK,   1)
		dna.SetSEValueRange(MONKEYBLOCK,0xDAC, 0xFFF)
		// Fix gender
		dna.SetUIState(DNA_UI_GENDER, gender != MALE, 1)

		// Set the blocks to uni_append, if needed.
		if(uni_append.len>0)
			for(var/b=1;b<=uni_append.len;b++)
				dna.SetUIValue(DNA_UI_LENGTH-(uni_append.len-b),uni_append[b], 1)
		dna.UpdateUI()

		update_muts=1

	..()


/mob/living/carbon/monkey/unathi/New()
	..()
	dna.mutantrace = "lizard"

/mob/living/carbon/monkey/skrell/New()
	..()
	dna.mutantrace = "skrell"

/mob/living/carbon/monkey/tajara/New()
	..()
	dna.mutantrace = "tajaran"

/mob/living/carbon/monkey/movement_delay()
	. = ..()

	if(reagents)
		if(reagents.has_reagent("hyperzine")) . -= 1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45) . += (health_deficiency / 25)

	if(bodytemperature < 283.222)
		. += (283.222 - bodytemperature) / 10 * 1.75

	. += config.monkey_delay


/mob/living/carbon/monkey/Topic(href, href_list)
	if (href_list["mach_close"])
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_interaction()
		src << browse(null, t1)
	if (href_list["item"])
		if(!usr.is_mob_incapacitated() && in_range(src, usr))
			if(!usr.action_busy)
				var/slot = text2num(href_list["item"])
				var/obj/item/what = get_item_by_slot(slot)
				if(what)
					usr.stripPanelUnequip(what,src,slot)
				else
					what = usr.get_active_hand()
					usr.stripPanelEquip(what,src,slot)

	if(href_list["internal"])

		if(!usr.action_busy)
			log_combat(usr, src, "toggled internals (attempted)")
			if(internal)
				usr.visible_message("\red <B>[usr] is trying to disable [src]'s internals</B>", null, 4)
			else
				usr.visible_message("\red <B>[usr] is trying to enable [src]'s internals.</B>", null, 4)

			if(do_mob(usr, src, 30, BUSY_ICON_GENERIC, BUSY_ICON_GENERIC))
				if (internal)
					internal.add_fingerprint(usr)
					internal = null
					if (hud_used && hud_used.internals)
						hud_used.internals.icon_state = "internal0"
				else
					if(istype(wear_mask, /obj/item/clothing/mask))
						if (istype(back, /obj/item/tank))
							internal = back
							visible_message("[src] is now running on internals.", null, 3)
							internal.add_fingerprint(usr)
							if (hud_used && hud_used.internals)
								hud_used.internals.icon_state = "internal1"


	..()


/mob/living/carbon/monkey/attack_paw(mob/M as mob)
	..()

	if (M.a_intent == "help")
		help_shake_act(M)
	else
		if ((M.a_intent == "hurt" && !( istype(wear_mask, /obj/item/clothing/mask/muzzle) )))
			if ((prob(75) && health > 0))
				playsound(loc, 'sound/weapons/bite.ogg', 25, 1)
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[M.name] has bit [name]!</B>", 1)
				var/damage = rand(1, 5)
				adjustBruteLoss(damage)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
				for(var/datum/disease/D in M.viruses)
					if(istype(D, /datum/disease/jungle_fever))
						contract_disease(D,1,0)
			else
				for(var/mob/O in viewers(src, null))
					O.show_message("\red <B>[M.name] has attempted to bite [name]!</B>", 1)
	return

/mob/living/carbon/monkey/attack_hand(mob/living/carbon/human/M as mob)
	if (!ticker)
		to_chat(M, "You cannot attack people before the game has started.")
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		to_chat(M, "No attacking people at spawn, you jackass.")
		return

	if(M.gloves)
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.use(2500)
					KnockDown(5)
					if (stuttering < 5)
						stuttering = 5
					Stun(5)

					for(var/mob/O in viewers(src, null))
						if (O.client)
							O.show_message("\red <B>[src] has been touched with the stun gloves by [M]!</B>", 1, "\red You hear someone fall", 2)
					return
				else
					to_chat(M, "\red Not enough charge! ")
					return

	if (M.a_intent == "help")
		help_shake_act(M)
	else
		if (M.a_intent == "hurt")
			var/datum/unarmed_attack/attack = M.species.unarmed
			if ((prob(75) && health > 0))
				visible_message("\red <B>[M] [pick(attack.attack_verb)]ed [src]!</B>")

				playsound(loc, "punch", 25, 1)
				var/damage = rand(5, 10)
				if (prob(40))
					damage = rand(10, 15)
					if (knocked_out < 5)
						KnockOut(rand(10, 15))
						visible_message("\red <B>[M] has knocked out [src]!</B>")

				adjustBruteLoss(damage)

				log_combat(M, src, "[pick(attack.attack_verb)]ed")
				msg_admin_attack("[key_name(M)] [pick(attack.attack_verb)]ed [key_name(src)]")

				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1)
				visible_message("\red <B>[M] tried to [pick(attack.attack_verb)] [src]!</B>")
		else
			if (M.a_intent == "grab")
				if(M == src || anchored)
					return 0

				M.start_pulling(src)
				return 1
			else
				if (!( knocked_out ))
					if (prob(25))
						KnockOut(2)
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(text("\red <B>[] has pushed down [name]!</B>", M), 1)
					else
						drop_held_item()
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1)
						for(var/mob/O in viewers(src, null))
							if ((O.client && !( O.blinded )))
								O.show_message(text("\red <B>[] has disarmed [name]!</B>", M), 1)
	return

/mob/living/carbon/monkey/attack_animal(mob/living/M as mob)
	if (!..())
		return 0

	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		if(M.attack_sound)
			playsound(loc, M.attack_sound, 25, 1)
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[M]</B> [M.attacktext] [src]!", 1)
		log_combat(M, src, "attacked")
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()

	return 1


/mob/living/carbon/monkey/Stat()
	stat(null, text("Intent: []", a_intent))
	stat(null, text("Move Mode: []", m_intent))

/mob/living/carbon/monkey/verb/removeinternal()
	set name = "Remove Internals"
	set category = "IC"
	internal = null
	return


/mob/living/carbon/monkey/emp_act(severity)
	if(wear_id) wear_id.emp_act(severity)
	..()

/mob/living/carbon/monkey/ex_act(severity)
	flash_eyes()

	switch(severity)
		if(1.0)
			if (stat != 2)
				adjustBruteLoss(200)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
		if(2.0)
			if (stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
		if(3.0)
			if (stat != 2)
				adjustBruteLoss(30)
				health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
			if (prob(50))
				KnockOut(10)
		else
	return

/mob/living/carbon/monkey/IsAdvancedToolUser()//Unless its monkey mode monkeys cant use advanced tools
	if(universal_speak == 1)
		return 1
	return 0

/mob/living/carbon/monkey/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/italics=0, var/message_range = world.view, var/list/used_radios = list())
        if(stat)
                return

        if(copytext(message,1,2) == "*")
                return emote(copytext(message,2))

        if(stat)
                return

        if(speak_emote.len)
                verb = pick(speak_emote)

        message = capitalize(trim_left(message))

        ..(message, speaking, verb, alt_name, italics, message_range, used_radios)





/mob/living/carbon/monkey/update_sight()
	if (stat == DEAD || (XRAY in mutations))
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else if (stat != DEAD)
		sight &= ~SEE_TURFS
		sight &= ~SEE_MOBS
		sight &= ~SEE_OBJS
		see_in_dark = 2
		see_invisible = SEE_INVISIBLE_LIVING
