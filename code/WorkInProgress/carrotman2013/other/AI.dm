////////////////////////////////////
///Based on NSV-13 lore terminals///
////////////////////////////////////

////////////////////////////////////
////First the datum, then the cum///
////////////////////////////////////
var/datum/AI_term_controller/AI_term_controller = new()

datum/AI_term_controller
	var/name = "AI term controller"
	var/list/entries = list()//All the AI entries we have.

	New()
		. = ..()
		instantiate_ai_entries()

	proc/instantiate_ai_entries()
		for(var/instance in subtypesof(/datum/AI_entry))
			var/datum/AI_entry/S = new instance
			entries += S

/////////////////////////
///The terminal itself///
/////////////////////////

/obj/machinery/computer/AI_terminal
	name = "ARES terminal"
	desc = "A small CRT display with an inbuilt microcomputer which is loaded with an extensive database and allows to interact with the ship's AI. These terminals can be extremely useful."
	icon = 'code/WorkInProgress/carrotman2013/icons/computers.dmi'
	icon_state = "terminal"
	var/access_type = list() //Every subtype of this type will be readable by this console. Use this for away terms as seen here \/
	var/using = FALSE

	var/clicks
	var/loops
	var/print_time
	var/started_printing_at

	var/list/entries = list()

	var/scrollsound
	var/soundloop

/////For prof-related buttons
	var/pmc_requested = 0
	var/tried_evac = 0
	var/tried_sd = 0

/obj/machinery/computer/AI_terminal/initialize()
	. = ..()
	if(!AI_term_controller)
		new /datum/AI_term_controller()
	get_entries()
	scrollsound = list('code/WorkInProgress/carrotman2013/sounds/computer/scroll1.ogg',
					'code/WorkInProgress/carrotman2013/sounds/computer/scroll2.ogg',
					'code/WorkInProgress/carrotman2013/sounds/computer/scroll3.ogg',
					'code/WorkInProgress/carrotman2013/sounds/computer/scroll5.ogg')
	soundloop = pick(scrollsound)

/obj/machinery/computer/AI_terminal/attack_hand(mob/user)
	. = ..()
	if(using) return

	get_user_access(user)
	if(access_type == "denied")
		var/sound = pick('code/WorkInProgress/carrotman2013/sounds/computer/error.ogg','code/WorkInProgress/carrotman2013/sounds/computer/error2.ogg','code/WorkInProgress/carrotman2013/sounds/computer/error3.ogg')
		playsound(src, sound, 25, 1)
		to_chat(user, "<span class='warning'>Access denied</span>")
		return
	playsound(src, 'code/WorkInProgress/carrotman2013/sounds/computer/scroll_start.ogg', 25, 1)
	sleep(10)
	playsound(src, 'code/WorkInProgress/carrotman2013/sounds/computer/startup.ogg', 25, 1)
	user.set_interaction(src)

	var/dat
	if(!entries.len)
		get_entries()

	dat += admins.len > 0 ? "<a href='?src=\ref[src];cuscommand=InquiryAI'>>Custom Inquiry</a><br>" : "Interface unavailable<br>"

	for(var/X in entries) //Allows you to remove things individually
		var/datum/AI_entry/content = X
		if(content.access_type in src.access_type)
			dat += "<a href='?src=\ref[src];selectitem=\ref[content]'>[content.name]</a><br>"

	var/datum/browser/popup = new(user, "Interface 4835", name, 300, 500)
	popup.set_content(dat)
	popup.open()


