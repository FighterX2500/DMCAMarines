/obj/machinery/hive_disruptor
	name = "Hive Disruptor"
	desc = "Complex machine, specially created to disturb alien minds."
	icon = 'icons/obj/machines/virology.dmi'								//placeholder
	icon_state = "analyser"
	var/signature														//hive to ddos

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500
	var/shocked = 0
	var/opened = 0

/obj/machinery/hive_disruptor/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/hive_disruptor(src)
	component_parts += new /obj/item/stock_parts/scanning_module
	component_parts += new /obj/item/stock_parts/scanning_module
	var/obj/item/circuitboard/machine/hive_disruptor/hive_disr = component_parts[1]
	signature = hive_disr.hive_signature
	var/datum/hive_status/hive
	if(signature && signature <= hive_datum.len && src.z == 1)
		hive = hive_datum[signature]
		hive.disruptor = src
		if(signature != XENO_HIVE_NORMAL)
			name += " " + hive.prefix
			desc += " It disrupts \"" + hive.prefix + "\" hivelink."
		else
			name += " \"Main\""
			desc += " It disrupts enemy hivelink."
		hive.disrupted = 1
		for(var/mob/living/carbon/Xenomorph/xeno in living_xeno_list)
			if(xeno.hivenumber == signature)
				to_chat(xeno, "<span class='xenodanger'>You can hear some disturbing noise...</span>")
	else
		name += " (broken)"
		desc += " This disruptor seems inactive."

/obj/machinery/hive_disruptor/Dispose()
	var/datum/hive_status/hive
	if(signature && signature <= hive_datum.len)
		hive = hive_datum[signature]
		hive.disrupted = 0
		hive.disruptor = null
		for(var/mob/living/carbon/Xenomorph/xeno in living_xeno_list)
			if(xeno.hivenumber == signature)
				to_chat(xeno, "<span class='xenodanger'>Disturbing noise gone...</span>")
	..()



/obj/machinery/hive_disruptor/attack_alien(mob/user as mob)
	if(!isXeno(user))
		..()
		return
	to_chat(user, "<span class='xenodanger'>With all hatred you have, you shred that heinous thing into wreckage!</span>")
	playsound(src.loc, "sound/effects/spark2.ogg", 25, 1)
	var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
	M.state = 2
	M.icon_state = "box_1"
	cdel(src)

/obj/machinery/hive_disruptor/attackby(var/obj/O as obj, var/mob/user as mob)
	if (shocked)
		shock(user,50)
	if (istype(O, /obj/item/tool/screwdriver))
		if (!opened)
			opened = 1
			to_chat(user, "You open the maintenance hatch of [src].")
			var/datum/hive_status/hive
			if(signature && signature <= hive_datum.len)
				hive = hive_datum[signature]
				hive.disrupted = 0
		else
			opened = 0
			var/datum/hive_status/hive
			if(signature && signature <= hive_datum.len)
				hive = hive_datum[signature]
				hive.disrupted = 1
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