/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/



/area
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1

	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = AREAS_LAYER
	mouse_opacity = 0
	invisibility = INVISIBILITY_LIGHTING
	var/lightswitch = 1

	var/flags_alarm_state = NOFLAGS

	var/debug = 0
	var/powerupdate = 10		//We give everything 10 ticks to settle out it's power usage.
	var/requires_power = 1
	var/unlimited_power = 0
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/has_gravity = 1
	var/list/apc = list()
	var/list/area_machines = list() // list of machines only for master areas
	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = list()		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/air_doors_activated = 0
	var/list/ambience = list('sound/ambience/ambigen1.ogg','sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambigen14.ogg')

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

/hook/startup/proc/setupTeleportLocs()
	for(var/area/AR in all_areas)
		if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1 || picked.z == MAIN_SHIP_Z_LEVEL)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	teleportlocs = sortList(teleportlocs)

	return 1

var/list/ghostteleportlocs = list()

/hook/startup/proc/setupGhostTeleportLocs()
	for(var/area/AR in all_areas)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/turret_protected/aisat) || istype(AR, /area/tdome) || istype(AR, /area/shuttle/specops/centcom))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1 || picked.z == 3 || picked.z == 4 || picked.z == 5)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	ghostteleportlocs = sortList(ghostteleportlocs)

	return 1

/*-----------------------------------------------------------------------------*/
/area/space
	name = "Space"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = list('sound/ambience/ambispace.ogg')
	temperature = TCMB
	pressure = 0

/area/engine/
	ambience = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')
/area/turret_protected/

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"



//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.

/area/shuttle //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

/area/shuttle/arrival
	name = "abandoned  Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

/area/shuttle/escape
	name = "abandoned  Emergency Shuttle"
	music = "music/escape.ogg"

/area/shuttle/escape/station
	name = "abandoned  Emergency Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	name = "abandoned  Emergency Shuttle Centcom"
	icon_state = "shuttle"

/area/shuttle/escape/transit // the area to pass through for 3 minute transit
	name = "abandoned  Emergency Shuttle Transit"
	icon_state = "shuttle"

/area/shuttle/escape_pod1
	name = "Escape Pod One"
	music = "music/escape.ogg"

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod1/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod2
	name = "Escape Pod Two"
	music = "music/escape.ogg"

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod2/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod3
	name = "Escape Pod Three"
	music = "music/escape.ogg"

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod3/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod5 //Pod 4 was lost to meteors
	name = "Escape Pod Five"
	music = "music/escape.ogg"

/area/shuttle/escape_pod5/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod5/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod5/transit
	icon_state = "shuttle"

/area/shuttle/mining
	name = "abandoned Mining Shuttle"
	music = "music/escape.ogg"

/area/shuttle/mining/station
	icon_state = "shuttle2"

/area/shuttle/mining/outpost
	icon_state = "shuttle"

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "abandoned  Transport Shuttle Centcom"

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "abandoned  Transport Shuttle"
/*
/area/shuttle/alien/base
	icon_state = "shuttle"
	name = "abandoned  Alien Shuttle Base"
	requires_power = 1
	luminosity = 0
	lighting_use_dynamic = 1

/area/shuttle/alien/mine
	icon_state = "shuttle"
	name = "abandoned  Alien Shuttle Mine"
	requires_power = 1
	luminosity = 0
	lighting_use_dynamic = 1
*/


/area/shuttle/prison/
	name = "abandoned  Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/prison
	icon_state = "shuttle2"

/area/shuttle/specops/centcom
	name = "abandoned  Special Ops Shuttle"
	icon_state = "shuttlered"

/area/shuttle/specops/station
	name = "abandoned  Special Ops Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/syndicate_elite/mothership
	name = "abandoned  Syndicate Elite Shuttle"
	icon_state = "shuttlered"

/area/shuttle/syndicate_elite/station
	name = "abandoned  Syndicate Elite Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/administration/centcom
	name = "abandoned  Administration Shuttle Centcom"
	icon_state = "shuttlered"

/area/shuttle/administration/station
	name = "abandoned  Administration Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/thunderdome
	name = "honk"

/area/shuttle/thunderdome/grnshuttle
	name = "abandoned  Thunderdome GRN Shuttle"
	icon_state = "green"

