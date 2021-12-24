///////////////
//////Cook/////
///////////////

/datum/job/civilian/cook
	title = "Cook"
	comm_title = "Cook"
	paygrade = "C"
	flag = ROLE_MARINE_COOK
	department_flag = ROLEGROUP_MARINE_SQUAD_MARINES
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting marshal"
	selection_color = "#FDD24C"
	access = list(ACCESS_IFF_MARINE)
	minimal_access = list(ACCESS_IFF_MARINE)
	idtype = /obj/item/card/id/silver
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	skills_type = /datum/skills/civilian/survivor/chef

	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/marine,
				WEAR_BODY = /obj/item/clothing/under/rank/chef,
				WEAR_FEET = /obj/item/clothing/shoes/white,
				WEAR_HANDS = /obj/item/clothing/gloves/latex,
				WEAR_JACKET = /obj/item/clothing/suit/chef,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
				WEAR_HEAD = /obj/item/clothing/head/chefhat
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You are a civilian, working as a cook on USS Almayer.
You are tasked with cooking food and making sure the marines are well-fed.
Your role involves a lot of roleplaying, and though your supervisor is the military chain of command - you are still just a civillian with no extraordinary skills."}