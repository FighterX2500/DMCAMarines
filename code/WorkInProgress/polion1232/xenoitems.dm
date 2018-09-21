/*
///// List of ids for teches/////

//First letter determinates path, second - tech
Starting (Xenomorphs) - 0

Xeno Biology - 10
Bio Plating - 11
Crusher Plating - 12
Xeno Muscles - 13
Hivelord thingy - 14

Xeno Chemistry - 20
Spitter thingy - 21

Xeno Flora - 30
Xenoweed - 31
Xenosack - 32
Drone thingy - 33

Queen thingy - 40
*/



//Holsters
/obj/item/marineResearch
	name = "An unidentified Alien Thingy"
	desc = "Researchy thingy!"
	icon = 'icons/Marine/Research/Marine_Research.dmi'
	icon_state = "biomass"
	var/list/id = list()

/obj/item/marineResearch/xenomorp
	name = "An unidentified Alien Thingy"
	desc = "Researchy thingy!"
	icon = 'icons/Marine/Research/Marine_Research.dmi'
	icon_state = "biomass"
//Xenofauna
/obj/item/marineResearch/xenomorp/weed
    name = "Xenoweed sample"
    desc = "Sample of strange plant"
    id = list(0, 30, 31)

/obj/item/marineResearch/xenomorp/weed/sack
    name = "Sack sample"
    desc = "Sample of strange organic tissue, what partially acid"
    id = list(0, 30, 32)

//Xenomorph pieces
/obj/item/marineResearch/xenomorp/chitin
	name = "Xenomorph chitin"
	desc = "A sturdy chunk of xenomorph chitin"
	icon_state = "chitin-chunk"
	id = list(0, 10, 11)

/obj/item/marineResearch/xenomorp/muscle
	name = "Xenomorph muscle tissue"
	desc = "A common xenomorph muscle tissue"
	id = list(0, 10)

/obj/item/marineResearch/xenomorp/chitin/crusher
	name = "Crusher's chitin"
	desc = "A chunk of extremely sturdy and durable Crusher's chitin"
	icon_state = "chitin-armor"
	id = list(0, 10, 12)

/obj/item/marineResearch/xenomorp/acid_gland
	name = "Xenomorph acid gland"
	desc = "Strange internal organ of some alien species"
	id = list(0, 20)

/obj/item/marineResearch/xenomorp/acid_gland/spitter
	name = "Spitter's gland"
	desc = "A more advanced acid gland, that produces strange toxins"
	id = list(0, 20, 21)

/obj/item/marineResearch/xenomorp/secretor
	name = "Secretory gland"
	desc = "Strange gland, that secrete high variety of alien fauna"
	id = list(0, 10, 30)

/obj/item/marineResearch/xenomorp/secretor/hivelord
	name = "Hivelord's bioplasma syntesate"
	desc = "Bizzare tissue, that can be abudantly found in Hivelord body"
	id = list(0, 10, 20, 30, 14)



//Fun stuff from Queens
/obj/item/marineResearch/xenomorp/transmitter
	name = "Queen's core"
	desc = "Highly complex and advanced organ, that can be found inside Queen's head"
	id = list(0, 10, 40)