/area/shuttle/thunderdome/grnshuttle/dome
	name = "abandoned  GRN Shuttle"
	icon_state = "shuttlegrn"

/area/shuttle/thunderdome/grnshuttle/station
	name = "abandoned  GRN Station"
	icon_state = "shuttlegrn2"

/area/shuttle/thunderdome/redshuttle
	name = "abandoned  Thunderdome RED Shuttle"
	icon_state = "red"

/area/shuttle/thunderdome/redshuttle/dome
	name = "abandoned  RED Shuttle"
	icon_state = "shuttlered"

/area/shuttle/thunderdome/redshuttle/station
	name = "abandoned  RED Station"
	icon_state = "shuttlered2"
// === Trying to remove these areas:
/*
/area/shuttle/research
	name = "abandoned  Research Shuttle"
	music = "music/escape.ogg"

/area/shuttle/research/station
	icon_state = "shuttle2"

/area/shuttle/research/outpost
	icon_state = "shuttle"
*/
/area/shuttle/vox/station
	name = "abandoned  Vox Skipjack"
	icon_state = "yellow"
	requires_power = 0

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0
	has_gravity = 1

// === end remove
/*
/area/alien
	name = "abandoned  Alien base"
	icon_state = "yellow"
	requires_power = 0
*/
// CENTCOM

/area/centcom
	name = "abandoned  Centcom"
	icon_state = "centcom"
	requires_power = 0

/area/centcom/control
	name = "abandoned  Centcom Control"

/area/centcom/evac
	name = "abandoned  Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "abandoned  Centcom Supply Shuttle"

/area/centcom/ferry
	name = "abandoned  Centcom Transport Shuttle"

/area/centcom/shuttle
	name = "abandoned  Centcom Administration Shuttle"

/area/centcom/test
	name = "abandoned  Centcom Testing Facility"

/area/centcom/living
	name = "abandoned  Centcom Living Quarters"

/area/centcom/specops
	name = "abandoned  Centcom Special Ops"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/holding
	name = "abandoned  Holding Facility"

/area/centcom/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

//SYNDICATES

/area/syndicate_mothership
	name = "abandoned  Syndicate Base"
	icon_state = "syndie-ship"
	requires_power = 0
	unlimited_power = 1

/area/syndicate_mothership/control
	name = "abandoned  Syndicate Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "abandoned  Syndicate Elite Squad"
	icon_state = "syndie-elite"

//EXTRA

/area/asteroid					// -- TLE
	name = "abandoned  Asteroid"
	icon_state = "asteroid"
	requires_power = 0

/area/asteroid/cave				// -- TLE
	name = "abandoned  Asteroid - Underground"
	icon_state = "cave"
	requires_power = 0

/area/asteroid/artifactroom
	name = "abandoned  Asteroid - Artifact"
	icon_state = "cave"














/*
/area/planet/clown
	name = "abandoned  Clown Planet"
	icon_state = "honk"
	requires_power = 0
*/
/area/tdome
	name = "abandoned  Thunderdome"
	icon_state = "thunder"
	requires_power = 0

/area/tdome/tdome1
	name = "abandoned  Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "abandoned  Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "abandoned  Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "abandoned  Thunderdome (Observer.)"
	icon_state = "purple"

/area/deathmatch
	name = "\improper End of Round Deathmatch Arena"
	icon_state = "green"
	requires_power = 0

//ENEMY

//names are used
/area/syndicate_station
	name = "abandoned  Syndicate Station"
	icon_state = "yellow"
	requires_power = 0
	unlimited_power = 1

/area/syndicate_station/start
	name = "abandoned  Syndicate Forward Operating Base"
	icon_state = "yellow"

/area/syndicate_station/southwest
	name = "abandoned  south-west of SS13"
	icon_state = "southwest"

/area/syndicate_station/northwest
	name = "abandoned  north-west of SS13"
	icon_state = "northwest"

/area/syndicate_station/northeast
	name = "abandoned  north-east of SS13"
	icon_state = "northeast"

/area/syndicate_station/southeast
	name = "abandoned  south-east of SS13"
	icon_state = "southeast"

/area/syndicate_station/north
	name = "abandoned  north of SS13"
	icon_state = "north"

/area/syndicate_station/south
	name = "abandoned  south of SS13"
	icon_state = "south"

