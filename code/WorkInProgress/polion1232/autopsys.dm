//holster
/datum/surgery_step/xeno
	priority = 3
	allowed_species = list(
	"Drone", "Warrior", "Sentinel", "Spitter", "Runner", "Lurker", "Ravager", "Carrier", "Crusher", "Defender",
	"Hivelord", "Praetorian", "Queen"
	)
	blood_level = 0
	var/xeno_step = 0

/datum/surgery_step/xeno/is_valid_target(mob/living/carbon/target)
	if(isXeno(target))
		return 1
	return 0

/datum/surgery_step/xeno/can_use(mob/living/user, mob/living/carbon/Xenomorph/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)
	if(!isXeno(target))
		return 0
	if(target.xeno_forbid_retract == 1)
		target.xeno_surgery_step = 0
		return 0
	return target.xeno_surgery_step == xeno_step // checking steps

/datum/surgery_step/xeno/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/limb/affected)
	return null //placeholder


/datum/surgery_step/xeno/internal
	priority = 2
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,           \
	/obj/item/tool/wirecutters = 75
	)
	min_duration = 10
	max_duration = 20
	xeno_step = 3

/datum/surgery_step/xeno/internal/can_use(mob/living/user, mob/living/carbon/Xenomorph/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)//Because fuck it, that's why
	return 0

/datum/surgery_step/xeno/queen
	priority = 1
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,           \
	/obj/item/tool/wirecutters = 75
	)
	xeno_step = 3
	min_duration = 100
	max_duration = 150

/datum/surgery_step/xeno/queen/can_use(mob/living/user, mob/living/carbon/Xenomorph/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)
	if(!isXenoQueen(target))
		return 0
	if(target.xeno_forbid_retract)
		return 0
	return target.xeno_surgery_step == xeno_step // checking steps




/*Alien pieces removal*/

// External cutting //
//Chitin
/datum/surgery_step/xeno/chitin
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,     \
	/obj/item/tool/kitchen/knife/butcher = 20
	)

	xeno_step = 0
	min_duration = 50
	max_duration = 100

/datum/surgery_step/xeno/chitin/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung chunk of chitin out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/chitin/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut chunk of chitin out of [target]'s body</span>")
	if(isXenoCrusher(target))
		new /obj/item/marineResearch/xenomorp/chitin/crusher(target.loc)
		target.xeno_surgery_step = 1
		return
	new /obj/item/marineResearch/xenomorp/chitin(target.loc)
	target.xeno_surgery_step = 1
	return


//Muscle
/datum/surgery_step/xeno/muscle
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,           \
	/obj/item/tool/wirecutters = 75
	)

	min_duration = 50
	max_duration = 100
	xeno_step = 1

/datum/surgery_step/xeno/muscle/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung piece of muscle out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/muscle/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut piece of muscle out of [target]'s body</span>")
	new /obj/item/marineResearch/xenomorp/muscle(target.loc)
	target.xeno_surgery_step = 2
	return



//Between cutting chitin and muscle and organs
/datum/surgery_step/xeno/retract
	allowed_tools = list(
	/obj/item/tool/surgery/retractor = 100,           \
	/obj/item/tool/wrench = 75
	)

	min_duration = 30
	max_duration = 40
	xeno_step = 2

/datum/surgery_step/xeno/retract/can_use(mob/living/user, mob/living/carbon/Xenomorph/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)
	if(!isXeno(target))
		return 0
	if(target.xeno_forbid_retract == 1)
		target.xeno_surgery_step = 0
		return 0
	if(!(isXenoSentinel(target) || isXenoSpitter(target) || isXenoDrone(target) || isXenoHivelord(target) || isXenoQueen(target)) && target.xeno_surgery_step == 2)
		user.visible_message("<span class='notice'>Seem's like [target] have no more use for our research needs</span>")
		target.xeno_forbid_retract = 1 // Poor xeno butchered
		target.xeno_surgery_step = 0
		return 0
	return target.xeno_surgery_step == xeno_step // checking steps

/datum/surgery_step/xeno/retract/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start's retracting open flesh inside [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/retract/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] retracted open flesh inside [target]'s body</span>")
	target.xeno_surgery_step = 3
	return


// Internal organs //
//Acid gland
/datum/surgery_step/xeno/internal/acid
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,           \
	/obj/item/tool/wirecutters = 75
	)

	min_duration = 50
	max_duration = 100
	xeno_step = 3

/datum/surgery_step/xeno/internal/acid/can_use(mob/living/user, mob/living/carbon/Xenomorph/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)
	if(isXenoSentinel(target) || isXenoSpitter(target)) // Because spitting is their league
		return target.xeno_surgery_step == xeno_step // checking steps
	return 0

/datum/surgery_step/xeno/internal/acid/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung acid gland out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/internal/acid/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut acid gland out of [target]'s body</span>")
	if(isXenoSpitter(target))
		new /obj/item/marineResearch/xenomorp/acid_gland/spitter(target.loc)
		target.xeno_forbid_retract = 1 // Poor xeno butchered
		target.xeno_surgery_step = 0
		return
	new /obj/item/marineResearch/xenomorp/acid_gland(target.loc)
	target.xeno_surgery_step = 0
	target.xeno_forbid_retract = 1 // Poor xeno butchered
	return


//Secretor's gland
/datum/surgery_step/xeno/internal/secretor
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,           \
	/obj/item/tool/wirecutters = 75
	)

	min_duration = 50
	max_duration = 100
	xeno_step = 3

/datum/surgery_step/xeno/internal/secretor/can_use(mob/living/user, mob/living/carbon/Xenomorph/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)
	if(isXenoDrone(target) || isXenoHivelord(target)) // Because spitting is their league
		return target.xeno_surgery_step == xeno_step // checking steps
	return 0