/obj/machinery/computer/AI_terminal/Topic(href, href_list)
	if(!in_range(src, usr))
		return

	if(using)
		var/sound = 'code/WorkInProgress/carrotman2013/sounds/computer/buzz2.ogg'
		playsound(src, sound, 25, 1)
		to_chat(usr, "<span class='warning'>ERROR: I/O function busy. The data is still loading...</span>")
		return

	if(href_list["cuscommand"])
		if("InquiryAI")
			var/input = stripped_input(usr, "Warning: runtimes detected - no guarantees of a response. To abort - send an empty message.", "Interface 4835 ready for inquiry", "")
			if(!input || !(usr in view(1,src))) return FALSE
			AI_inquiry(input, usr)
			playsound(src, scrollsound, 25, 1)

	else
		var/datum/AI_entry/content = locate(href_list["selectitem"])

		clicks = length(content.content) //Split the content into characters. 1 character = 1 click

		var/dat = "<!DOCTYPE html>\
		<html>\
		<body background='https://cdn.discordapp.com/attachments/573966558548721665/612306341612093489/static.png'>\
		\
		<body onload='typeWriter()'>\
		\
		<h4>ACCESS FILE: C:/entries/[content.name]</h4>\
		<h3><i>Classification: [content.classified]</i></h3>\
		<h6>- Seegson systems inc, 2186</h6>\
		<hr style='border-top: dotted 1px;' />\
		<h2>[content.title]</h2>\
		\
		<p id='demo'></p>\
		\
		<script>\
		var i = 0;\
		var txt = \"[content.content]\";\
		var speed = 10;\
		\
		function typeWriter() {\
		  if (i < txt.length) {\
		    var char = txt.charAt(i);\
		    if (char == '`') {\
		      document.getElementById('demo').innerHTML += '<br>';\
		    }\
		    else {\
		      document.getElementById('demo').innerHTML += txt.charAt(i);\
		    }\
		    i++;\
		    setTimeout(typeWriter, speed);\
		  }\
		}\
		</script>\
		\
		\
		<style>\
		body {\
		  background-color: black;\
		  background-image: radial-gradient(\
		    rgba(0, 20, 0, 0.75), black 120%\
		  );\
		  height: 100vh;\
		  margin: 0;\
		  overflow: hidden;\
		  padding: 2rem;\
		  color: #36f891;\
		  font: 1.3rem Lucida Console, monospace;\
		  text-shadow: 0 0 5px #355732;\
		  &::after {\
		    content: '';\
		    position: absolute;\
		    top: 0;\
		    left: 0;\
		    width: 100vw;\
		    height: 100vh;\
		    background: repeating-linear-gradient(\
		      0deg,\
		      rgba(black, 0.15),\
		      rgba(black, 0.15) 1px,\
		      transparent 1px,\
		      transparent 2px\
		    );\
		    pointer-events: none;\
		  }\
		}\
		::selection {\
		  background: #0080FF;\
		  text-shadow: none;\
		}\
		pre {\
		  margin: 0;\
		}\
		</style>\
		</body>\
		</html>"
		usr << browse(dat, "window=AI_terminal[content.name];size=600x600")
		playsound(src, pick('code/WorkInProgress/carrotman2013/sounds/computer/buzz.ogg','code/WorkInProgress/carrotman2013/sounds/computer/buzz2.ogg'), 25, TRUE)
		using = TRUE //Stops you from crashing the server with infinite sounds
		icon_state = "terminal_scroll"

		//Each click sound has 4 clicks in it, so we only need to click 1/4th of the time per character yeet.
		print_time = clicks/4
		started_printing_at = world.time
		soundloop_start()


//////////////////
//////PROCS///////
//////////////////
/proc/AI_inquiry(var/text , var/mob/Sender , var/iamessage)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "\blue <b><font color=orange>AI Inquiry[iamessage ? " IA" : ""]: </font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;ccmark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;AIReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	for(var/client/C in admins)
		if((R_ADMIN|R_MOD) & C.holder.rights)
			to_chat(C, msg)
			C << sound('code/WorkInProgress/carrotman2013/sounds/computer/startup.ogg', repeat = 0, wait = 0, volume = 20)

/obj/machinery/computer/AI_terminal/proc/soundloop_start()
	while(using)
		if(world.time >= started_printing_at + print_time)
			icon_state = "terminal"
			using = FALSE
			break
		playsound(src, soundloop, 15)
		sleep(10)

/obj/machinery/computer/AI_terminal/proc/get_entries()
	for(var/datum/AI_entry/instance in AI_term_controller.entries)
		if(istype(instance))
			entries += instance


/obj/machinery/computer/AI_terminal/proc/stop_clicking()
	icon_state = "terminal"
	using = FALSE

/obj/machinery/computer/AI_terminal/proc/get_user_access(mob/user)
	if(!user.mind) return access_type = "denied"
	if(!user.mind.assigned_role) return access_type = "denied"

	if(user.mind.assigned_role == "Synthetic")
		access_type += "uscmsynth"
		access_type += "uscmcaptain"
		access_type += "uscmcommand"
		access_type += "uscmofficer"
		access_type += "W-YSpecial"
		access_type += "uscmmedical"
		access_type += "uscmpolice"
		return