/area/syndicate_station/commssat
	name = "abandoned  south of the communication satellite"
	icon_state = "south"

/area/syndicate_station/mining
	name = "abandoned  north east of the mining asteroid"
	icon_state = "north"

/area/syndicate_station/transit
	name = "abandoned  hyperspace"
	icon_state = "shuttle"

/area/wizard_station
	name = "abandoned  Wizard's Den"
	icon_state = "yellow"
	requires_power = 0

/area/vox_station/transit
	name = "abandoned  hyperspace"
	icon_state = "shuttle"
	requires_power = 0

/area/vox_station/southwest_solars
	name = "abandoned  aft port solars"
	icon_state = "southwest"
	requires_power = 0

/area/vox_station/northwest_solars
	name = "abandoned  fore port solars"
	icon_state = "northwest"
	requires_power = 0

/area/vox_station/northeast_solars
	name = "abandoned  fore starboard solars"
	icon_state = "northeast"
	requires_power = 0

/area/vox_station/southeast_solars
	name = "abandoned  aft starboard solars"
	icon_state = "southeast"
	requires_power = 0

/area/vox_station/mining
	name = "abandoned  nearby mining asteroid"
	icon_state = "north"
	requires_power = 0

//PRISON
/*
/area/prison
	name = "abandoned  Prison Station"
	icon_state = "brig"

/area/prison/arrival_airlock
	name = "abandoned  Prison Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "abandoned  Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "abandoned  Prison Security Quarters"
	icon_state = "security"

/area/prison/rec_room
	name = "abandoned  Prison Rec Room"
	icon_state = "green"

/area/prison/closet
	name = "abandoned  Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "abandoned  Prison Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "abandoned  Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "abandoned  Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "abandoned  Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "abandoned  Prison Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "abandoned  Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "abandoned  Prison Medbay"
	icon_state = "medbay"

/area/prison/solar
	name = "abandoned  Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "abandoned  Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "abandoned  Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

//STATION13

/area/atmos
 	name = "Atmospherics"
 	icon_state = "atmos"
*/
//Maintenance

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/atmos_control
	name = "Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint
	name = "Fore Port Maintenance - 1"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Fore Port Maintenance - 2"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance - 1"
	icon_state = "fsmaint"

/area/maintenance/fsmaint2
	name = "Fore Starboard Maintenance - 2"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/engi_shuttle
	name = "Engineering Shuttle Access"
	icon_state = "maint_e_shuttle"

/area/maintenance/engi_engine
	name = "Engine Maintenance"
	icon_state = "maint_engine"

/area/maintenance/asmaint2
	name = "Science Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Cargo Maintenance"
	icon_state = "apmaint"

/area/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/arrivals
	name = "Arrivals Maintenance"
	icon_state = "maint_arrivals"

/area/maintenance/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"

/area/maintenance/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/evahallway
	name = "abandoned  EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/dormitory
	name = "Dormitory Maintenance"
	icon_state = "maint_dormitory"

/area/maintenance/incinerator
	name = "abandoned  Incinerator"
	icon_state = "disposal"

/area/maintenance/locker
	name = "Locker Room Maintenance"
	icon_state = "maint_locker"

/area/maintenance/medbay
	name = "Medbay Maintenance"
	icon_state = "maint_medbay"

/area/maintenance/research_port
	name = "Port Research Maintenance"
	icon_state = "maint_research_port"

/area/maintenance/research_starboard
	name = "Starboard Research Maintenance"
	icon_state = "maint_research_starboard"

/area/maintenance/research_shuttle
	name = "Research Shuttle Dock Maintenance"
	icon_state = "maint_research_shuttle"

/area/maintenance/security_port
	name = "Port Security Maintenance"
	icon_state = "maint_security_port"

/area/maintenance/security_starboard
	name = "Starboard Security Maintenance"
	icon_state = "maint_security_starboard"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

// SUBSTATIONS (Subtype of maint, that should let them serve as shielded area during radstorm)


/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"

/area/maintenance/substation/engineering // Probably will be connected to engineering SMES room, as wires cannot be crossed properly without them sharing powernets.
	name = "Engineering Substation"

/area/maintenance/substation/medical_science // Medbay and Science. Each has it's own separated machinery, but it originates from the same room.
	name = "Medical Research Substation"

/area/maintenance/substation/civilian_east // Bar, kitchen, dorms, ...
	name = "Civilian East Substation"

