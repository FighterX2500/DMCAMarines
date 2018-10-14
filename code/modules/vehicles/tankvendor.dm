//special TC's machinery for the Garage
/obj/machinery/vehicle_vendor
	name = "ColMarTech Automated Vehicle Vendor"
	desc = "Only TCs have access to these"
	icon = 'icons/obj/machines/vending.dmi'
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER


	var/vendor_role = "Tank Crew" //everyone else, fuck off

	var/list/listed_products


/obj/machinery/marine_selector/attack_hand(mob/user)

	if(stat & (BROKEN|NOPOWER))
		return

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user


	var/obj/item/card/id/I = H.wear_id
	if(!istype(I)) //not wearing an ID
		to_chat(H, "<span class='warning'>Access denied. No ID card detected</span>")
		return

	if(I.registered_name != H.real_name)
		to_chat(H, "<span class='warning'>Wrong ID card owner detected.</span>")
		return

	if(vendor_role && I.rank != vendor_role)
		to_chat(H, "<span class='warning'>This machine isn't for you.</span>")
		return

	user.set_interaction(src)
	ui_interact(user)

/obj/machinery/marine_selector/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	if(!ishuman(user)) return

	var/list/display_list = list()

	for(var/i in 1 to listed_products.len)
		var/list/myprod = listed_products[i]
		var/p_name = myprod[1]
		var/p_weight = myprod[2]
		if(p_weight > 0)
			p_name += " ( [p_weight]RW)"

		var/prod_available = FALSE
		if(aval_tank_mod.Find(myprod[4]))
			prod_available = TRUE

								//place in main list, name, cost, available or not, color.
		display_list += list(list("prod_index" = i, "prod_name" = p_name, "prod_available" = prod_available, "prod_color" = myprod[5]))


	var/list/data = list(
		"vendor_name" = name,
		"displayed_records" = display_list,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "tank_vendor.tmpl", name , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/marine_selector/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.is_mob_incapacitated())
		return

	if (in_range(src, usr) && isturf(loc) && ishuman(usr))
		usr.set_interaction(src)
		if (href_list["vend"])

			var/idx=text2num(href_list["vend"])

			var/list/L = listed_products[idx]
			var/mob/living/carbon/human/H = usr

			var/obj/item/card/id/I = H.wear_id
			if(!istype(I)) //not wearing an ID
				to_chat(H, "<span class='warning'>Access denied. No ID card detected</span>")
				return

			if(I.registered_name != H.real_name)
				to_chat(H, "<span class='warning'>Wrong ID card owner detected.</span>")
				return

			if(vendor_role && I.rank != vendor_role)
				to_chat(H, "<span class='warning'>This machine isn't for you.</span>")
				return

			var/type_p = L[3]
			var/obj/item/IT = new type_p(loc)
			IT.add_fingerprint(usr)

			if(aval_tank_mod.Find(L[4]))
				aval_tank_mod -= L[4]
				H.update_action_buttons()
			else
				to_chat(H, "<span class='warning'>You already took something from this category.</span>")
				return



		src.add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window

var/list/aval_tank_mod = list("manual", "primary", "secondary", "support", "armor", "treads")

