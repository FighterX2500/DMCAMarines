///// EQUIPMENT MODIFICATION UNIT /////

///// Everything needed to provide a bit more survival for poor UA G.I.'s
/// Equipment can be modifyed ONLY ONCE. So choose carefully


// List of armor mods
// "Hunter" armor mod - more armor, better protection against melee and bullets // Xeno Biology
// "Juggernaut" armor mod - upgraded "Hunter", but less burn protection and decreace movement speed // Xeno Biology, Crusher's chitin patterns
// "Farsight" armor mod - GREATLY increace movement speed, reduce overall protection // Xeno Biology

// "Bughead" helmet mod - overall more armor // Xeno Biology
// "Defender" helmet mod - better version of "Bughead" // Xeno Biology, Crusher's chitin patterns

/obj/machinery/r_n_d/modifyer
	name = "Equipment Modification Unit"
	icon_state = "d_analyzer"
	var/obj/item/clothing/loaded_item = null // Because armor and helmet too different

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/machinery/r_n_d/modifyer/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/modifyer(src) //We'll need it's own board one day.
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/micro_laser(src)

/obj/machinery/r_n_d/modifyer/attackby(var/obj/O as obj, var/mob/user as mob)
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
		to_chat(user, "\red The EMU must be linked to an R&D console first!")
		return
	if (busy)
		to_chat(user, "\red EMU is busy right now.")
		return
	if (istype(O, /obj/item) && !loaded_item)
		if(isrobot(user)) //Don't put your module items in there!
			return
		if(!istype(O, /obj/item/clothing/suit/storage/marine))
			if(!istype(O, /obj/item/clothing/head/helmet/marine))
				to_chat(user, "\red Can't do anything with that!")
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
		to_chat(user, "\red Can't do anything with that!")
	return
