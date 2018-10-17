/obj/machinery/r_n_d/dissector
	name = "Organic dissector"
	icon_state = "d_analyzer"
	var/obj/item/marineResearch/xenomorp/loaded_item = null
	var/decon_mod = 1

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/machinery/r_n_d/dissector/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/S in src)
		T += S.rating * 0.1
	T = between (0, T, 1)
	decon_mod = T

/obj/machinery/r_n_d/dissector/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/dissector(src) //We'll need it's own board one day.
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/micro_laser(src)
	RefreshParts()

/obj/machinery/r_n_d/dissector/attackby(var/obj/O as obj, var/mob/user as mob)
	if (shocked)
		shock(user,50)
	if (istype(O, /obj/item/tool/screwdriver))
		if (!opened)
			opened = 1
			if(linked_console)
				linked_console.linked_destroy = null
				linked_console = null
			icon_state = "d_analyzer_t"
			to_chat(user, "You open the maintenance hatch of [src].")
		else
			opened = 0
			icon_state = "d_analyzer"
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
			cdel(src)
			return 1
		else
			to_chat(user, "\red You can't load the [src.name] while it's opened.")
			return 1
	if (disabled)
		return
	if (!linked_console)
		to_chat(user, "\red The Organic dissector must be linked to an R&D console first!")
		return
	if (busy)
		to_chat(user, "\red The Organic dissector is busy right now.")
		return
	if (istype(O, /obj/item) && !loaded_item)
		if(isrobot(user)) //Don't put your module items in there!
			return
		if(istype(O, /obj/item/marineResearch/sampler))
			var/obj/item/marineResearch/sampler/A = O
			if(!A.filled)
				to_chat(user, "\red [O.name] is empty!")
				return 1
			A.filled = 0
			loaded_item = A.sample
			A.sample = null
			A.icon_state = "1"
			to_chat(user, "\blue You add the [loaded_item.name] to the machine!")
			flick("d_analyzer_la", src)
			spawn(10)
				icon_state = "d_analyzer_l"
				busy = 0
			return 1
		if(!istype(O, /obj/item/marineResearch/xenomorp))
			to_chat(user, "\red Can't do anything with that, maybe something organic...!")
			return
		busy = 1
		loaded_item = O
		user.drop_held_item()
		O.loc = src
		to_chat(user, "\blue You add the [O.name] to the machine!")
		flick("d_analyzer_la", src)
		spawn(10)
			icon_state = "d_analyzer_l"
			busy = 0
		return 1
	else
		to_chat(user, "\red Can't do anything with that, maybe something organic...!")
	return