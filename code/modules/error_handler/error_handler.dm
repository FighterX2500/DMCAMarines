#define EXCEPTIONS_DELAY 50					//BECAUSE

/world/Error(exception/E)
	if(!istype(E)) //Something threw an unusual exception
		log_debug("uncaught runtime error: [E]")
		return ..()

	var/static/list/error_last_seen = list()

	if(!error_last_seen)
		return				//Hm

	var/erroruid = "[E.file][E.line]"
	var/last_seen = error_last_seen[erroruid]

	if(world.time >= last_seen + EXCEPTIONS_DELAY)
		error_last_seen[erroruid] = world.time
		log_debug("Exception detected. [E.name]. Check following file: [E.file], line [E.line].")
		log_debug("Stack trace:[E.desc]")
	return ..()