/obj/item/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	icon = 'icons/obj/weapons.dmi'
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

/obj/item/melee/chainofcommand/suicide_act(mob/user)
	var/datum/gender/T = gender_datums[user.get_visible_gender()]
	user.visible_message(span("danger", "\The [user] [T.is] strangling [T.himself] with \the [src]! It looks like [T.he] [T.is] trying to commit suicide."), span("danger", "You start to strangle yourself with \the [src]!"), span("danger", "You hear the sound of someone choking!"))
	return (OXYLOSS)

/obj/item/melee/sabre
	name = "officer's sabre"
	desc = "An elegant weapon, its monomolecular edge is capable of cutting through flesh and bone with ease."
	hitsound = "swing_hit"
	icon_state = "sabre"
	hitsound = 'sound/weapons/rapierhit.ogg'
	force = 35
	throwforce = 15
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/melee/sabre/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	visible_message(span("danger", "[user] is slitting [TU.his] stomach open with \the [src.name]! It looks like [TU.hes] trying to commit seppuku."), span("danger", "You slit your stomach open with \the [src.name]!"), span("danger", "You hear the sound of flesh tearing open.")) // gory, but it gets the point across
	return(BRUTELOSS)

/obj/item/melee/umbrella
	name = "umbrella"
	desc = "To keep the rain off you. Use with caution on windy days."
	icon = 'icons/obj/items.dmi'
	icon_state = "umbrella_closed"
	addblends = "umbrella_closed_a"
	slot_flags = SLOT_BELT
	force = 5
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	var/open = FALSE

/obj/item/melee/umbrella/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/melee/umbrella/attack_self()
	src.toggle_umbrella()

/obj/item/melee/umbrella/proc/toggle_umbrella()
	open = !open
	icon_state = "umbrella_[open ? "open" : "closed"]"
	addblends = icon_state + "_a"
	item_state = icon_state
	update_icon()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()

// Randomizes color
/obj/item/melee/umbrella/random/Initialize(mapload)
	add_atom_colour("#"+get_random_colour(), FIXED_COLOUR_PRIORITY)
	return ..()

/obj/item/melee/cursedblade
	name = "crystal blade"
	desc = "The red crystal blade's polished surface glints in the light, giving off a faint glow."
	icon_state = "soulblade"
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 30
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	can_speak = 1
	var/list/voice_mobs = list() //The curse of the sword is that it has someone trapped inside.


/obj/item/melee/cursedblade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/melee/cursedblade/proc/ghost_inhabit(var/mob/candidate)
	if(!isobserver(candidate))
		return
	//Handle moving the ghost into the new shell.
	announce_ghost_joinleave(candidate, 0, "They are occupying a cursed sword now.")
	var/mob/living/voice/new_voice = new /mob/living/voice(src) 	//Make the voice mob the ghost is going to be.
	new_voice.transfer_identity(candidate) 	//Now make the voice mob load from the ghost's active character in preferences.
	new_voice.mind = candidate.mind			//Transfer the mind, if any.
	new_voice.ckey = candidate.ckey			//Finally, bring the client over.
	new_voice.name = "cursed sword"			//Cursed swords shouldn't be known characters.
	new_voice.real_name = "cursed sword"
	voice_mobs.Add(new_voice)
	listening_objects |= src

/obj/item/melee/skateboard
	name = "skaetbord"
	desc = "You shouldn't be seeing this. Contact an Admin."
	icon_state = "skateboard"
	icon = 'icons/obj/weapons.dmi'
	w_class = ITEMSIZE_HUGE
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	var/board_item_type = null

/obj/item/melee/skateboard/dropped(mob/user as mob)
	..()
	..()
	var/turf/T = get_turf(src)
	new board_item_type(T)
	user.drop_item(src)
	qdel(src)

/obj/item/melee/skateboard/improv
	name = "improvised skateboard"
	desc = "A skateboard. It can be placed on its wheels and ridden, or used as a radical weapon."
	icon_state = "skateboard"
	icon = 'icons/obj/weapons.dmi'
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	board_item_type = /obj/vehicle/skateboard/improv

/obj/item/melee/skateboard/beginner
	name = "skateboard"
	desc = "A XTREME SPORTZ brand skateboard for beginners. Ages 8 and up."
	icon_state = "skateboard"
	board_item_type = /obj/vehicle/skateboard/beginner

/obj/item/melee/skateboard/pro
	name = "skateboard"
	desc = "A RaDSTORMz brand professional skateboard. Looks a lot more stable than the average board."
	icon_state = "skateboard2"
	board_item_type = /obj/vehicle/skateboard/pro

/obj/item/melee/skateboard/hoverboard
	name = "hoverboard"
	desc = "A blast from the past, so retro!"
	icon_state = "hoverboard_red"
	board_item_type = /obj/vehicle/skateboard/hoverboard

/obj/item/melee/skateboard/hoverboard/admin
	name = "Board of Directors"
	desc = "The engineering complexity of a spaceship concentrated inside of a board. Just as expensive, too."
	icon_state = "hoverboard_nt"
	board_item_type = /obj/vehicle/skateboard/hoverboard/admin

/obj/item/melee/skateboard/scooter
	name = "scooter"
	desc = "A fun way to get around."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "scooter_frame"
	board_item_type = /obj/vehicle/skateboard/scooter

//Clown Halberd
/obj/item/melee/clownstaff
	name = "clown halberd"
	desc = "This deadly halberd is wielded by Columbina's melee specialists. The curved blade at the end has been painted to look like a banana, disguising its deadly edge."
	icon_state = "clownstaff"
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 30
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/items/bikehorn.ogg'

//Clown Dagger
/obj/item/melee/clownop
	name = "clown knife"
	desc = "This curved blade is painted to look like a banana, disguising its deadly edge."
	icon_state = "clownrender"
	item_state = "clown_dagger"

//Chainswords Babyyy
/obj/item/melee/chainsaw_sword
	name = "chainsaw sword"
	desc = "This weapon requires extensive training to wield effectively. Its spinning teeth are able to cut through metal as easily as flesh. Handle with care."
	icon_state = "chainswordon"
	item_state = "chainswordon"
	slot_flags = SLOT_BELT
	force = 30
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	hitsound = 'sound/weapons/chainsaw_attack.ogg'
	armor_penetration = 30