/obj/machinery/vehicle_vendor/tank
	name = "ColMarTech Automated Tank Vendor"
	desc = "This vendor is connected to main ship storage, allows to fetch one hardpoint module per category for free."
	icon = 'icons/obj/machines/vending.dmi'
	icon_state = "engi"

	vendor_role = "Tank Crew" //to be compared with assigned_role to only allow those to use that machine.

	listed_products = list(
							list("GUIDE FOR DUMMIES", null, null, null, "white"),
							list("Guide For Dummies: How To Tank", /obj/item/book/manual/tank_manual, null, "manual", "gold"),
							list("PRIMARY WEAPON", null, null, null, "white"),
							list("M21 Autocannon", 1, /obj/item/hardpoint/primary/autocannon, "primary", null),
							list("M5 LTB Cannon", 2, /obj/item/hardpoint/primary/cannon, "primary", null),
							list("M74 LTAA-AP Minigun", 3, /obj/item/hardpoint/primary/minigun, "primary", null),
							list("SECONDARY WEAPON", null, null, null, "white"),
							list("M56 \"Cupola\"", 2, /obj/item/hardpoint/secondary/m56cupola, "secondary", "orange"),
							list("M8-2 TOW Launcher", 2, /obj/item/hardpoint/secondary/towlauncher, "secondary", null),
							list("M7 \"Dragon\" Flamethrower Unit", 2, /obj/item/hardpoint/secondary/flamer, "secondary", null),
							list("M92 Grenade Launcher", 2, /obj/item/hardpoint/secondary/grenade_launcher, "secondary", null),
							list("SUPPORT MODULE", null, null, null, "white"),
							list("M40 Integrated Weapons Sensor Array", 1, /obj/item/hardpoint/support/weapons_sensor, "support", null),
							list("M6 Artillery Module", 1, /obj/item/hardpoint/support/artillery_module, "support", "orange"),
							list("M103 Overdrive Enhancer", 1, /obj/item/hardpoint/support/overdrive_enhancer, "support", null),
							list("M65-B Armor", 7, /obj/item/hardpoint/armor/ballistic, "armor", "orange"),
							list("M70 \"Caustic\" Armor", 5, /obj/item/hardpoint/armor/caustic, "armor", null),
							list("M66-LC Armor", 4, /obj/item/hardpoint/armor/concussive, "armor", null),
							list("M90 \"Paladin\" Armor", 10, /obj/item/hardpoint/armor/paladin, "armor", null),
							list("M37 \"Snowplow\" Armor", 3, /obj/item/hardpoint/armor/snowplow, "armor", null),
							list("M2 Tank Treads", 1, /obj/item/hardpoint/treads/standard, "treads", "orange"),
							list("M2-R Tank Treads", 3, /obj/item/hardpoint/treads/heavy, "treads", null),
							)







//based on Barsik's fabricator, modules repairing machinery
/obj/machinery/vehicle_vendor/module_repair_station
	name = "tank part fabricator"
	desc = "A large automated 3D printer for producing new tank parts."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"
	var/tank_points = 625
	var/busy

/obj/machinery/vehicle_vendor/module_repair_station/New()
	..()
	start_processing()
/obj/machinery/vehicle_vendor/module_repair_station/power_change()
	..()
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/machinery/vehicle_vendor/module_repair_station/process()
	if(ticker.current_state < GAME_STATE_PLAYING)
		return
	if(stat & NOPOWER)
		icon_state = "drone_fab_nopower"
		return
	if(busy)
		icon_state = "drone_fab_active"
		return
	else
		icon_state = "drone_fab_idle"

