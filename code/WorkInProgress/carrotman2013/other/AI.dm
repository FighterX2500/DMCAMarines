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
	var/access_type  //Every subtype of this type will be readable by this console. Use this for away terms as seen here \/
	var/using = FALSE

	var/clicks
	var/loops
	var/print_time
	var/started_printing_at

	var/list/entries = list()

	var/scrollsound
	var/soundloop

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
	get_user_access(user)
	if(access_type == "denied")
		var/sound = pick('code/WorkInProgress/carrotman2013/sounds/computer/error.ogg','code/WorkInProgress/carrotman2013/sounds/computer/error2.ogg','code/WorkInProgress/carrotman2013/sounds/computer/error3.ogg')
		playsound(src, sound, 25, 1)
		to_chat(user, "<span class='warning'>Access denied</span>")
		return
	playsound(src, 'code/WorkInProgress/carrotman2013/sounds/computer/scroll_start.ogg', 25, 1)
	user.set_interaction(src)

	var/dat
	if(!entries.len)
		get_entries()
	for(var/X in entries) //Allows you to remove things individually
		var/datum/AI_entry/content = X
		if(content.access_type == src.access_type)
			dat += "<a href='?src=\ref[src];selectitem=\ref[content]'>[content.name]</a><br>"

	dat += admins.len > 0 ? "<a href='?src=\ref[src];operation=InquiryAI'>Inquiry</a><br>" : "Interface unavailable<br>"

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

	if(href_list["operation"])
		if("InquiryAI")
			var/input = stripped_input(usr, "Warning: runtimes detected - no guarantees of a response. To abort - send an empty message.", "Interface 4835 ready for inquiry", "")
			if(!input || !(usr in view(1,src))) return FALSE
			AI_inquiry(input, usr)

	else
		var/datum/AI_entry/content = locate(href_list["selectitem"])

		clicks = length(content.content) //Split the content into characters. 1 character = 1 click

		var/dat = "<!DOCTYPE html>\
		<html>\
		<body background='https://cdn.discordapp.com/attachments/573966558548721665/612306341612093489/static.png'>\
		\
		<body onload='typeWriter()'>\
		\
		<h4>ACCESS FILE: C:/entries/local/[content.name]</h4>\
		<h3><i>Classification: [content.classified]</i></h3>\
		<h6>- � Seegson systems inc, 2257</h6>\
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

		loops = clicks/4 //Each click sound has 4 clicks in it, so we only need to click 1/4th of the time per character yeet.
		print_time = loops
		started_printing_at = world.time
		soundloop_start()


//////////////////
//////PROCS///////
//////////////////
/proc/AI_inquiry(var/text , var/mob/Sender , var/iamessage)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "\blue <b><font color=orange>AI Inquiry[iamessage ? " IA" : ""]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;ccmark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;AIReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
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
		playsound(src, soundloop, 25)
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
		access_type = "uscmsynth"
		return
	if(user.mind.assigned_role == "Corporate Liaison")
		access_type = "W-YSpecial"
		return
	///////////////
	if(user.mind.assigned_role == "Chief Medical Officer")
		access_type = "uscmmedical"
		return

	///////////////
	if(user.mind.assigned_role == "Commander")
		access_type = "uscmcaptain"
		return

	if(user.mind.assigned_role == "Executive Officer")
		access_type = "uscmcommand"
		return
	if(user.mind.assigned_role == "Staff Officer")
		access_type = "uscmcommand"
		return

	if(user.mind.assigned_role == "Pilot Officer")
		access_type = "uscmofficer"
		return
	if(user.mind.assigned_role == "Tank Crewman")
		access_type = "uscmofficer"
		return
	if(user.mind.assigned_role == "Mech Operator")
		access_type = "uscmofficer"
		return
	if(user.mind.assigned_role == "Logistics Officer")
		access_type = "uscmofficer"
		return

	///////////////
	if(user.mind.assigned_role == "Chief MP")
		access_type = "uscmpolice"
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

