/* Xeno RnD console from polion1232 */

//Circuits
/obj/item/circuitboard/computer/XenoRnD
	name = "Circuit board (R&D Alameyer)"
	build_path = /obj/machinery/computer/XenoRnD
	origin_tech = "programming=3" // juuuust a placehonder

/obj/item/circuitboard/machine/dissector
	name = "Circuit board (Organic dissector)"
	build_path = /obj/machinery/r_n_d/dissector
	origin_tech = "programming=3" // juuuust a placehonder

/obj/machinery/computer/XenoRnD
	name = "R&D Console"
	icon = 'icons/obj/mainframe.dmi'
	icon_state = "aimainframe"
	//icon_state = "rdcomp"  //Temp till i figure out what the shit is going on with the icon file.
	circuit = /obj/item/circuitboard/computer/XenoRnD

	var/datum/marineResearch/files							//Stores all the collected research data.
	var/obj/machinery/r_n_d/dissector/linked_dissector = null      //linked Organic Dissector

	var/screen = 1.0	//Which screen is currently showing.
	var/id = 0			//ID of the computer (for server restrictions).
	var/sync = 1		//If sync = 0, it doesn't show up on Server Control Console
	var/errored = 0		//Errored during item construction.
	var/res_in_prog = 0 //Science takes time

	req_access = list(ACCESS_MARINE_RESEARCH)


/obj/machinery/computer/XenoRnD/proc/CallTechName(var/ID) // //A simple helper proc to find the name of a tech with a given ID.
	var/datum/marineTech/tech
	var/return_name = null
	for(var/T in subtypesof(/datum/marineTech))
		tech = null
		tech = new T()
		if(tech.id == ID)
			return_name = tech.name
			cdel(tech)
			tech = null
			break

	return return_name


/obj/machinery/computer/XenoRnD/New()
	..()
	files = new /datum/marineResearch(src)

/obj/machinery/computer/XenoRnD/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any). Derived from rdconsole.dm
	for(var/obj/machinery/r_n_d/D in oview(3,src))
		if(D.linked_console != null || D.disabled || D.opened)
			continue
		if(istype(D, /obj/machinery/r_n_d/dissector))
			if(linked_dissector == null)
				linked_dissector = D
				D.linked_console = src
	return

/obj/machinery/computer/XenoRnD/Topic(href, href_list)				//Brutally teared from rdconsole.dm
	if(..())
		return

	add_fingerprint(usr)

	usr.set_interaction(src)
	if(href_list["menu"]) //Switches menu screens. Converts a sent text string into a number. Saves a LOT of code.
		var/temp_screen = text2num(href_list["menu"])
		if(temp_screen <= 1.0 || (3 <= temp_screen && 4.9 >= temp_screen) || src.allowed(usr) || emagged) //Unless you are making something, you need access.
			screen = temp_screen
		else
			to_chat(usr, "Unauthorized Access.")

	else if(href_list["reset"])
		warning("RnD console has errored during protolathe operation. Resetting.")
		errored = 0
		screen = 1.0
		updateUsrDialog()

	else if(href_list["eject_item"]) //Eject the item inside the destructive analyzer.
		if(linked_dissector)
			if(linked_dissector.busy)
				to_chat(usr, "\red The destructive analyzer is busy at the moment.")

			else if(linked_dissector.loaded_item)
				linked_dissector.loaded_item.loc = linked_dissector.loc
				linked_dissector.loaded_item = null
				linked_dissector.icon_state = "d_analyzer"
				screen = 2.1

	else if(href_list["deconstruct"]) //Deconstruct the item in the destructive analyzer and update the research holder.
		if(linked_dissector)
			if(linked_dissector.busy)
				to_chat(usr, "\red The organic dissector is busy at the moment.")
			else
				var/choice = input("Proceeding will destroy loaded item.") in list("Proceed", "Cancel")
				if(choice == "Cancel" || !linked_dissector) return
				linked_dissector.busy = 1
				screen = 0.1
				updateUsrDialog()
				flick("d_analyzer_process", linked_dissector)
				spawn(24)
					if(linked_dissector)
						linked_dissector.busy = 0
						if(!linked_dissector.loaded_item)
							to_chat(usr, "\red The organic dissector appears to be empty.")
							screen = 1.0
							return
						linked_dissector.icon_state = "d_analyzer"
						files.AddToAvail(linked_dissector.loaded_item)
						linked_dissector.loaded_item = null
						use_power(linked_dissector.active_power_usage)
						screen = 1.0
						updateUsrDialog()

	else if(href_list["lock"]) //Lock the console from use by anyone without tox access.
		if(src.allowed(usr))
			screen = text2num(href_list["lock"])
		else
			to_chat(usr, "Unauthorized Access.")

	else if(href_list["find_device"]) //The R&D console looks for devices nearby to link up with.
		screen = 0.0
		spawn(20)
			SyncRDevices()
			screen = 1.4
			updateUsrDialog()

	else if(href_list["disconnect"]) //The R&D console disconnects with a specific device.
		switch(href_list["disconnect"])
			if("dissector")
				linked_dissector.linked_console = null
				linked_dissector = null

	else if(href_list["research"])
		var/topic = text2num(href_list["research"])
		for(var/datum/marineTech/avail in files.available_tech)
			if(avail.id == topic)
				var/reser = input("Start research [avail.name]?") in list("Proceed", "Cancel")
				if(reser == "Cancel") return
				screen = 0.5
				res_in_prog = 1
				spawn(10*avail.time)
					errored = 1
					files.AvailToKnown(avail)
					res_in_prog = 0
					screen = 1.0
					errored = 0
					updateUsrDialog()
				break
	updateUsrDialog()
	return

