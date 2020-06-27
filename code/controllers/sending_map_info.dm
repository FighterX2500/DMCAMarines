proc/send_map_info(next_map)
	var/http[] = world.Export("http://127.0.0.1:4738?" + next_map)
	if(!http)
		message_admins("Failed to connect.")
		return 0
