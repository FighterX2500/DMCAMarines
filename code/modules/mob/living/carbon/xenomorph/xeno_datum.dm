/datum/hive_status
	var/hivenumber = XENO_HIVE_NORMAL
	var/mob/living/carbon/Xenomorph/Queen/living_xeno_queen
	var/slashing_allowed = 1 //This initial var allows the queen to turn on or off slashing. Slashing off means harm intent does much less damage.
	var/queen_time = 300 //5 minutes between queen deaths
	var/xeno_queen_timer
	var/hive_orders = "" //What orders should the hive have
	var/color = null
	var/prefix = ""
	var/disrupted = 0				//for hive_message
	var/obj/machinery/hive_disruptor/disruptor = null	//used only when disrupted is 1
	var/enslaved = 0				//for Corrupted hive
	var/obj/machinery/computer/hive_controller/console_link = null		//used only whel enslaved is 1
	var/list/xeno_leader_list = list()
	var/list/xeno_lessers_list = list()
	var/list/xeno_buildings = list(SUNKEN_COLONY = list(), COLONY_TUNNELS = list())
	var/xen_is_evolving = FALSE

/datum/hive_status/corrupted
	hivenumber = XENO_HIVE_CORRUPTED
	prefix = "Corrupted "
	color = "#00ff80"
	enslaved = 1

/datum/hive_status/alpha
	hivenumber = XENO_HIVE_ALPHA
	prefix = "Alpha "
	color = "#cccc00"

/datum/hive_status/beta
	hivenumber = XENO_HIVE_BETA
	prefix = "Beta "
	color = "#9999ff"

/datum/hive_status/zeta
	hivenumber = XENO_HIVE_ZETA
	prefix = "Zeta "
	color = "#606060"

var/global/list/hive_datum = list(new /datum/hive_status(), new /datum/hive_status/corrupted(), new /datum/hive_status/alpha(), new /datum/hive_status/beta(), new /datum/hive_status/zeta())
