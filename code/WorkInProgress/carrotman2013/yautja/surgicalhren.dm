//ƒÀﬂ Õ¿◊¿À¿ —¿Ã »Õ—“–”Ã≈Õ“
/obj/item/tool/pred_surgical
	name = "Universal Surgical Instrument"
	desc = "For heavy duty cutting."
	icon_state = "saw3"
	hitsound = 'sound/weapons/circsawhit.ogg'
	flags_atom = CONDUCT
	force = 15.0
	w_class = 2.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	matter = list("metal" = 20000,"glass" = 10000)
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = IS_SHARP_ITEM_BIG
	flags_item = NOSHIELD|DELONDROP
	flags_equip_slot = NOFLAGS
	edge = 1


/obj/item/tool/pred_surgical/New()
	..()
	if(usr)
		var/obj/item/tool/pred_surgical/W = usr.get_inactive_hand()
		if(istype(W)) //instrument in usr's other hand.
	attack_verb = list("sliced", "slashed", "jabbed", "torn", "gored")


/obj/item/tool/pred_surgical/Dispose()
	. = ..()
	return TA_REVIVE_ME

/obj/item/tool/pred_surgical/Recycle()
	var/blacklist[] = list("attack_verb")
	. = ..() + blacklist

/obj/item/tool/pred_surgical/dropped(mob/living/carbon/human/M)
	playsound(M,'sound/weapons/wristblades_off.ogg', 15, 1)
	if(M)
		var/obj/item/weapon/wristblades/W = M.get_inactive_hand()
	..()

/obj/item/tool/pred_surgical/afterattack(atom/A, mob/user, proximity)



//¬≈–¡ ◊“Œ¡€ ƒŒ—“¿¬¿“‹ ›“” ’≈–Õﬁ


/obj/item/clothing/gloves/yautja/verb/surgery()
	set name = "Universal Surgical Instrument"
	set category = "Yautja"
	set desc = "Extend an universal surgical instrument. Cannot be dropped, but can be retracted."
	if(!usr.canmove || usr.stat || usr.is_mob_restrained())
		return 0

	if(!usr.loc || !usr.canmove || usr.stat) return
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(!isYautja(user))
		to_chat(user, "<span class='warning'>You have no idea how to work these things!</span>")
		return
	var/obj/item/tool/pred_surgical/R = user.get_active_hand()
	if(R && istype(R)) //Turn it off.
		to_chat(user, "<span class='notice'>You retract your universal surgical instrument.</span>")
		playsound(user.loc,'sound/effects/squelch1.ogg', 15, 1)
		surger_active = 0
		user.drop_inv_item_to_loc(R, R.loc)
		return
	else
		if(!drain_power(user,50)) return

		if(R)
			to_chat(user, "<span class='warning'>Your hand must be free to activate your universal surgical instrument!</span>")
			return

		var/datum/limb/hand = user.get_limb(user.hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, "<span class='warning'>You can't hold that!</span>")
			return

		var/obj/item/weapon/wristblades/W
		W =  rnew(upgrades > 2 ? /obj/item/weapon/wristblades/scimitar : /obj/item/weapon/wristblades, user)

		user.put_in_active_hand(W)
		surger_active = 1
		to_chat(user, "<span class='notice'>You activate your universal surgical instrument.</span>")
		playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)


	return 1
















	if(!isYautja(usr))
		to_chat(usr, "<span class='warning'>You have no idea how to work these things!/span>")
		return

	if(usr.get_active_hand())
		to_chat(usr, "<span class='warning'>Your active hand must be empty!</span>")
		return 0

	if(inject_timer)
		to_chat(usr, "<span class='warning'>You recently activated the healing crystal. Be patient.</span>")
		return

	if(!drain_power(usr,1000)) return

	inject_timer = 1
	spawn(1200)
		if(usr && src.loc == usr)
			to_chat(usr, "\blue Your bracers beep faintly and inform you that a new healing crystal is ready to be created.")
			inject_timer = 0

	to_chat(usr, "\blue You feel a faint hiss and a crystalline injector drops into your hand.")
	var/obj/item/reagent_container/hypospray/autoinjector/yautja/O = new(usr)
	usr.put_in_active_hand(O)
	playsound(src,'sound/machines/click.ogg', 15, 1)
	return