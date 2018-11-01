/obj/machinery/r_n_d/biolathe
	name = "Bio-Organic Autolathe"
	icon_state = "protolathe"


	var/obj/machinery/r_n_d/marineprotolathe/linked_protolathe
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 5000

/obj/machinery/r_n_d/biolathe/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/biolathe(src)
	component_parts += new /obj/item/marineResearch/xenomorp/secretor/hivelord(src)		// Aliens will ABSOLUTELY HATE any researcher, that build this thing
	component_parts += new /obj/item/stock_parts/manipulator(src)

/obj/machinery/r_n_d/biolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (shocked)
		shock(user,50)
	if (O.is_open_container())
		return 1
	if (istype(O, /obj/item/tool/screwdriver))
		if (!opened)
			opened = 1
			if(linked_console)
				linked_protolathe.linked_biolathe = null
				linked_protolathe = null
			icon_state = "protolathe_t"
			to_chat(user, "You open the maintenance hatch of [src].")
		else
			opened = 0
			icon_state = "protolathe"
			to_chat(user, "You close the maintenance hatch of [src].")
		return
	if (opened)
		if(istype(O, /obj/item/tool/crowbar))
			playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
			linked_protolathe.linked_biolathe = null
			linked_protolathe = null
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for(var/obj/I in component_parts)
				I.loc = src.loc
			cdel(src)
			return 1
	return