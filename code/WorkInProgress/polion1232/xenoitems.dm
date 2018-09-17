//Holster
/obj/item/xenomorp
	name = "An unidentified Alien Thingy"
	desc = "Researchy thingy!"
	icon = 'icons/Marine/Research/Marine_Research.dmi'
	icon_state = "biomass"
	origin_tech = "XenoSBio=10" //For all of them for now, until we have specific organs/more techs

//Xenofauna
/obj/item/xenomorp/weed
    name = "Xenoweed sample"
    desc = "Sample of strange plant"
    origin_tech = "XenoSBio=1"

/obj/item/xenomorp/weed/sack
    name = "Sack sample"
    desc = "Sample of strange organic tissue, what partially acid"
    origin_tech = "XenoSBio=2"

//Xenomorph pieces
/obj/item/xenomorp/chitin
	name = "Xenomorph chitin"
	desc = "A sturdy chunk of xenomorph chitin"
	icon_state = "chitin-chunk"
	origin_tech = "XenomBio=1"

/obj/item/xenomorp/muscle
	name = "Xenomorph muscle tissue"
	desc = "A common xenomorph muscle tissue"
	origin_tech = "XenomBio=2"

/obj/item/xenomorp/chitin/crusher
	name = "Crusher's chitin"
	desc = "A chunk of extremely sturdy and durable Crusher's chitin"
	icon_state = "chitin-armor"
	origin_tech = "XenomBio=3"

/obj/item/xenomorp/acid_gland
	name = "Xenomorph acid gland"
	desc = "Strange internal organ of some alien species"
	origin_tech = "XenomBio=1;XenoChem=1"

/obj/item/xenomorp/acid_gland/spitter
	name = "Spitter's gland"
	desc = "A more advanced acid gland, that produces strange toxins"
	origin_tech = "XenomBio=2;XenoChem=2"

/obj/item/xenomorp/secretor
	name = "Secretory gland"
	desc = "Strange gland, that secrete high variety of alien fauna"
	origin_tech = "XenomBio=2;Xenoflora=1"

/obj/item/xenomorp/secretor/hivelord
	name = "Hivelord's bioplasma syntesate"
	desc = "Bizzare tissue, that can be abudantly found in Hivelord body"
	origin_tech = "XenomBio=3;Xenoflora=2"



//Fun stuff from Queens
/obj/item/xenomorp/transmitter
	name = "Queen's core"
	desc = "Highly complex and advanced organ, that can be found inside Queen's head"
	origin_tech = "XenoMind=2"