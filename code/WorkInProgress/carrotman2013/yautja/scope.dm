/*
/obj/item/clothing/mask/gas/yautja/verb/scope()
	set name = "Use Scope Device"
	set desc = "Extend your scope device. Gives you a better vision of the area."
	set category = "Yautja"

	if(!usr.loc || !usr.canmove || usr.stat) return
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(!isYautja(user))
		to_chat(user, "<span class='warning'>You have no idea how to work these things!</span>")
		return

	if(zooming)
		to_chat(user, "<span class='notice'>You retract your scoping device.</span>")
		user.client.change_view(world.view)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		zooming = 0
	else
		var/tileoffset = 11
		var/tilesize = 32
		var/viewoffset = tilesize * tileoffset

		to_chat(user, "<span class='notice'>You activate your scoping device.</span>")
		switch(user.dir)
			if(NORTH)
				user.client.pixel_x = 0
				user.client.pixel_y = viewoffset
			if(SOUTH)
				user.client.pixel_x = 0
				user.client.pixel_y = -viewoffset
			if(EAST)
				user.client.pixel_x = viewoffset
				user.client.pixel_y = 0
			if(WEST)
				user.client.pixel_x = -viewoffset
				user.client.pixel_y = 0
		zooming = 1*/