/obj/machinery/computer/XenoRnD/attack_hand(mob/user as mob)			//Even more brutally teared off
	if(stat & (BROKEN|NOPOWER))
		return

	user.set_interaction(src)
	var/dat = ""
	switch(screen) //A quick check to make sure you get the right screen when a device is disconnected.
		if(2 to 2.9)
			if(linked_dissector == null)
				screen = 2.0
			else if(linked_dissector.loaded_item == null)
				screen = 2.1
			else
				screen = 2.2

	if(errored)
		dat += "An error has occured when constructing prototype. Try refreshing the console."
		dat += "<br>If problem persists submit bug report stating which item you tried to build."
		dat += "<br><A href='?src=\ref[src];reset=1'>RESET CONSOLE</A><br><br>"

	switch(screen)

		//////////////////////R&D CONSOLE SCREENS//////////////////
		if(0.0) dat += "Updating Database...."

		if(0.1) dat += "Dissecting in progress..."

		if(0.2)
			dat += "SYSTEM LOCKED<BR><BR>"
			dat += "<A href='?src=\ref[src];lock=1.3'>Unlock</A>"

		if(0.3)
			dat += "Constructing Prototype. Please Wait..."

		if(0.4)
			dat += "Imprinting Circuit. Please Wait..."

		if(0.5)
			dat += "Analysis in prosess. Please Wait.."

		if(1.0) //Main Menu
			dat += "Main Menu:<BR><BR>"
			dat += "<A href='?src=\ref[src];menu=1.1'>Current Available Research</A><BR>"
			dat += "<A href='?src=\ref[src];menu=1.2'>Current Research Level</A><BR><HR>"
			if(linked_dissector != null) dat += "<A href='?src=\ref[src];menu=2.2'>Organic Dissector Menu</A><BR>"
			else dat += "NO ORGANIC DISSECTOR LINKED<BR>"
			dat += "<HR><A href='?src=\ref[src];menu=1.3'>Settings</A>"

		if(1.1)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><BR><BR>"
			dat += "Active Topics:<BR><BR>"
			for(var/datum/marineTech/avail in files.available_tech)
				dat += "Topic: <A href='?src=\ref[src];research=[num2text(avail.id)]'>[CallTechName(avail.id)]</A><BR>"
				dat += "Description: [avail.desc]<BR><BR>"

		if(1.2)
			dat += "Current Research Level:<BR><BR>"
			for(var/datum/marineTech/known in files.known_tech)
				dat += "[known.name]<BR>"
				dat += "[known.desc]<BR>"
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A>"

		if(1.3) //R&D console settings
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "R&D Console Setting:<BR><BR>"
			dat += "<A href='?src=\ref[src];menu=1.4'>Device Linkage Menu</A><BR>"
			dat += "<A href='?src=\ref[src];lock=0.2'>Lock Console</A><BR>"
			dat += "<A href='?src=\ref[src];reset=1'>Reset R&D Database.</A><BR>"

		if(1.4) //R&D device linkage
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A> || "
			dat += "<A href='?src=\ref[src];menu=1.6'>Settings Menu</A><HR> "
			dat += "R&D Console Device Linkage Menu:<BR><BR>"
			dat += "<A href='?src=\ref[src];find_device=1'>Re-sync with Nearby Devices</A><BR>"
			dat += "Linked Devices:<BR>"
			if(linked_dissector)
				dat += "* Organic Dissector <A href='?src=\ref[src];disconnect=dissector'>(Disconnect)</A><BR>"
			else
				dat += "* (No Organic Dissector Linked)<BR>"


		//////////////////////Dissector Screens//////////////////
		if(2.0)
			dat += "NO ORGANIC DISSECTOR LINKED TO CONSOLE<BR><BR>"
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A>"

		if(2.1)
			dat += "No Organic Item Loaded. Standing-by...<BR><HR>"
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A>"

		if(2.2)
			dat += "<A href='?src=\ref[src];menu=1.0'>Main Menu</A><HR>"
			dat += "Dissection Menu<HR>"
			dat += "Name: [linked_dissector.loaded_item.name]<BR>"
			dat += "Topics:<BR>"
			for(var/T in linked_dissector.loaded_item.id)
				if(files.TechMakeReqInDiss(T) != 0)
					dat += "[CallTechName(T)], "
			dat += "<BR><HR><A href='?src=\ref[src];deconstruct=1'>Dissect Item</A> || "
			dat += "<A href='?src=\ref[src];eject_item=1'>Eject Item</A> || "


	user << browse("<TITLE>Research and Development Console</TITLE><HR>[dat]", "window=rdconsole;size=575x400")
	onclose(user, "rdconsole")