/area/maintenance/substation/civilian_west // Cargo, PTS, locker room, probably arrivals, ...)
	name = "Civilian West Substation"

/area/maintenance/substation/command // AI and central cluster. This one will be between HoP office and meeting room (probably).
	name = "Command Substation"

/area/maintenance/substation/security // Security, Brig, Permabrig, etc.
	name = "Security Substation"




//Hallway

/area/hallway/primary/fore
	name = "abandoned  Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "abandoned  Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "abandoned  Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "abandoned  Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central_one
	name = "abandoned  Central Primary Hallway"
	icon_state = "hallC1"
	ambience = list('sound/ambience/signal.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg')

/area/hallway/primary/central_two
	name = "abandoned  Central Primary Hallway"
	icon_state = "hallC2"

/area/hallway/primary/central_three
	name = "abandoned  Central Primary Hallway"
	icon_state = "hallC3"

/area/hallway/secondary/exit
	name = "abandoned  Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/construction
	name = "abandoned  Construction Area"
	icon_state = "construction"

/area/hallway/secondary/entry
	name = "abandoned  Arrival Shuttle Hallway"
	icon_state = "entry"

//Command

/area/bridge
	name = "abandoned  Bridge"
	icon_state = "bridge"
	music = "signal"

/area/bridge/meeting_room
	name = "abandoned  Heads of Staff Meeting Room"
	icon_state = "bridge"
	music = null

/area/crew_quarters/captain
	name = "abandoned  Captain's Office"
	icon_state = "captain"

/area/crew_quarters/heads/hop
	name = "abandoned  Head of Personnel's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hor
	name = "abandoned  Research Director's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/chief
	name = "abandoned  Chief Engineer's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hos
	name = "abandoned  Head of Security's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/cmo
	name = "abandoned  Chief Medical Officer's Office"
	icon_state = "head_quarters"

/area/crew_quarters/courtroom
	name = "abandoned  Courtroom"
	icon_state = "courtroom"

/area/mint
	name = "abandoned  Mint"
	icon_state = "green"

/area/comms
	name = "abandoned  Communications Relay"
	icon_state = "tcomsatcham"

/area/server
	name = "abandoned  Messaging Server Room"
	icon_state = "server"

//Crew

/area/crew_quarters
	name = "abandoned  Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/toilet
	name = "abandoned  Dormitory Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep
	name = "abandoned  Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/engi
	name = "abandoned  Engineering Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/engi_wash
	name = "abandoned  Engineering Washroom"
	icon_state = "toilet"

/area/crew_quarters/sleep/sec
	name = "abandoned  Security Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/bedrooms
	name = "abandoned  Dormitory Bedroom"
	icon_state = "Sleep"

/area/crew_quarters/sleep/cryo
	name = "abandoned  Cryogenic Storage"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male
	name = "abandoned  Male Dorm"
	icon_state = "Sleep"
/*
/area/crew_quarters/sleep_male/toilet_male
	name = "abandoned  Male Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep_female
	name = "abandoned  Female Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_female/toilet_female
	name = "abandoned  Female Toilets"
	icon_state = "toilet"
*/
/area/crew_quarters/locker
	name = "abandoned  Locker Room"
	icon_state = "locker"

/area/crew_quarters/locker/locker_toilet
	name = "abandoned  Locker Toilets"
	icon_state = "toilet"

/area/crew_quarters/fitness
	name = "abandoned  Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/cafeteria
	name = "abandoned  Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "abandoned  Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/bar
	name = "abandoned  Bar"
	icon_state = "bar"

/area/crew_quarters/theatre
	name = "abandoned  Theatre"
	icon_state = "Theatre"

/area/library
 	name = "abandoned  Library"
 	icon_state = "library"

/area/chapel/main
	name = "abandoned  Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg')

/area/chapel/office
	name = "abandoned  Chapel Office"
	icon_state = "chapeloffice"

/area/lawoffice
	name = "abandoned  Internal Affairs"
	icon_state = "law"







/area/holodeck
	name = "abandoned  Holodeck"
	icon_state = "Holodeck"
	luminosity = 1
	lighting_use_dynamic = 0

/area/holodeck/alphadeck
	name = "abandoned  Holodeck Alpha"


/area/holodeck/source_plating
	name = "abandoned  Holodeck - Off"
	icon_state = "Holodeck"

