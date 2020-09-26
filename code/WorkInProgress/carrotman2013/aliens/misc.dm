//breakable detectors
/obj/item/device/motiondetector/attack_alien(var/mob/living/carbon/Xenomorph/M)
	if(active)
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', vol = 10, sound_range = 10)
		to_chat(M, "<span class='xenonotice'>You smash annoying sound source.</span>")
		Dispose()
	return
