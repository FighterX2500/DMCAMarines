/obj/effect/mapinfo/ship/bearcat
	name = "CSV Bearcat"
	landing_area = /area/ship/scrap/shuttle/ingoing
	obj_type = /obj/effect/map/ship/bearcat
	mapx = 4
	mapy = 4

/obj/effect/map/ship/bearcat
	name = "generic ship"
	desc = "Space faring vessel."
	icon = 'maps/overmap/bearcat/bearcat.dmi'
	icon_state = "ship"

/obj/machinery/computer/shuttle_control/explore/bearcat
	name = "exploration shuttle console"
	shuttle_tag = "Exploration"
	landing_type = /area/ship/scrap/shuttle/outgoing



/area/ship/scrap
	name = "Generic Ship"

/area/ship/scrap/crew
	name = "Crew Compartemnts"
	icon_state = "hallC"

/area/ship/scrap/crew/kitchen
	name = "Galley"
	icon_state = "kitchen"

/area/ship/scrap/crew/dorms
	name = "Dorms"
	icon_state = "crew_quarters"

/area/ship/scrap/crew/saloon
	name = "Saloon"
	icon_state = "conference"

/area/ship/scrap/crew/toilets
	name = "Bathrooms"
	icon_state = "toilet"

/area/ship/scrap/crew/wash
	name = "Washroom"
	icon_state = "locker"

/area/ship/scrap/crew/medbay
	name = "Medical Bay"
	icon_state = "medbay"

/area/ship/scrap/cargo
	name = "Cargo Hold"
	icon_state = "quartstorage"

/area/ship/scrap/dock
	name = "Docking Bay"
	icon_state = "entry"

/area/ship/scrap/unused1
	name = "Unused Compartment #1"
	icon_state = "green"

/area/ship/scrap/unused2
	name = "Unused Compartment #2"
	icon_state = "yellow"

/area/ship/scrap/unused3
	name = "Unused Compartment #3"
	icon_state = "blueold"

/area/ship/scrap/maintenance
	name = "Maintenance Compartments"
	icon_state = "storage"

/area/ship/scrap/maintenance/storage
	name = "Tools Storage"
	icon_state = "eva"

/area/ship/scrap/maintenance/atmos
	name = "Atmospherics Comparment"
	icon_state = "atmos"
	music = list('sound/ambience/ambiatm1.ogg')

/area/ship/scrap/maintenance/power
	name = "Power Compartment"
	icon_state = "engine_smes"

/area/ship/scrap/maintenance/engine
	name = "Engine Compartments"
	icon_state = "engine"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/ship/scrap/command
	name = "Command Deck"
	icon_state = "centcom"
	music = list('sound/ambience/signal.ogg')

/area/ship/scrap/command/captain
	name = "Captain's Quarters"
	icon_state = "captain"

/area/ship/scrap/comms
	name = "Communications Relay"
	icon_state = "tcomsatcham"
	music = list('sound/ambience/signal.ogg')

/area/ship/scrap/shuttle/
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

/area/ship/scrap/shuttle/ingoing
	name = "Docking Bay #1"
	icon_state = "tcomsatcham"

/area/ship/scrap/shuttle/outgoing
	name = "Docking Bay #1"
	icon_state = "tcomsatcham"