////////////////
	if(user.mind.assigned_role == "Corporate Liaison")
		access_type += "W-YSpecial"
		access_type += "uscmofficer"
		return
///////////////
	if(user.mind.assigned_role == "Commander")
		access_type += "uscmcaptain"
		access_type += "uscmcommand"
		access_type += "uscmofficer"
		access_type += "uscmpolice"
		return
///////////////////
	if(user.mind.assigned_role == "Executive Officer")
		access_type += "uscmcommand"
		access_type += "uscmofficer"
		return
	if(user.mind.assigned_role == "Staff Officer")
		access_type += "uscmcommand"
		access_type += "uscmofficer"
		return
/////////////////
	if(user.mind.assigned_role == "Chief MP")
		access_type += "uscmpolice"
		access_type += "uscmcommand"
		access_type += "uscmofficer"
		return
/////////////////
	if(user.mind.assigned_role == "Chief Medical Officer")
		access_type += "uscmmedical"
		access_type += "uscmofficer"
		return
////////////////////
	if(user.mind.assigned_role == "Pilot Officer")
		access_type += "uscmofficer"
		return
	if(user.mind.assigned_role == "Tank Crewman")
		access_type += "uscmofficer"
		return
	if(user.mind.assigned_role == "Mech Operator")
		access_type += "uscmofficer"
		return
	if(user.mind.assigned_role == "Logistics Officer")
		access_type += "uscmofficer"
		return

	else
		access_type = "denied"


//////////////////////////////////
///Data that the terminal holds///
//////////////////////////////////

/datum/AI_entry
	var/name = "Document.txt" //"File display name" that the term shows (C://blah/yourfile.bmp)
	var/title = null //What it's all about
	var/classified = "Declassified" //Fluff, is this a restricted file or not?
	var/content = null //You may choose to set this here, or via a .txt. file if it's long. Newlines / Enters will break it!
	var/path = null //The location at which we're stored. If you don't have this, you don't get content
	var/access_type = "placeholder" //Set this to match the terminals that you want to be able to access it. EG "uscmcommon" for declassified shit.

/datum/AI_entry/New()
	. = ..()
	if(path)
		content = file2text("[path]")

/*

TO GET THE COOL TYPEWRITER EFFECT, I HAD TO STRIP OUT THE HTML FORMATTING STUFF.
SPECIAL KEYS RESPOND AS FOLLOWS:

` = newline (br) (AKA when you press enter)
~ = horizontal line (hr)
� = bullet point

*/

/*
Теперь заметка от карротмана.
Я поменял систему НСВ-билда, теперь игрок получает заметки в зависимости от его роли, а не весь список сразу.
*/

//////////////
///OFFICERS///
//////////////
/datum/AI_entry/officer/almayerspec
	name = "almayer_specifications.udoc"
	title = "USS Almayer Specifications"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/almayer_spec.txt"

/datum/AI_entry/officer/almayer
	name = "almayer.udoc"
	title = "USS Almayer Basics"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/almayer.txt"

/datum/AI_entry/officer/almayer_counter
	name = "almayer_countermeasures.udoc"
	title = "USS Almayer Countermeasures"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/almayer_countermeas.txt"

/datum/AI_entry/officer/almayer_sensors
	name = "almayer_sensors.udoc"
	title = "USS Almayer Sensors"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/almayer_sensors.txt"

/datum/AI_entry/officer/almayer_armament
	name = "almayer_armament.udoc"
	title = "USS Almayer Armament"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/almayer_armament.txt"


/datum/AI_entry/officer/aud25
	name = "AUD-25_dropship.udoc"
	title = "AUD-25 Dropship Basics"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/aud25.txt"

/datum/AI_entry/officer/aud25_spec
	name = "AUD-25_drop_spec.udoc"
	title = "AUD-25 Dropship Specifications"
	access_type = "uscmofficer"
	content = "Length: 31 meters`\
	Top Speed: 12 km/s at 0 kPa, 4500 m/s at 50 kPa, 450 m/s at 101 kPa, 200 m/s at 230+ kPa`\
	Crew: 1 Pilot + 36 marines + Cargo or 1 Pilot + 34 Marines + 1 Vehicle."