/area/holodeck/source_emptycourt
	name = "abandoned  Holodeck - Empty Court"

/area/holodeck/source_boxingcourt
	name = "abandoned  Holodeck - Boxing Court"

/area/holodeck/source_basketball
	name = "abandoned  Holodeck - Basketball Court"

/area/holodeck/source_thunderdomecourt
	name = "abandoned  Holodeck - Thunderdome Court"

/area/holodeck/source_beach
	name = "abandoned  Holodeck - Beach"
	icon_state = "Holodeck" // Lazy.

/area/holodeck/source_burntest
	name = "abandoned  Holodeck - Atmospheric Burn Test"

/area/holodeck/source_wildlife
	name = "abandoned  Holodeck - Wildlife Simulation"

/area/holodeck/source_meetinghall
	name = "abandoned  Holodeck - Meeting Hall"

/area/holodeck/source_theatre
	name = "abandoned  Holodeck - Theatre"

/area/holodeck/source_picnicarea
	name = "abandoned  Holodeck - Picnic Area"

/area/holodeck/source_snowfield
	name = "abandoned  Holodeck - Snow Field"

/area/holodeck/source_desert
	name = "abandoned  Holodeck - Desert"

/area/holodeck/source_space
	name = "abandoned  Holodeck - Space"











//Engineering

/area/engine

	drone_fabrication
		name = "abandoned  Drone Fabrication"
		icon_state = "engine"

	engine_smes
		name = "Engineering SMES"
		icon_state = "engine_smes"
//		requires_power = 0//This area only covers the batteries and they deal with their own power

	engine_room
		name = "abandoned  Engine Room"
		icon_state = "engine"

	engine_airlock
		name = "abandoned  Engine Room Airlock"
		icon_state = "engine"

	engine_monitoring
		name = "abandoned  Engine Monitoring Room"
		icon_state = "engine_monitoring"

	engine_waste
		name = "abandoned  Engine Waste Handling"
		icon_state = "engine_waste"

	engineering_monitoring
		name = "abandoned  Engineering Monitoring Room"
		icon_state = "engine_monitoring"

	atmos_monitoring
		name = "abandoned  Atmospherics Monitoring Room"
		icon_state = "engine_monitoring"

	engineering
		name = "Engineering"
		icon_state = "engine_smes"

	engineering_foyer
		name = "abandoned  Engineering Foyer"
		icon_state = "engine"

	break_room
		name = "abandoned  Engineering Break Room"
		icon_state = "engine"

	hallway
		name = "abandoned  Engineering Hallway"
		icon_state = "engine_hallway"

	engine_hallway
		name = "abandoned  Engine Room Hallway"
		icon_state = "engine_hallway"

	engine_eva
		name = "abandoned  Engine EVA"
		icon_state = "engine_eva"

	engine_eva_maintenance
		name = "abandoned  Engine EVA Maintenance"
		icon_state = "engine_eva"

	workshop
		name = "abandoned  Engineering Workshop"
		icon_state = "engine_storage"

	locker_room
		name = "abandoned  Engineering Locker Room"
		icon_state = "engine_storage"


//Solars

/area/solar
	requires_power = 1
	always_unpowered = 1
	luminosity = 1
	lighting_use_dynamic = 0

	auxport
		name = "abandoned  Fore Port Solar Array"
		icon_state = "panelsA"

	auxstarboard
		name = "abandoned  Fore Starboard Solar Array"
		icon_state = "panelsA"

	fore
		name = "abandoned  Fore Solar Array"
		icon_state = "yellow"

	aft
		name = "abandoned  Aft Solar Array"
		icon_state = "aft"

	starboard
		name = "abandoned  Aft Starboard Solar Array"
		icon_state = "panelsS"

	port
		name = "abandoned  Aft Port Solar Array"
		icon_state = "panelsP"

/area/maintenance/auxsolarport
	name = "Fore Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/starboardsolar
	name = "Aft Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Aft Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/auxsolarstarboard
	name = "Fore Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/foresolar
	name = "Fore Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/assembly/chargebay
	name = "abandoned  Mech Bay"
	icon_state = "mechbay"

/area/assembly/showroom
	name = "abandoned  Robotics Showroom"
	icon_state = "showroom"

