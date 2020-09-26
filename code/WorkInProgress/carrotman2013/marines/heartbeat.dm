//heart sounds
/mob/living/carbon/proc/heartbeating()
	if(heartpouncecooldown > world.time)
		return
	if(heartbeatingcooldown > world.time)
		return
	else if(heartbeatingcooldown < world.time)
		src << sound('sound/effects/Heart Beat.ogg',volume=40, repeat = 0, wait = 0, channel = 4343)
		heartbeatingcooldown = world.time + 515

/mob/living/carbon/proc/heartpounce()
	if(heartbeatingcooldown > world.time)
		return
	if(heartpouncecooldown > world.time)
		return
	else if(heartpouncecooldown < world.time)
		src << sound('sound/effects/Heartbeat.ogg',volume=40, repeat = 0, wait = 0, channel = 4343)
		heartpouncecooldown = world.time + 15