/datum/surgery_step/xeno/internal/secretor/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung secretor gland out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/internal/secretor/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut secretor gland out of [target]'s body</span>")
	new /obj/item/marineResearch/xenomorp/secretor(target.loc)
	if(isXenoHivelord(target))
		target.xeno_surgery_step = 4
		return
	target.xeno_surgery_step = 0
	target.xeno_forbid_retract = 1 // Poor xeno butchered
	return


//Hivelord's gland
/datum/surgery_step/xeno/internal/hivelord
	allowed_tools = list(
	/obj/item/tool/surgery/scalpel = 100,           \
	/obj/item/tool/wirecutters = 75
	)

	min_duration = 50
	max_duration = 100
	xeno_step = 4


/datum/surgery_step/xeno/internal/secretor/hivelord/can_use(mob/living/user, mob/living/carbon/Xenomorph/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)
	if(isXenoHivelord(target)) // Because spitting is their league
		return target.xeno_surgery_step == xeno_step // checking steps
	return 0

/datum/surgery_step/xeno/internal/secretor/hivelord/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung strange tissue out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/internal/secretor/hivelord/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut strange tissue out of [target]'s body</span>")
	new /obj/item/marineResearch/xenomorp/secretor/hivelord(target.loc)
	new /obj/item/marineResearch/xenomorp/secretor/hivelord(target.loc)
	target.xeno_surgery_step = 0
	target.xeno_forbid_retract = 1 // Poor xeno butchered
	return


//Queen autopsy
/datum/surgery_step/xeno/queen/retract
	allowed_tools = list(
	/obj/item/tool/surgery/retractor = 100,           \
	/obj/item/tool/wrench = 75
	)

	min_duration = 30
	max_duration = 40
	xeno_step = 2

/datum/surgery_step/xeno/queen/acid
	xeno_step = 3

/datum/surgery_step/xeno/queen/secretor
	xeno_step = 4

/datum/surgery_step/xeno/queen/secretor/hivelord
	xeno_step = 5

/datum/surgery_step/xeno/queen/core
	xeno_step = 6

/datum/surgery_step/xeno/retract/can_use(mob/living/user, mob/living/carbon/Xenomorph/target, target_zone, obj/item/tool, datum/limb/affected, only_checks)
	if(!isXenoQueen(target))
		return 0
	return target.xeno_surgery_step == xeno_step // checking steps

/datum/surgery_step/xeno/retract/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start's retracting open flesh inside [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/retract/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] retracted open flesh inside [target]'s body</span>")
	target.xeno_surgery_step = 3
	return

/datum/surgery_step/xeno/queen/acid/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung acid gland out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/queen/acid/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut acid gland out of [target]'s body</span>")
	new /obj/item/marineResearch/xenomorp/acid_gland/spitter(target.loc)
	target.xeno_surgery_step = 4

/datum/surgery_step/xeno/queen/secretor/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung secretor gland out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/queen/secretor/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut secretor gland out of [target]'s body</span>")
	new /obj/item/marineResearch/xenomorp/secretor(target.loc)
	target.xeno_surgery_step = 5

/datum/surgery_step/xeno/queen/secretor/hivelord/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung strange tissue out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/queen/secretor/hivelord/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut strange tissue out of [target]'s body</span>")
	new /obj/item/marineResearch/xenomorp/secretor/hivelord(target.loc)
	target.xeno_surgery_step = 6

/datum/surgery_step/xeno/queen/core/begin_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] start cuttung strange core out of [target]'s body with the [tool]</span>")
	return

/datum/surgery_step/xeno/queen/core/end_step(mob/living/user, mob/living/carbon/Xenomorph/target, obj/item/tool)
	user.visible_message("<span class='notice'>[user] cut strange core out of [target]'s body</span>")
	new /obj/item/marineResearch/xenomorp/core(target.loc)
	target.xeno_surgery_step = 0
	target.xeno_forbid_retract = 1
	return






//Xeno do_surgery
proc/xeno_do_surgery(mob/living/carbon/Xenomorph/M, mob/living/user, obj/item/tool)
	for(var/datum/surgery_step/S in surgery_steps)
		if(S.tool_quality(tool) && S.is_valid_target(M))
			var/step_is_valid = S.can_use(user, M, user.zone_selected, tool, null, TRUE)
			if(step_is_valid)
				S.begin_step(user, M, tool)

				var/multipler = 1

				//calculate step duration
				var/step_duration = rand(S.min_duration, S.max_duration)
				if(user.mind && user.mind.cm_skills)
					//1 second reduction per level above minimum for performing surgery
					step_duration = max(5, step_duration - 10*user.mind.cm_skills.surgery)

				if(prob(S.tool_quality(tool) * multipler) &&  do_mob(user, M, step_duration, BUSY_ICON_FRIENDLY, BUSY_ICON_MEDICAL, TRUE))
					if(S.can_use(user, M, user.zone_selected, tool, null, TRUE)) //to check nothing changed during the do_mob
						S.end_step(user, M, user.zone_selected, tool) //Finish successfully

				else if((tool in user.contents) && user.Adjacent(M))
					S.fail_step(user, M, user.zone_selected, tool, null) //Malpractice
				else //This failing silently was a pain.
					to_chat(user, "<span class='warning'>You must remain close to your patient to conduct surgery.</span>")
				return 1

	if(user.a_intent == "help")
		to_chat(user, "<span class='warning'>You can't see any useful way to use \the [tool] on [M].</span>")
		return 1
	return 0