/obj/machinery/vehicle_vendor/module_repair_station/attack_hand(mob/user)
	if(..())
		return
	user.set_interaction(src)
	var/dat = "<center><h2>Tank Part Fabricator</h2></center><hr/>"
	dat += "<h4>Points Available: [tank_points]</h4>"
	dat += "<h3>Armor:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/armor))
		var/obj/item/hardpoint/armor/AR = build_type
		var/build_name = initial(AR.name)
		var/build_cost = initial(AR.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Primary Weapon:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/primary))
		var/obj/item/hardpoint/primary/PR = build_type
		var/build_name = initial(PR.name)
		var/build_cost = initial(PR.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Secondary Weapon:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/secondary))
		var/obj/item/hardpoint/secondary/SE = build_type
		var/build_name = initial(SE.name)
		var/build_cost = initial(SE.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Support Module:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/support))
		var/obj/item/hardpoint/support/SP = build_type
		var/build_name = initial(SP.name)
		var/build_cost = initial(SP.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Treads:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/treads))
		var/obj/item/hardpoint/treads/TR = build_type
		var/build_name = initial(TR.name)
		var/build_cost = initial(TR.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Weapon Ammo:</h3>"
	for(var/build_type in typesof(/obj/item/ammo_magazine/tank))
		var/obj/item/ammo_magazine/tank/AM = build_type
		var/build_name = initial(AM.name)
		var/build_cost = initial(AM.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"


	user << browse(dat, "window=dropship_part_fab")
	onclose(user, "dropship_part_fab")
	return

/obj/machinery/vehicle_vendor/module_repair_station/proc/build_tank_part(part_type, cost, mob/user)
	set waitfor = 0
	if(stat & NOPOWER) return
	if(tank_points < cost)
		to_chat(user, "<span class='warning'>You don't have enough points to build that.</span>")
		return
	visible_message("<span class='notice'>[src] starts printing something.</span>")
	tank_points -= cost
	icon_state = "drone_fab_active"
	busy = TRUE
	sleep(100)
	busy = FALSE
	var/turf/T = locate(x+1,y-1,z)
	playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
	new part_type(T)
	icon_state = "drone_fab_idle"

/obj/machinery/vehicle_vendor/module_repair_station/Topic(href, href_list)
	if(..())
		return

	usr.set_interaction(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, "<span class='warning'>The autolathe is busy. Please wait for completion of previous operation.</span>")
		return

	if(href_list["produce"])
		build_tank_part(href_list["produce"], text2num(href_list["cost"]), usr)
		return







//old fabricator made by Barsik
/obj/machinery/tank_part_fabricator
	name = "tank part fabricator"
	desc = "A large automated 3D printer for producing new tank parts."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"
	var/tank_points = 625
	var/busy

/obj/machinery/tank_part_fabricator/New()
	..()
	start_processing()

/obj/machinery/tank_part_fabricator/power_change()
	..()
	if (stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/machinery/tank_part_fabricator/process()
	if(ticker.current_state < GAME_STATE_PLAYING)
		return
	if(stat & NOPOWER)
		icon_state = "drone_fab_nopower"
		return
	if(busy)
		icon_state = "drone_fab_active"
		return
	else
		icon_state = "drone_fab_idle"

/obj/machinery/tank_part_fabricator/attack_hand(mob/user)
	if(..())
		return
	user.set_interaction(src)
	var/dat = "<center><h2>Tank Part Fabricator</h2></center><hr/>"
	dat += "<h4>Points Available: [tank_points]</h4>"
	dat += "<h3>Armor:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/armor))
		var/obj/item/hardpoint/armor/AR = build_type
		var/build_name = initial(AR.name)
		var/build_cost = initial(AR.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Primary Weapon:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/primary))
		var/obj/item/hardpoint/primary/PR = build_type
		var/build_name = initial(PR.name)
		var/build_cost = initial(PR.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Secondary Weapon:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/secondary))
		var/obj/item/hardpoint/secondary/SE = build_type
		var/build_name = initial(SE.name)
		var/build_cost = initial(SE.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Support Module:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/support))
		var/obj/item/hardpoint/support/SP = build_type
		var/build_name = initial(SP.name)
		var/build_cost = initial(SP.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Treads:</h3>"
	for(var/build_type in typesof(/obj/item/hardpoint/treads))
		var/obj/item/hardpoint/treads/TR = build_type
		var/build_name = initial(TR.name)
		var/build_cost = initial(TR.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"

	dat += "<h3>Weapon Ammo:</h3>"
	for(var/build_type in typesof(/obj/item/ammo_magazine/tank))
		var/obj/item/ammo_magazine/tank/AM = build_type
		var/build_name = initial(AM.name)
		var/build_cost = initial(AM.point_cost)
		if(build_cost)
			dat += "<a href='byond://?src=\ref[src];produce=[build_type];cost=[build_cost]'>[build_name] ([build_cost])</a><br>"


	user << browse(dat, "window=dropship_part_fab")
	onclose(user, "dropship_part_fab")
	return

/obj/machinery/tank_part_fabricator/proc/build_tank_part(part_type, cost, mob/user)
	set waitfor = 0
	if(stat & NOPOWER) return
	if(tank_points < cost)
		to_chat(user, "<span class='warning'>You don't have enough points to build that.</span>")
		return
	visible_message("<span class='notice'>[src] starts printing something.</span>")
	tank_points -= cost
	icon_state = "drone_fab_active"
	busy = TRUE
	sleep(100)
	busy = FALSE
	var/turf/T = locate(x+1,y-1,z)
	playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
	new part_type(T)
	icon_state = "drone_fab_idle"

/obj/machinery/tank_part_fabricator/Topic(href, href_list)
	if(..())
		return

	usr.set_interaction(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, "<span class='warning'>The autolathe is busy. Please wait for completion of previous operation.</span>")
		return

	if(href_list["produce"])
		build_tank_part(href_list["produce"], text2num(href_list["cost"]), usr)
		return