/area/assembly/robotics
	name = "abandoned  Robotics Lab"
	icon_state = "ass_line"

/area/assembly/assembly_line //Derelict Assembly Line
	name = "abandoned  Assembly Line"
	icon_state = "ass_line"
	power_equip = 0
	power_light = 0
	power_environ = 0

//Teleporter

/area/teleporter
	name = "abandoned  Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/gateway
	name = "abandoned  Gateway"
	icon_state = "teleporter"
	music = "signal"

/area/AIsattele
	name = "abandoned  AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"
	ambience = list('sound/ambience/ambimalf.ogg')

//MedBay

/area/medical/medbay
	name = "abandoned  Medbay"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

//Medbay is a large area, these additional areas help level out APC load.
/area/medical/medbay2
	name = "abandoned  Medbay"
	icon_state = "medbay2"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay3
	name = "abandoned  Medbay"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/biostorage
	name = "abandoned  Secondary Storage"
	icon_state = "medbay2"
	music = 'sound/ambience/signal.ogg'

/area/medical/reception
	name = "abandoned  Medbay Reception"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/medical/psych
	name = "abandoned  Psych Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/crew_quarters/medbreak
	name = "abandoned  Break Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/patients_rooms
	name = "abandoned  Patient's Rooms"
	icon_state = "patients"

/area/medical/ward
	name = "abandoned  Recovery Ward"
	icon_state = "patients"

/area/medical/patient_a
	name = "abandoned  Isolation A"
	icon_state = "patients"

/area/medical/patient_b
	name = "abandoned  Isolation B"
	icon_state = "patients"

/area/medical/patient_c
	name = "abandoned  Isolation C"
	icon_state = "patients"

/area/medical/patient_wing
	name = "abandoned  Patient Wing"
	icon_state = "patients"

/area/medical/cmostore
	name = "abandoned  Secure Storage"
	icon_state = "CMO"

/area/medical/robotics
	name = "abandoned  Robotics"
	icon_state = "medresearch"

/area/medical/virology
	name = "abandoned  Virology"
	icon_state = "virology"

/area/medical/virologyaccess
	name = "abandoned  Virology Access"
	icon_state = "virology"

/area/medical/morgue
	name = "abandoned  Morgue"
	icon_state = "morgue"
	ambience = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/medical/chemistry
	name = "abandoned  Chemistry"
	icon_state = "chem"

/area/medical/surgery
	name = "abandoned  Operating Theatre 1"
	icon_state = "surgery"

/area/medical/surgery2
	name = "abandoned  Operating Theatre 2"
	icon_state = "surgery"

/area/medical/surgeryobs
	name = "abandoned  Operation Observation Room"
	icon_state = "surgery"

/area/medical/surgeryprep
	name = "abandoned  Pre-Op Prep Room"
	icon_state = "surgery"

/area/medical/cryo
	name = "abandoned  Cryogenics"
	icon_state = "cryo"

/area/medical/exam_room
	name = "abandoned  Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "abandoned  Genetics Lab"
	icon_state = "genetics"

/area/medical/genetics_cloning
	name = "abandoned  Cloning Lab"
	icon_state = "cloning"

/area/medical/sleeper
	name = "abandoned  Emergency Treatment Centre"
	icon_state = "exam_room"

//Security

/area/security/main
	name = "abandoned  Security Office"
	icon_state = "security"

/area/security/lobby
	name = "abandoned  Security lobby"
	icon_state = "security"

/area/security/brig
	name = "abandoned  Brig"
	icon_state = "brig"

/area/security/prison
	name = "abandoned  Prison Wing"
	icon_state = "sec_prison"


/area/security/warden
	name = "abandoned  Warden"
	icon_state = "Warden"

/area/security/armoury
	name = "abandoned  Armory"
	icon_state = "Warden"

/area/security/detectives_office
	name = "abandoned  Detective's Office"
	icon_state = "detective"

/area/security/range
	name = "abandoned  Firing Range"
	icon_state = "firingrange"

/area/security/tactical
	name = "abandoned  Tactical Equipment"
	icon_state = "Tactical"

/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

/area/security/nuke_storage
	name = "abandoned  Vault"
	icon_state = "nuke_storage"

/area/security/checkpoint
	name = "abandoned  Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "abandoned  Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint1"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint1"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint1"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/security/vacantoffice
	name = "abandoned  Vacant Office"
	icon_state = "security"

