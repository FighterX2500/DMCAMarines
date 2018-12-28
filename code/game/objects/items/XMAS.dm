
/obj/item/m_gift //Marine Gift
	name = "Present"
	desc = "One, standard issue USCM Present"
	icon = 'icons/Seasonal/xmas.dmi'
	icon_state = "present_1"
	item_state = "present_1"
	unacidable = TRUE	//You won't ruin Christmas, filthy xenos!

/obj/item/m_gift/New()
	..()
	pixel_x = rand(-6,6)
	pixel_y = rand(-4,12)
	icon_state = "present_[pick(1, 2, 3, 4, 5, 6, 7, 8)]"
	item_state = "[icon_state]"
	return

/obj/item/m_gift/flamer_fire_act()
	spawn(15)
	cdel(src)

/obj/item/m_gift/attack_self(mob/M as mob)
	var fancy = rand(1,100) //Check if it has the possibility of being a FANCY present
	var exFancy = rand(1,20) // Checks if it might be one of the ULTRA fancy presents.
	var gift_type = /obj/item/storage/fancy/crayons   //Default, just in case

	if(fancy > 95)
		if(exFancy == 1)
			to_chat(M, "\blue It's a brand new, un-restricted, THERMOBARIC ROCKET LAUNCHER!!!!!!  What are the chances???")
			gift_type = /obj/item/weapon/gun/launcher/rocket/m57a4/XMAS
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			cdel(src)
			return
		else if(exFancy == 10)
			to_chat(M, "\blue It's a brand new, un-restricted, ANTI-MATERIAL SNIPER RIFLE!!!!!!  What are the chances???")
			gift_type = /obj/item/weapon/gun/rifle/sniper/elite/XMAS
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			cdel(src)
			return
		else if(exFancy == 20)
			to_chat(M, "\blue Just what the fuck is it???")
			gift_type = /obj/item/clothing/mask/facehugger/lamarr
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			cdel(src)
			return
		else
			gift_type = pick(
			/obj/item/weapon/gun/revolver/mateba,
			/obj/item/weapon/gun/pistol/heavy,
			/obj/item/weapon/claymore,
			/obj/item/weapon/energy/sword/green,
			/obj/item/weapon/energy/sword/red,
			/obj/item/attachable/heavy_barrel,
			/obj/item/attachable/burstfire_assembly,
			/obj/item/attachable/stock/tactical,
			)
			to_chat(M, "\blue It's a REAL gift!!!")
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			cdel(src)
			return

	else if (fancy == 1)
		to_chat(M, "\blue You've been very naughty this year.")
		M.temp_drop_inv_item(src)
		var/obj/item/ore/coal/C = new /obj/item/ore/coal(M)
		M.put_in_hands(C)
		C.add_fingerprint(M)
		cdel(src)
		return

	else if (fancy <= 5)
		to_chat(M, "\blue It's fucking EMPTY.  Man, fuck Barsik.")
		M.temp_drop_inv_item(src)
		cdel(src)
		return


	gift_type = pick(
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/tool/soap/deluxe,
		/obj/item/toy/beach_ball,
		/obj/item/weapon/banhammer,
		/obj/item/toy/crossbow,
		/obj/item/toy/katana,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/ripley,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/clothing/tie/horrible,
		/obj/item/attachable/suppressor,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/attached_gun/flamer,
		/obj/item/attachable/attached_gun/shotgun,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/gyro,
		/obj/item/attachable/quickfire,
		/obj/item/attachable/stock/rifle,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope,
		/obj/item/ammo_magazine/smg/mp5,
		/obj/item/ammo_magazine/pistol/m1911,
		/obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/ammo_magazine/rifle/m16)

	if(!ispath(gift_type,/obj/item))	return
	to_chat(M, "\blue At least it's something...")
	var/obj/item/I = new gift_type(M)
	M.temp_drop_inv_item(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	cdel(src)
	return

/obj/item/m_gift/gun	//uncommon gift with weak non-standard issue gun
	name = "Present"
	desc = "You intuitively feel, that there is a weapon in this one!"

/obj/item/m_gift/gun/attack_self(mob/M as mob)

	var gift_type = /obj/item/storage/fancy/crayons   //Default, just in case

	gift_type = pick(
		/obj/item/weapon/gun/smg/mp5,
		/obj/item/weapon/gun/shotgun/double/sawn,
		/obj/item/weapon/gun/pistol/m1911,
		/obj/item/weapon/gun/pistol/b92fs,
		/obj/item/weapon/gun/revolver/small,
		/obj/item/weapon/gun/rifle/m16)

	if(!ispath(gift_type,/obj/item))	return
	to_chat(M, "\blue Ew, you wanted rocket launcher...")
	var/obj/item/I = new gift_type(M)
	M.temp_drop_inv_item(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	cdel(src)
	return

/obj/item/m_gift/apc	//yes, APC. It's a fucking APC
	name = "Present"
	desc = "This one is really heavy!"

/obj/item/m_gift/apc/attack_self(mob/M as mob)

	new /obj/effect/multitile_spawner/cm_transport/apc/prebuilt(M.loc)

	to_chat(M, "\blue OH, MY FUCKING GOD...")
	M.temp_drop_inv_item(src)
	cdel(src)
	return

/obj/item/m_gift/xeno	//royal jelly! Yay!
	name = "Present"
	desc = "This one has something odd about it."
	var/used = FALSE

/obj/item/m_gift/xeno/New()
	..()
	icon_state = "jelly"

/obj/item/m_gift/xeno/examine(mob/user)
	..()
	if(isXeno(user))
		to_chat(user, "<span class='xenonotice'>You can feel long-missed Royal Jelly inside this odd box! Praise the Queen!</span>")
		return

/obj/item/m_gift/xeno/attack_alien(mob/living/carbon/Xenomorph/X)

	if(used)
		to_chat(X, "<span class='xenowarning'>Oh no, someone has already drunk the juice!</span>")
		return

	X.put_in_hands(src)

/obj/item/m_gift/xeno/attack_self(mob/M as mob)

	if(ishuman(M))
		to_chat(M, "<span class='warning'>Ew, it's slimey! You don't want to open that!</span>")
		return
	if(!isXeno(M))
		return
	var/mob/living/carbon/Xenomorph/X = M
	if(isXenoLarva(X) || istype(X, /mob/living/carbon/Xenomorph/Predalien) || isXenoQueen(X))
		to_chat(X, "<span class='xenowarning'>You won't benefit from Royal Jelly, better leave it to your sisters.</span>")
		return
	if(X.upgrade >= 3 || X.upgrade_stored >= X.upgrade_threshold)
		to_chat(X, "<span class='xenowarning'>You are at your peak form already.</span>")
		return

	playsound(src, pick('sound/effects/alien_resin_break1.ogg','sound/effects/alien_resin_break2.ogg','sound/effects/alien_resin_break3.ogg'), 10, 1)
	used = TRUE
	to_chat(X, "<span class='xenonotice'>You rip the box apart and drink sweet Royal Jelly!</span>")
	X.drop_held_item()
	icon_state = "jelly_ripped"
	X.xeno_jitter(25)
	spawn(30)
	to_chat(X, "<span class='xenonotice'>You feel Royal Jelly ripple through your haemolymph!</span>")
	X.upgrade_stored += 50
	spawn(25)
	cdel(src)

//XMAS guns

/obj/item/weapon/gun/launcher/rocket/m57a4/XMAS
	..()
	flags_gun_features = GUN_INTERNAL_MAG|GUN_TRIGGER_SAFETY
	able_to_fire(mob/living/user)
		var/turf/current_turf = get_turf(user)
		if (current_turf.z == 3 || current_turf.z == 4) //Can't fire on the Almayer, bub.
			click_empty(user)
			to_chat(user, "<span class='warning'>You can't fire that here!</span>")
			return 0
		else
			return 1

/obj/item/weapon/gun/rifle/sniper/elite/XMAS
	..()
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_TRIGGER_SAFETY

	able_to_fire(mob/living/user)
		return 1

//XMAS clothing

/obj/item/xmas_hat
	name = "Christmas hat"
	desc = "Oi, look, it's a Christmas hat! You feel sudden urge to put it over your helmet."
	icon = 'icons/Seasonal/xmas.dmi'
	icon_state = "helmet"
	item_state = "helmet"
	w_class = 1.0
	unacidable = TRUE	//nein!

/obj/item/xmas_hat/attack_self(mob/M as mob)
	M.temp_drop_inv_item(src)
	var/obj/item/clothing/head/xmas/hat = new(loc)
	M.put_in_hands(hat)
	to_chat(M, "<span class='notice'>You adjust your [name] so it can be put on head.</span>")
	cdel(src)

/obj/item/clothing/head/xmas
	name = "Christmas hat"
	desc = "Oi, look, it's a Christmas hat! You feel sudden urge to put it on."
	icon = 'icons/obj/clothing/cm_hats.dmi'
	sprite_sheet_id = 1
	icon_state = "xmas_hat"
	flags_inv_hide = HIDETOPHAIR
	unacidable = TRUE

/obj/item/clothing/head/xmas/attack_self(mob/M as mob)
	M.temp_drop_inv_item(src)
	var/obj/item/xmas_hat/item_hat = new(loc)
	M.put_in_hands(item_hat)
	to_chat(M, "<span class='notice'>You adjust your [name] so it can be put on helmet.</span>")
	cdel(src)

//Snowman

/obj/effect/snowman
	name = "snowman"
	desc = "Oh, cool, it's a snowman!"
	icon = 'icons/Seasonal/xmas.dmi'
	icon_state = "snowman_1"
	density = 1
	opacity = 0
	anchored = 1
	throwpass = TRUE
	var/present = FALSE
	var/health = 20
	var/max_health = 20
	var/obj/item/clothing/suit/added_armor
	var/obj/item/clothing/head/added_head
	layer = ABOVE_MOB_LAYER

/obj/effect/snowman/present
	present = TRUE

/obj/effect/snowman/New()
	..()
	healthcheck()
	return

/obj/effect/snowman/update_icon()
	overlays.Cut()
	icon = 'icons/Seasonal/xmas.dmi'
	if(health > max_health * 0.65)
		icon_state = "snowman_1"
	else if(health > max_health * 0.35)
		icon_state = "snowman_2"
	else icon_state = "snowman_3"
	if(added_armor)
		var/image/I = image(icon = (added_armor.sprite_sheet_id? 'icons/mob/suit_1.dmi' : 'icons/mob/suit_0.dmi'),icon_state = added_armor.icon_state)
		I.pixel_x -=1
		overlays += I
	if(added_head)
		var/image/I = image(icon = (added_head.sprite_sheet_id? 'icons/mob/head_1.dmi' : 'icons/mob/head_0.dmi'), icon_state = added_head.icon_state)
		I.pixel_x -=1
		overlays += I
		if(istype(added_head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/M = added_head
			for(var/i in M.helmet_overlays)
				I = M.helmet_overlays[i]
				if(I)
					I = image('icons/mob/helmet_garb.dmi',src,I.icon_state)
					I.pixel_x -=1
					overlays += I
	return

/obj/effect/snowman/examine(mob/user)
	..()
	if(icon_state == "snowman_1")
		to_chat(user, "It looks nicely built.")
		return
	if(icon_state == "snowman_2")
		to_chat(user, "It looks like it could use some fixing.")
		return
	to_chat(user, "It looks like it's barely standing upright.")

/obj/effect/snowman/proc/healthcheck()
	if(health <= -250)
		cdel(src)
	if(health <= 0)
		density = 0
		if(added_armor)
			added_armor.Move(loc)
			added_armor = null
		if(added_head)
			added_head.Move(loc)
			added_head = null
		if(present)
			if(prob(2))
				new /obj/item/m_gift/apc(loc)
			else if(prob(10))
				new /obj/item/clothing/mask/facehugger(loc)
			else new /obj/item/m_gift(loc)
		cdel(src)
	else
		update_icon()

/obj/effect/snowman/flamer_fire_act()
	visible_message("<span class='warning'>Oh no, \the [src] is melting!</span>")
	density = 0
	spawn(5)
	icon_state = "snowman_melting"
	spawn(5)
	if(added_armor)
		added_armor.Move(loc)
		added_armor = null
	if(added_head)
		added_head.Move(loc)
		added_head = null
	spawn(30)
	health -= 100
	cdel(src)

/obj/effect/snowman/bullet_act(var/obj/item/projectile/Proj)
	if(prob(10))
		return
	if(Proj.ammo.flags_ammo_behavior & AMMO_XENO_TOX)
		return
	health -= Proj.damage/5
	healthcheck()
	return

/obj/effect/snowman/ex_act(severity)
	health -= pick(30, 40, 60)
	healthcheck()
	return

/obj/effect/snowman/hitby(AM as mob|obj)
	..()
	if(istype(AM,/mob/living/carbon/Xenomorph))
		return
	visible_message("<span class='danger'>\The [src] was hit by \the [AM].</span>", \
	"<span class='danger'>You hit \the [src].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 20
	else
		tforce = AM:throwforce
	health = max(0, health - tforce)
	healthcheck()

/obj/effect/snowman/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) //Larvae can't do shit
		return 0
	M.visible_message("<span class='xenonotice'>\The [M] claws \the [src]!</span>", \
	"<span class='xenonotice'>You claw \the [src].</span>")
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	health -= (M.melee_damage_upper) //Beef up the damage a bit
	healthcheck()

/obj/effect/snowman/attack_animal(mob/living/M as mob)
	M.visible_message("<span class='danger'>[M] tears \the [src]!</span>", \
	"<span class='danger'>You tear \the [name].</span>")
	health -= 10
	healthcheck()

/obj/effect/snowman/attack_hand(mob/user)
	if(ishuman(user))
		if(user.a_intent == "grab")
			remove_gear(user)
			return

		if(user.a_intent == "help")
			return

		var/mob/living/carbon/human/M = user
		M.animation_attack_on(src)
		M.flick_attack_overlay(src, "punch")
	user.visible_message("<span class='warning'>[user] punches [src]!</span>", \
	"<span class='notice'>You punch \the [src].</span>")
	health -= 5
	healthcheck()

/obj/effect/snowman/attack_paw()
	return attack_hand()

/obj/effect/snowman/attackby(obj/item/W, mob/living/carbon/human/user)
	if(istype(W, /obj/item/clothing/suit) && !added_armor)
		user.visible_message("<span class='notice'>[user] starts to put [W] on \the [src].</span>", \
		"<span class='notice'>You start to put [W] on \the [name].</span>")
		if(!do_after(user, 30, TRUE, 5, BUSY_ICON_BUILD))
			return
		if(added_armor)
			to_chat(user, "<span class='warning'>Someone already put [added_armor] on [src]!</span>")
			return
		added_armor = W
		add_fingerprint(user)
		user.temp_drop_inv_item(W)
		user.visible_message("<span class='notice'>[user] puts [W] on \the [src]!</span>", \
		"<span class='notice'>You put [W] on \the [name].</span>")
		W.Move(src)
		health += 20
		max_health += 20
		healthcheck()
		return
	if(istype(W, /obj/item/clothing/head) && !added_head)
		user.visible_message("<span class='notice'>[user] starts to put [W] on \the [src].</span>", \
		"<span class='notice'>You start to put [W] on \the [name].</span>")
		if(!do_after(user, 30, TRUE, 5, BUSY_ICON_BUILD))
			return
		if(added_head)
			to_chat(user, "<span class='warning'>Someone already put [added_head] on [src]!</span>")
			return
		added_head = W
		added_head.update_icon()
		add_fingerprint(user)
		user.temp_drop_inv_item(W)
		user.visible_message("<span class='notice'>[user] puts [W] on \the [src].</span>", \
		"<span class='notice'>You put [W] on \the [name].</span>")
		W.Move(src)
		health += 5
		max_health += 5
		healthcheck()
		return
	if(istype(W, /obj/item/stack/snow))
		if(health >- max_health)
			to_chat(user, "<span class='warning'>[src] is intact, there is no need to fix it.</span>")
			return
		var/obj/item/stack/snow/SN = W
		if(SN.amount < 2)
			to_chat(user, "<span class='warning'>You need at least 2 layers of snow to fix [src]!</span>")
			return
		user.visible_message("<span class='notice'>[user] starts to fix \the [src].</span>", \
		"<span class='notice'>You start to fix \the [name].</span>")
		if(!do_after(user, 30, TRUE, 5, BUSY_ICON_BUILD))
			return
		if(SN.amount < 2)
			return
		add_fingerprint(user)
		SN.use(2)
		user.visible_message("<span class='notice'>[user] finishes fixing \the [src].</span>", \
		"<span class='notice'>You finish fixing \the [name].</span>")
		health = max_health
		healthcheck()
		return

	var/damage = W.force
	if(W.w_class < 3 || W.force < 20) //only big strong sharp weapon are adequate
		damage /= 4
	user.visible_message("<span class='warning'>[user] attacks [src] with [W]!</span>", \
	"<span class='notice'>You attack \the [src] with [W].</span>")
	user.animation_attack_on(src)
	user.flick_attack_overlay(src, "punch")
	health -= damage
	healthcheck()

	return

/obj/effect/snowman/proc/remove_gear(var/mob/living/carbon/human/user)
	add_fingerprint(user)
	if(!Adjacent(user))
		to_chat(user, "<span class='warning'>Something is between you and [src].</span>")
		return
	if(!added_armor && !added_head)
		return

	var/choice = input("Select what gear piece to take off.") in list(added_head, added_armor)

	if(!do_after(user, 30, TRUE, 5, BUSY_ICON_BUILD))
		return

	if(!choice)
		to_chat(user, "<span class='warning'>Someone already took it off [src]!</span>")
		return

	if(choice == added_armor)
		if(health - 20 <= 0)
			health = 1
		max_health -= 20
		added_armor.Move(loc)
		user.put_in_hands(added_armor)
		added_armor = null
	if(choice == added_head)
		if(health - 5 <= 0)
			health = 1
		max_health -= 5
		added_head.Move(loc)
		added_head.update_icon()
		user.put_in_hands(added_head)
		added_head = null
	healthcheck()
	return

/obj/item/paper/xmas_note_2
	name = "small note"
	icon_state = "paper_words"
	info = "Hey, Mike! Danny said they finally received the package in Garage and will deliver it to bar at 17:30. They even got those hats I told you about! Make sure no one read this, it's supposed to be a surprise!<br>Vlad<br>"

/obj/item/paper/xmas_note_1
	name = "small note"
	icon_state = "paper_words"
	info = "Terry, I'll be waiting for you at the bar after your shift. Gonna come early to get the table closest to the christmas tree as you wanted!<br>xoxo<br>Laura<br>"

/obj/item/paper/manifest/xmas
	name = "Supply Manifest"
	icon_state = "paper_words"

/obj/item/paper/manifest/xmas/New()
	..()
	info = "<h3>Shiva Iceball Cargo Manifest</h3><hr><br>"
	info +="Order #31-2018-DC<br>"
	info +="2 PACKAGES IN THIS SHIPMENT<br>"
	info +="CONTENTS:<br><ul>"
	info += "<li>Christmas Gifts crate (x15).</li>"
	info += "<li>Christmas Hats crate (x15).</li>"
	info += "</ul><br>"
	info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS"

	stamps += (stamps=="" ? "<HR>" : "<BR>") + "<i>This paper has been stamped with the Quartermaster stamp.</i>"

	var/image/I = image(icon, icon_state = "paper_stamp-qm")
	var/{x; y;}
	x = rand(-2, 2)
	y = rand(-3, 2)
	I.pixel_x = x
	I.pixel_y = y

	stamped += /obj/item/tool/stamp
	overlays += I
	return