/datum/AI_entry/nt
	name = "new_employees_memo.ntmail"
	title = "Intercepted message"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/welcome.txt"
	access_type = "uscmcaptain"

/datum/AI_entry/nt/ragnarok
	name = "ragnarok_class.ntdoc"
	title = "Ragnarok Class Specifications"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/ragnarok.txt"
	access_type = "uscmcaptain"

/datum/AI_entry/nt/firing_proceedure
	name = "firing_proceedure.ntdoc"
	title = "Ship-to-ship munitions"
	access_type = "awayexample"
	path = "code/WorkInProgress/carrotman2013/other/AI_entries/firing_proceedure.txt"

/datum/AI_entry/nt/stormdrive_operation
	name = "stormdrive_operation.ntdoc"
	title = "Setting up power"
	path = null
	access_type = "awayexample"
	content = "-Activate constrictors with an open hand ` -Open 'plasma input' valves to constrictors and set their pressure to 'MAX' ` -Assemble particle accelerator with a wrench, coil of wire and screwdriver. ` -Open reactor inlet valves and set their pressure to 'MAX'` `-Use the particle accelerator control console, set the setting to '2' and toggle its power `-When you have successfully started the reactor, it will begin emitting cherenkov radiation, giving off a 'blue glow' around the core. When the reactor is activated, turn off the particle accelerator to prevent power waste. `-It is recommended that engineers use control rod setting '2' for optimal power generation, however the control rods are not rated to withstand temperatures of over 200 degrees for long, and will thus require reinforcement with sheets of plasteel. ` If fuel fails to fill into the reactor, a backpressure surge has occurred. Turn off all inputs to the reactor and open the waste release valve with the reactor console to flush any air out of the system. When this is done, close the valve again and re-enable fuel supplies."

/datum/AI_entry/nt/meltdown_proceedures
	name = "meltdown_proceedures.ntmail"
	title = "Emergency proceedures regarding nuclear meltdowns:"
	path = null
	access_type = "awayexample"
	content = "SYSADMIN -> Allcrew@seegnet.nt. RE: Emergency Meltdown proceedures. ` The nuclear storm drive is an inherently safe engine, however this does not mean it is foolproof. Dilligence will mean the difference between having a safe, reliable power output which can last for decades, and a nuclear hellfire which can destroy the entire ship. `What to do during a meltdown: `-A reactor will melt down when the fission inside it produces an uncontrollable amount of heat (in excess of 300 degrees celsius). If this ever happens, a shipwide alarm will sound. If you hear this alarm, you must act quickly and calmly, as you will have approximately 1 - 2 minutes before the reactor explodes. `-To avert meltdown, simply locate the control console, and choose the 'SCRAM' setting (the button labelled AZ-5). This will immediately lower all control rods and attempt to cool the reactor. `-In the event of damaged control rods, IMMEDIATELY shut off all plasma constrictors, supply pumps and filters and evacuate the engineering section IMMEDIATELY to prevent unecessary loss of life. `-As a meltdown occurs, nuclear fuel is deposited all over the ship, and must be cleaned up with a shovel. This spent fuel is HIGHLY radioactive, and must be handled with extreme care. If the unthinkable comes to pass, instruct crew to seek shelter in maintenance and proceed to immediately evacuate the ship. To avoid complications, it is recommended that engineers equip radiation proof suits and gas masks, and proceed to clear a path to the evacuation arm with shovels. Remember: Stay safe through vigilance!"