/area/security/vacantoffice2
	name = "abandoned  Vacant Office"
	icon_state = "security"

/area/quartermaster
	name = "abandoned  Quartermasters"
	icon_state = "quart"

///////////WORK IN PROGRESS//////////

/area/quartermaster/sorting
	name = "abandoned  Delivery Office"
	icon_state = "quartstorage"

////////////WORK IN PROGRESS//////////

/area/quartermaster/office
	name = "abandoned  Cargo Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "abandoned  Cargo Bay"
	icon_state = "quartstorage"

/area/quartermaster/qm
	name = "abandoned  Quartermaster's Office"
	icon_state = "quart"

/area/quartermaster/miningdock
	name = "abandoned  Mining Dock"
	icon_state = "mining"

/area/quartermaster/miningstorage
	name = "abandoned  Mining Storage"
	icon_state = "green"

/area/quartermaster/mechbay
	name = "abandoned  Mech Bay"
	icon_state = "yellow"

/area/janitor/
	name = "abandoned  Custodial Closet"
	icon_state = "janitor"

/area/hydroponics
	name = "abandoned  Hydroponics"
	icon_state = "hydro"

/area/hydroponics/garden
	name = "abandoned  Garden"
	icon_state = "garden"

//rnd (Research and Development

/area/rnd/research
	name = "abandoned  Research and Development"
	icon_state = "research"

/area/rnd/docking
	name = "abandoned  Research Dock"
	icon_state = "research_dock"

/area/rnd/lab
	name = "abandoned  Research Lab"
	icon_state = "toxlab"

/area/rnd/rdoffice
	name = "abandoned  Research Director's Office"
	icon_state = "head_quarters"

/area/rnd/supermatter
	name = "abandoned  Supermatter Lab"
	icon_state = "toxlab"

/area/rnd/xenobiology
	name = "abandoned  Xenobiology Lab"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/xenoflora_storage
	name = "abandoned  Xenoflora Storage"
	icon_state = "xeno_f_store"

/area/rnd/xenobiology/xenoflora
	name = "abandoned  Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/rnd/storage
	name = "abandoned  Toxins Storage"
	icon_state = "toxstorage"

/area/rnd/test_area
	name = "abandoned  Toxins Test Area"
	icon_state = "toxtest"

/area/rnd/mixing
	name = "abandoned  Toxins Mixing Room"
	icon_state = "toxmix"

/area/rnd/misc_lab
	name = "abandoned  Miscellaneous Research"
	icon_state = "toxmisc"

/area/toxins/server
	name = "abandoned  Server Room"
	icon_state = "server"

//Storage

/area/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "storage"

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Starboard Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Port Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency3
	name = "Central Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "abandoned  Test Room"
	icon_state = "storage"

//DJSTATION

/area/djstation
	name = "abandoned  Listening Post"
	icon_state = "LP"

/area/djstation/solars
	name = "abandoned  Listening Post Solars"
	icon_state = "LPS"

