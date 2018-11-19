/obj/machinery/r_n_d/marineprotolathe
	name = "Armory Protolathe"
	icon = 'code/WorkInProgress/polion1232/polionresearch.dmi'
	icon_state = "protolathe"
	flags_atom = OPENCONTAINER

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 5000
	var/obj/machinery/r_n_d/biolathe/linked_biolathe = null

	var/list/material_storage = list("metal" = 0.0, "glass" = 0.0, "biomass" = 0.0)
	var/max_stored = 100000
	var/list/max_per_resource = list("metal" = null, "glass" = null, "biomass" = null)

/obj/machinery/r_n_d/marineprotolathe/update_icon()
	if(stat & NOPOWER)
		icon_state = "protolathe_off"
	if(stat & BROKEN || opened)
		icon_state = "protolathe_broken"
	else
		icon_state = "protolathe"

/obj/machinery/r_n_d/marineprotolathe/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/marineprotolathe(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	RefreshParts()

/obj/machinery/r_n_d/marineprotolathe/proc/TotalMaterials() //returns the total of all the stored materials. Makes code neater.
	return material_storage["metal"] + material_storage["glass"] + material_storage["biomass"]

/obj/machinery/r_n_d/marineprotolathe/proc/RefilBio()			// When you connect biomatter generator, you will have no need to refill with alien bodyparts
	if(!linked_biolathe)
		return
	if(material_storage["biomass"] < max_per_resource["biomass"])
		material_storage["biomass"] = max_per_resource["biomass"]
	else
		return

/obj/machinery/r_n_d/marineprotolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		T += M.rating
	max_stored= T * 7500
	max_per_resource = list("metal" = max_stored/3, "glass" = max_stored/3, "biomass" = max_stored/3)

/obj/machinery/r_n_d/marineprotolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (shocked)
		shock(user,50)
	if (O.is_open_container())
		return 1
	if (istype(O, /obj/item/tool/screwdriver))
		if (!opened)
			opened = 1
			if(linked_console)
				linked_console.linked_lathe = null
				linked_console = null
			icon_state = "protolathe_off"
			to_chat(user, "You open the maintenance hatch of [src].")
		else
			opened = 0
			icon_state = "protolathe"
			to_chat(user, "You close the maintenance hatch of [src].")
		return
	if (opened)
		if(istype(O, /obj/item/tool/crowbar))
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for(var/obj/I in component_parts)
				I.loc = src.loc
			if(material_storage["metal"] >= 3750)
				var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal(src.loc)
				G.amount = round(material_storage["metal"] / G.perunit)
			if(material_storage["glass"] >= 3750)
				var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass(src.loc)
				G.amount = round(material_storage["glass"] / G.perunit)
			if(material_storage["biomass"] > 0)
				visible_message("<span class='danger'>All biomass has been splattered across the floor!</span>")
				new /obj/effect/decal/cleanable/blood/xeno(src.loc)
			if(linked_biolathe)
				linked_biolathe.linked_protolathe = null
				linked_biolathe = null
			if(linked_console)
				linked_console.linked_lathe = null
				linked_console = null
			cdel(src)
			return 1

	if(istype(O, /obj/item/marineResearch/xenomorp))
		if(TotalMaterials() > max_stored)
			return 1
		if(max_per_resource["biomass"] <= material_storage["biomass"])
			to_chat(user, "\red The protolathe's biomass bin is full.")
			return 1
		user.drop_held_item()
		material_storage["biomass"] += 500
		cdel(O)
		return 1

	if(istype(O, /obj/item/marineResearch/sampler))
		var/obj/item/marineResearch/sampler/samp = O
		if(!samp.filled)
			to_chat(user, "\red Sampler is empty!")
			return 1
		if(max_per_resource["biomass"] <= material_storage["biomass"])
			to_chat(user, "\red The protolathe's biomass bin is full.")
			return 1
		material_storage["biomass"] += 50
		samp.filled = 0
		samp.sample = null
		samp.update_icon()
		return 1

	if(istype(O,/obj/item/stack/sheet))
		var/obj/item/stack/sheet/S = O
		if (TotalMaterials() + S.perunit > max_stored)
			to_chat(user, "\red The protolathe's material bin is full. Please remove material before adding more.")
			return 1

	var/obj/item/stack/sheet/stack = O
	var/amount = round(input("How many sheets do you want to add?") as num)//No decimals
	if(!O)
		return
	if(amount < 0)//No negative numbers
		amount = 0
	if(amount == 0)
		return
	if(amount > stack.get_amount())
		amount = stack.get_amount()
	if(istype(stack, /obj/item/stack/sheet/metal))
		if(max_per_resource["metal"] < (amount*stack.perunit))//Can't overfill
			amount = min(stack.amount, round((max_per_resource[stack.name])/stack.perunit))
	if(istype(stack, /obj/item/stack/sheet/glass))
		if(max_per_resource["glass"] < (amount*stack.perunit))//Can't overfill
			amount = min(stack.amount, round((max_per_resource[stack.name])/stack.perunit))

	busy = 1
	use_power(max(1000, (3750*amount/10)))
	stack.use(amount)
	to_chat(user, "\blue You add [amount] sheets to the [src.name].")
	if(istype(stack, /obj/item/stack/sheet/metal))
		material_storage["metal"] += amount * 3750
	if(istype(stack, /obj/item/stack/sheet/glass))
		material_storage["glass"] += amount * 3750
	busy = 0
	src.updateUsrDialog()

/obj/machinery/r_n_d/marineprotolathe/Topic(href, href_list)
	if(..())
		return

	add_fingerprint(usr)

	usr.set_interaction(src)

	if(href_list["connect"])
		for(var/obj/machinery/r_n_d/biolathe/D in oview(1,src))
			if(D.linked_protolathe != null || D.disabled || D.opened)
				continue
			if(linked_biolathe == null)
				linked_biolathe = D
				linked_biolathe.linked_protolathe = src
				RefilBio()
				break

	else if(href_list["disconnect"])
		if(linked_biolathe != null)
			linked_biolathe.linked_protolathe = null
			linked_biolathe = null
	updateUsrDialog()

/obj/machinery/r_n_d/marineprotolathe/attack_hand(mob/user as mob)
	if(!opened)
		return

	user.set_interaction(src)

	var/dat = ""
	dat += "INTERNAL LINKAGE PROTOLATHE CONSOLE<HR>"
	if(!linked_biolathe)
		dat += "*<A href='?src=\ref[src];connect=1'>CONNECT NEARBY APPROPRIATE DEVICE</A>"
	else
		dat += "*ALIEN BIOMATTER GENERATOR CONNECTED:<BR><A href='?src=\ref[src];disconnect='>DISCONNECT</A>"

	user << browse("<TITLE>INTERNAL LINKAGE PROTOLATHE CONSOLE</TITLE><HR>[dat]", "window=marineprotolathe;size=575x400")
	onclose(user, "marineprotolathe")