/datum/AI_entry/nt/ship_weapon_maintenance
	name = "weapon_maintenance_proceedure.ntmail"
	title = "Ship-to-ship weapons maintenance and YOU"
	path = null
	access_type = "awayexample"
	content = "SYSADMIN -> Munitions@seegnet.nt. RE: Weapons Maintenance ` ATTENTIVE SHIP SYSTEM MAINTENANCE STARTS WITH YOU ` All primary ship-to-ship offensive weapons, including torpedo tubes and railguns require regular maintenance from skilled workers to remain in an optimal state. ` Reminder: Before commencing any maintenance on ship weaponry, ensure all relevant safety systems are engaged and the weapon is not loaded. ` -Unscrew the maintenance hatch on the primary external casing ` -Unbolt the internal maintenance panel ` -Use a crowbar to carefully lever out the internal panel ` -Apply 10 units of Oil to the exposed internal machinery ` -Replace and bolt the panel, fix the hatch back in place ` IF MAINTENANCE IS NOT PERFORMED REGULARLY, FAILURE COULD OCCUR DURING COMBAT, LEADING TO THE INJURY AND/OR DEATH OF YOURSELF AND OTHER CREW"


/datum/AI_entry/nt/fighter_maintenance
	name = "fighter_maintenance.ntmail"
	title = "FW: RE: How the frack do you put these hunks of junk into maintenance mode?"
	path = null
	access_type = "awayexample"
	content = "MAAMASTER -> Munitions@seegnet.nt FW: RE: How the FRACK? `Attention MAAs Fleetwide, it has come to our attention your underlings may have trouble remembering simple maintenance cycle proceedures, please foward them this message as a reminder.` `--------------------------------` `FORWARDED MESSAGE` `--------------------------------` `REDACTED@seegnet.nt -> REDACTED@seegnet.net How the FRACK?` `Hey, can you help me out big time?` `I know these fancy new fighters are supposed to have some sort of special maintenance mode that lets you access all of its components and stuff, but I can't work out how the FRACK you are supposed to make it do its thing.` `PLEASE HELP ME!` `Boss will literally lynch me if I don't get this done by the time he's back.` `--------------------------------` `REDACTED@seegnet.nt -> REDACTED@seegnet.net RE:How the FRACK?` `Let me break this down for you:` `First locate the maintenance panel on the belly of the fighter, yes you have to crawl under it, take a wrench and a crowbar with you.` `Second unbolt the panel, just don't lose the nuts otherwise you are toast.` `Third slide back the maintenance panel, this should kick the fighter to go into maintenance mode, use a crowbar for leverage if it gets stuck.` `Reverse the process to reset it into flight mode at the end, simple, yes?`"