/datum/AI_entry/officer/aud25_counter
	name = "AUD-25_drop_counter.udoc"
	title = "AUD-25 Dropship Countermeasures"
	access_type = "uscmofficer"
	content = "RR-247 Chaff: Radar Reflective Chaff designed to counter radar homing missiles. Developed in the 2170s to counter the new generation of anti-air missiles that were arriving on colonial frontiers.`\
	`\
	MJU-77/C IR decoy: Infrared Decoy flares designed to counter IR tracking missiles. Developed alongside the UD-25 due to the hotter engines present onboard that lead to brighter IR flares."

/datum/AI_entry/officer/aud25_additional
	name = "AUD-25_drop_additional.udoc"
	title = "AUD-25 Dropship Additional Equipment"
	access_type = "uscmofficer"
	content = "ALANTIP: All Light and Atmospheric Navigational and Targeting Information Pod; the latest in ground target acquisition and navigational aids for dropships. Made to function in variety of environments ranging from barren worlds to inhabited garden worlds. Comes with a suite of various sensor systems and cameras."


/datum/AI_entry/officer/xenodanger
	name = "xeno_danger.udoc"
	title = "Xeno Alert Information"
	access_type = "uscmofficer"
	content = "Unknown alien lifeforms detected at the operation point.`\
	No detailed information specified.`\
	`\
	Danger class: Alpha.`\
	Hazard level: 7."

/datum/AI_entry/officer/WY
	name = "w-y.udoc"
	title = "Weston-Yamada"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/WY.txt"

/datum/AI_entry/officer/UPP
	name = "upp.udoc"
	title = "UPP"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/UPP.txt"

/datum/AI_entry/officer/CLF
	name = "clf.udoc"
	title = "CLF"
	access_type = "uscmofficer"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/CLF.txt"


//////////////
///POLICE/////
//////////////
/datum/AI_entry/police/crimeinfo
	name = "ACMP.uxcel"
	title = "ACPM report"
	access_type = "uscmpolice"
	content = "This file contains information, retrieved from the ACMS (Automated Crime Prevention System) at 12.00. It contains a list of possible violators presesenting onboard.`\
	The following people should be checked by the Mil1tary P0licэээээээ.`\
	`\
	###�$55%%% -=File Damaged. Error 13244.`\
	Session terminated."

/datum/AI_entry/police/hryukers
	name = "terrorist-alert.udoc"
	title = "Terrorist Activity possibile"
	access_type = "uscmpolice"
	content = "A presence of a designated terrorist group 'HRYU' was detected onboard.`\
	The following people are suspected and should be terminated incase of any illegal actions:`\
	`\
	Isaac Clarc.`\
	Michael Brown.`\
	Adrian 'Swoody' Shepard.`\
	Daniil 'Spec' Bassow.`\
	Jhonny Smith.`\
	`\
	End of the list."


//////////////
///W-Y/////
//////////////
/datum/AI_entry/WY/special
	name = "W-Y_special_orders.uxldat"
	title = "W-Y Special Orders"
	access_type = "W-YSpecial"
	content = "No specific orders detected.`\
	No specific information provided.`\
	Standart Operating Procedures applied."


//////////////
///SYNTHS/////
//////////////
/datum/AI_entry/synth/special
	name = "synth-special_orders.uxldat"
	title = "USCM Special Orders"
	access_type = "uscmsynth"
	content = "No specific orders detected.`\
	No specific information provided.`\
	Standart Operating Procedures applied."

/datum/AI_entry/synth/predators
	name = "bioscan_special_info.uldat"
	title = "Xeno Alert Information"
	access_type = "uscmsynth"
	content = "Attention. Restricted information. Synth special. Crew is prohibited from notification.`\
	Presence of a second unknown lifeform detected during the last bioscan.`\
	No detailed information specified on the organisms.`\
	`\
	Danger class: Unknown.`\
	Hazard level: Unknown."


//////////////
///MEDICAL/////
//////////////
/datum/AI_entry/medical/hazard
	name = "xeno-haz_medical_special.ulrep"
	title = "Xeno Hazard. Medical information."
	access_type = "uscmmedical"
	content = "Xeno-hazard can be extremely dangerous for the crew.`\
	`\
	30% of known alien lifeforms have parasitic breeding methods. This should be taken in consideration, incase something unpredictable happens during the mission.`\
	`\
	Incase of the lifeforms pervading the ship: medical department should prepare for class-3 quarantine protocols."


//Au-25_dropship.udoc