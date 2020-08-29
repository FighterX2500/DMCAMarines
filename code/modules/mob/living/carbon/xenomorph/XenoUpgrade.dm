
/mob/living/carbon/Xenomorph/proc/upgrade_xeno(newlevel)
	upgrade_stored = 0
	visible_message("<span class='xenonotice'>\The [src] begins to twist and contort.</span>", \
	"<span class='xenonotice'>You begin to twist and contort.</span>")
	xeno_jitter(25)
	sleep(25)

/*
*1 is indicative of the base speed/armor
ARMOR
UPGRADE		*1	2	3	4
--------------------------
Runner		0	5	10	10
Hunter		15	20	25	25
Ravager		40	45	50	50
Defender	50	55	60	70
Warrior		30	35	40	45
Crusher		60	65	70	75
Sentinel	15	15	20	20
Spitter		15	20	25	30
Boiler		20	30	35	35
Praetorian	35	40	45	50
Drone		0	5	10	15
Hivelord	0	10	15	20
Carrier		0	10	10	15
Queen		45	50	55	55

SPEED
UPGRADE		 4		 3		 2		 *1
----------------------------------------
Runner		-2.1	-2.0	-1.9	-1.8
Hunter		-1.8	-1.7	-1.6	-1.5
Ravager		-1.0	-0.9	-0.8	-0.7
Defender	-0.5	-0.4	-0.3	-0.2
Warrior		-0.5	-0.6	-0.7	-0.8
Crusher		 0.1	 0.1	 0.1	 0.1	*-2.0 when charging
Sentinel	-1.1	-1.0	-0.9	-0.8
Spitter		-0.8	-0.7	-0.6	-0.5
Boiler		 0.4	 0.5	 0.6	 0.7
Praetorian	-0.8	-0.7	-0.6	-0.5
Drone		-1.1	-1.0	-0.9	-0.8
Hivelord	 0.1	 0.2	 0.3	 0.4
Carrier		-0.3	-0.2	-0.1	 0.0
Queen		 0.0	 0.1	 0.2	 0.3
*/

	switch(newlevel)
		//FIRST UPGRADE
		if(1)
			upgrade_name = "Mature"
			to_chat(src, "<span class='xenodanger'>You feel a bit stronger.</span>")

		//SECOND UPGRADE
		if(2)
			upgrade_name = "Elder"
			to_chat(src, "<span class='xenodanger'>You feel a whole lot stronger.</span>")

		//Final UPGRADE
		if(3)
			upgrade_name = "Ancient"
			switch(caste)
				if("Runner")
					to_chat(src, "<span class='xenoannounce'>You are the fastest assassin of all time. Your speed is unmatched.</span>")
				if("Lurker")
					to_chat(src, "<span class='xenoannounce'>You are the epitome of the hunter. Few can stand against you in open combat.</span>")
				if("Ravager")
					to_chat(src, "<span class='xenoannounce'>You are death incarnate. All will tremble before you.</span>")
				if("Defender")
					to_chat(src, "<span class='xenoannounce'>You are a incredibly resilient, you can control the battle through sheer force.</span>")
				if("Warrior")
					to_chat(src, "<span class='xenoannounce'>None can stand before you. You will annihilate all weaklings who try.</span>")
				if("Crusher")
					to_chat(src, "<span class='xenoannounce'>You are the physical manifestation of a Tank. Almost nothing can harm you.</span>")
				if("Sentinel")
					to_chat(src, "<span class='xenoannounce'>You are the stun master. Your stunning is legendary and causes massive quantities of salt.</span>")
				if("Spitter")
					to_chat(src, "<span class='xenoannounce'>You are a master of ranged stuns and damage. Go fourth and generate salt.</span>")
				if("Praetorian")
					to_chat(src, "<span class='xenoannounce'>You are the strongest range fighter around. Your spit is devestating and you can fire nearly a constant stream.</span>")
				if("Drone")
					to_chat(src, "<span class='xenoannounce'>You are the ultimate worker of the Hive. Time to clock in, and clock the tallhosts out.</span>")
				if("Hivelord")
					to_chat(src, "<span class='xenoannounce'>You are the builder of walls. Ensure that the marines are the ones who pay for them.</span>")
				if("Queen")
					to_chat(src, "<span class='xenoannounce'>You are the Alpha and the Omega. The beginning and the end.</span>")

	for(var/i in upgrade to newlevel-1)
		if(!caste_path)
			break
		caste_datum = new caste_path()
		caste_datum.apply_caste(src)
	upgrade = newlevel
	generate_name() //Give them a new name now

	hud_set_queen_overwatch() //update the upgrade level insignia on our xeno hud.

	//One last shake for the sake of it
	xeno_jitter(25)


//Tiered spawns.
/mob/living/carbon/Xenomorph/Runner/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Runner/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Runner/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Drone/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Drone/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Drone/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Carrier/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Carrier/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Carrier/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Hivelord/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Hivelord/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Hivelord/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Praetorian/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Praetorian/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Praetorian/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Ravager/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Ravager/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Ravager/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Sentinel/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Sentinel/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Sentinel/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Spitter/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Spitter/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Spitter/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Lurker/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Lurker/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Lurker/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Queen/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Queen/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Queen/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Crusher/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Crusher/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Crusher/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Boiler/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Boiler/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Boiler/ancient/New()
	..()
	upgrade_xeno(3)



/mob/living/carbon/Xenomorph/Defender/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Defender/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Defender/ancient/New()
	..()
	upgrade_xeno(3)


/mob/living/carbon/Xenomorph/Warrior/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Warrior/elite/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Warrior/ancient/New()
	..()
	upgrade_xeno(3)