/datum/AI_entry/nt/fighter_production
	name = "fighter_production.ntdoc"
	title = "Production and Assembly of Fighter Craft 101"
	path = null
	access_type = "awayexample"
	content = "Welcome to the NT Guide for Production and Assembly of Fighter Craft 101 `This step by step guide will familiarise you with the process of producing fighter craft components and assembling them into a serviceable fighter for the NT fleet.` `WORD OF CAUTION: This proceedure requires cooperation from several departments.` `EXTRA WORD OF CAUTION: Spreading of rumours regarding this proceedure will lead to personal redaction of REDACTED` `@#g#!&40((%%%% -=FILE CORRUPTION DETECTED=- Let me make this simpler for you to read. ~PMV` `Start by ensuring the research division of your assigned vessel has the latest and most up to date blueprints available.` `Generate a requision request for required components (APPENDIX A) and deliver it to cargo for fabrication.` `Await requision delivery at arranged location.` `` `Step by step assembly proccedure follows:` `-Open and assemble Fighter Fuselage.` `-Wrench bolts on Fighter Fuselage.` `-Weld joints together on Fighter Fuselage.` `-Locate and attach Fighter Empennage.` `-Wrench bolts on Fighter Empennage.` `-Weld joints together on Fighter Empennage.` `-Locate and attach first Fighter Wing.` `-Wrench bolts on Fighter Wing.` `-Weld joints together on Fighter Wing.` `-Locate and attach second Fighter Wing.` `-Wrench bolts on Fighter Wing.` `-Weld joints together on Fighter Wing.` `-Locate and install Fighter Landing Gear.` `-Wrench bolts on Fighter Landing Gear.` `-Locate and install Fighter Armour Plating.` `-Screw Fighter Armour Plating in place.` `-Weld joints on Fighter Armour Plating.` `-Install wiring into the Fighter.` `-Calibrate wiring with Multitool.` `-Locate and install Fighter Fuel Tank.` `-Wrench bolts on Fighter Fuel Tank.` `-Locate and install Fighter Fuel Lines.` `-Wrench bolts on Fighter Fuel Lines.` `-Locate and install first Fighter Engine.` `-Weld joints on Fighter Engine.` `-Locate and install second Fighter Engine.` `-Calibrate both Fighter Engines with a multitool.` `-Locate and install Fighter Cockpit.` `-Screw Fighter Cockpit in place.` `-Wrench bolts on Fighter Cockpit.` `-Install additional wiring into the Fighter.` `-Locate and install Fighter Avionics.` `-Screw the Fighter Avionics in place.` `-Calibrate the Fighter Avionics with a multitool.` `-Locate and install Fighter Targeting Sensors.` `-Screw the Fighter Targeting Sensors in place.` `-Calibrate the Fighter Targeting Sensors with a multitool.` `-Apply paint scheme of choice for the Fighter.` `-Choose a name for the Fighter.` `` `Your new fighter should now be complete.` `Enter maintenance mode to install ship ordinance, make repairs and refuel the vessel.` `____________` `APPENDIX A` `____________` `Fighter Components:` `-Fighter Fuselage Components Crate x1` `-Fighter Cockpit Components Box x1` `-Fighter Wing Components Box x2` `-Fighter Empennage Components Box x1` `-Fighter Landing Gear Components Box x1` `-Fighter Armour Plating x1` `-Fighter Fuel Tank x1` `-Fighter Avionics x1` `-Fighter Targeting Sensors x1` `-Fighter Fuel Line Kit x1` `-Fighter Engine x2`"

/datum/AI_entry/nt/fighters
	name = "fighter_operations.ntdoc"
	title = "Fighter operational proceedures"
	path = null
	access_type = "awayexample"
	content = "Pre flight checklist:`\
	Hit ignition switch`\
	Fuel pump switch`\
	Engage battery`\
	Engage APU`\
	Disengage throttle lock`\
	Throttle up VERY gently with brakes on so that engine takes over but you're still not moving.`\
	Lock canopy to avoid hazardous space exposure`\
	APU will automatically suspend, you are now flight ready.```\
	-------------------`\
	Shutdown sequence:`\
	Throttle off + brakes on`\
	Throttle lock on`\
	Disengage battery`\
	Disengage fuel pump (or engine gets flooded)`\
	Turn off ignition```\
	Vipers, Raptors and other small fighter craft run off of Tyrosene. This is standard fuel that's been enriched with extra hydrocarbons.`\
	If you run out of fuel:`\
	Activate the brakes and begin a shutdown of your fighter. Once you have received more fuel, begin startup sequence as expected. If you run out of fuel, you will be stuck adrift. It is highly recommended that you RTB when you hit 100 fuel as you'll have 30 seconds or so more burn time before you fizzle out.`\
	Tyrosene production:`\
	1 part hydrogen : 1 part carbon to make hydrocarbon heated to 333K. Mix hydrocarbon and welding fuel to produce tyrosene fuel and apply to tyrosene fuel tanks to allow for fighter refuel ops."

/datum/AI_entry/away_example
	title = "Intercepted log file"
	access_type = "awayexample"

/datum/AI_entry/away_example/pilot_log
	name = "pilot_log.txt"
	content = "They're coming in hot! Prepare for flip and bur']###�$55%%% -=File Access Terminated=-"
	access_type = "awayexample"

/datum/AI_entry/away_example/weapons_log
	name = "weapon_systems_dump2259/11/25.txt"
	content = "Life support systems terminated. Railgun system status: A6E3. Torpedo system status: ~@##6#6#^^6 -=File Access Terminated=-"
	access_type = "awayexample"