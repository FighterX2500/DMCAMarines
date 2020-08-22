#define EXCEPTIONS_DELAY 50					//BECAUSE

var/global/total_runtimes = 0
var/global/total_runtimes_skipped = 0

/world/Error(exception/E)
	if(!istype(E)) //Something threw an unusual exception
		log_debug("uncaught runtime error: [E]")
		return ..()

	var/static/list/error_last_seen = list()

	if(!error_last_seen)
		return				//Hm

	var/erroruid = "[E.file][E.line]"
	if(!error_cache)
		new /datum/error_viewer/error_cache()
	var/last_seen = error_last_seen[erroruid]
	total_runtimes++
	error_cache.errors_fired[erroruid]++

	if(world.time >= last_seen + EXCEPTIONS_DELAY)
		error_last_seen[erroruid] = world.time
		//cache errors
		error_cache.errors[erroruid] = E.name
		error_cache.errors_stack_traces[erroruid] = E.desc
		//show it's existance
		log_debug("Exception detected. [E.name]. Check following file: [E.file], line [E.line].")
		log_debug("Stack trace:[E.desc]")
	else
		total_runtimes_skipped++
	return ..()