//DERELICT
/*
/area/derelict
	name = "abandoned  Derelict Station"
	icon_state = "storage"

/area/derelict/hallway/primary
	name = "abandoned  Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "abandoned  Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "abandoned  Derelict Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "abandoned  Derelict Control Room"
	icon_state = "bridge"

/area/derelict/secret
	name = "abandoned  Derelict Secret Room"
	icon_state = "library"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "abandoned  Derelict Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "abandoned  Derelict Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "abandoned  Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "abandoned  Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "abandoned  Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "abandoned  Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "abandoned  Abandoned Ship"
	icon_state = "yellow"

/area/solar/derelict_starboard
	name = "abandoned  Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "abandoned  Derelict Aft Solar Array"
	icon_state = "aft"

/area/derelict/singularity_engine
	name = "abandoned  Derelict Singularity Engine"
	icon_state = "engine"
*/
//HALF-BUILT STATION (REPLACES DERELICT IN BAYCODE, ABOVE IS LEFT FOR DOWNSTREAM)
/*
/area/shuttle/constructionsite
	name = "abandoned  Construction Site Shuttle"
	icon_state = "yellow"

/area/shuttle/constructionsite/station
	name = "abandoned  Construction Site Shuttle"

/area/shuttle/constructionsite/site
	name = "abandoned  Construction Site Shuttle"

/area/constructionsite
	name = "abandoned  Construction Site"
	icon_state = "storage"

/area/constructionsite/storage
	name = "abandoned  Construction Site Storage Area"

/area/constructionsite/science
	name = "abandoned  Construction Site Research"

/area/constructionsite/bridge
	name = "abandoned  Construction Site Bridge"
	icon_state = "bridge"

/area/constructionsite/maintenance
	name = "abandoned  Construction Site Maintenance"
	icon_state = "yellow"

/area/constructionsite/hallway/aft
	name = "abandoned  Construction Site Aft Hallway"
	icon_state = "hallP"

/area/constructionsite/hallway/fore
	name = "abandoned  Construction Site Fore Hallway"
	icon_state = "hallS"

/area/constructionsite/atmospherics
	name = "abandoned  Construction Site Atmospherics"
	icon_state = "green"

/area/constructionsite/medical
	name = "abandoned  Construction Site Medbay"
	icon_state = "medbay"

/area/constructionsite/ai
	name = "abandoned  Construction Computer Core"
	icon_state = "ai"

/area/constructionsite/engineering
	name = "abandoned  Construction Site Engine Bay"
	icon_state = "engine"

/area/solar/constructionsite
	name = "abandoned  Construction Site Solars"
	icon_state = "aft"

//area/constructionsite
//	name = "abandoned  Construction Site Shuttle"

//area/constructionsite
//	name = "abandoned  Construction Site Shuttle"

*/
//Construction

/area/construction
	name = "abandoned  Construction Area"
	icon_state = "yellow"

/area/construction/supplyshuttle
	name = "abandoned  Supply Shuttle"
	icon_state = "yellow"

/area/construction/quarters
	name = "abandoned  Engineer's Quarters"
	icon_state = "yellow"

/area/construction/qmaint
	name = "Maintenance"
	icon_state = "yellow"

/area/construction/hallway
	name = "abandoned  Hallway"
	icon_state = "yellow"

/area/construction/solars
	name = "abandoned  Solar Panels"
	icon_state = "yellow"

/area/construction/solarscontrol
	name = "abandoned  Solar Panel Control"
	icon_state = "yellow"

/area/construction/Storage
	name = "Construction Site Storage"
	icon_state = "yellow"

//AI

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"

/area/turret_protected/ai_upload
	name = "abandoned  AI Upload Chamber"
	icon_state = "ai_upload"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_server_room
	name = "AI Server Room"
	icon_state = "ai_server"

/area/turret_protected/ai
	name = "abandoned  AI Chamber"
	icon_state = "ai_chamber"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_cyborg_station
	name = "abandoned  Cyborg Station"
	icon_state = "ai_cyborg"

/area/turret_protected/aisat
	name = "abandoned  AI Satellite"
	icon_state = "ai"


/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

// CENTCOM
var/list/centcom_areas = list (
	/area/centcom,
	/area/shuttle/escape/centcom,
	/area/shuttle/escape_pod1/centcom,
	/area/shuttle/escape_pod2/centcom,
	/area/shuttle/escape_pod3/centcom,
	/area/shuttle/escape_pod5/centcom,
	/area/shuttle/transport1/centcom,
	/area/shuttle/administration/centcom,
	/area/shuttle/specops/centcom,
)

//SPACE STATION 13
var/list/the_station_areas = list (
	/area/shuttle/arrival,						//To be removed
	/area/shuttle/escape/station,				//To be removed
	/area/shuttle/escape_pod1/station,			//To be removed
	/area/shuttle/escape_pod2/station,			//To be removed
	/area/shuttle/escape_pod3/station,			//To be removed
	/area/shuttle/escape_pod5/station,			//To be removed
	/area/shuttle/mining/station,				//To be removed
	/area/shuttle/transport1/station,			//To be removed
//	/area/shuttle/transport2/station,
//	/area/shuttle/prison/station,				//To be removed
	/area/shuttle/administration/station,		//To be removed
	/area/shuttle/specops/station,				//To be removed
	/area/holodeck,								//To be removed
	/area/sulaco/cafeteria,
	/area/sulaco/cargo,
	/area/sulaco/engineering/storage,
	/area/sulaco/morgue,
	/area/sulaco/disposal,
	/area/sulaco/medbay/storage
)


