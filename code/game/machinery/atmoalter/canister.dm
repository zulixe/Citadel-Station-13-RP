/obj/machinery/portable_atmospherics/canister
	name = "canister"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "yellow"
	density = 1
	var/health = 100.0
	w_class = ITEMSIZE_HUGE

	layer = TABLE_LAYER	// Above catwalks, hopefully below other things

	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP //in L/s

	var/canister_color = "yellow"
	var/can_label = 1
	start_pressure = 45 * ONE_ATMOSPHERE
	pressure_resistance = 7 * ONE_ATMOSPHERE
	var/temperature_resistance = 1000 + T0C
	volume = 1000
	use_power = USE_POWER_OFF
	interact_offline = 1 // Allows this to be used when not in powered area.
	var/release_log = ""
	var/update_flag = 0

/obj/machinery/portable_atmospherics/canister/drain_power()
	return -1

/obj/machinery/portable_atmospherics/canister/nitrous_oxide
	name = "Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled
	name = "Canister: \[O2 (Cryo)\]"

/obj/machinery/portable_atmospherics/canister/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orangeps"
	canister_color = "orangeps"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air
	name = "Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/airlock
	start_pressure = 3 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/empty/
	start_pressure = 0
	can_label = 1

/obj/machinery/portable_atmospherics/canister/empty/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
/obj/machinery/portable_atmospherics/canister/empty/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orangeps"
	canister_color = "orangeps"
/obj/machinery/portable_atmospherics/canister/empty/nitrogen
	name = "Canister \[N2\]"
	icon_state = "red"
	canister_color = "red"
/obj/machinery/portable_atmospherics/canister/empty/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
/obj/machinery/portable_atmospherics/canister/empty/nitrous_oxide
	name = "Canister \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"

/obj/machinery/portable_atmospherics/canister/helium
	name = "Canister \[Helium\]"

/obj/machinery/portable_atmospherics/canister/carbon_monoxide
	name = "Canister \[Carbon Monoxide\]"

/obj/machinery/portable_atmospherics/canister/methyl_bromide
	name = "Canister \[Methyl Bromide\]"

/obj/machinery/portable_atmospherics/canister/nitrodioxide
	name = "Canister \[Nitrogen Dioxide\]"

/obj/machinery/portable_atmospherics/canister/nitricoxide
	name = "Canister \[Nitric Oxide\]"

/obj/machinery/portable_atmospherics/canister/methane
	name = "Canister \[Methane\]"

/obj/machinery/portable_atmospherics/canister/argon
	name = "Canister \[Argon\]"

/obj/machinery/portable_atmospherics/canister/krypton
	name = "Canister \[Krypton\]"

/obj/machinery/portable_atmospherics/canister/neon
	name = "Canister \[Neon\]"

/obj/machinery/portable_atmospherics/canister/ammonia
	name = "Canister \[Ammonia\]"

/obj/machinery/portable_atmospherics/canister/xenon
	name = "Canister \[Xenon\]"

/obj/machinery/portable_atmospherics/canister/chlorine
	name = "Canister \[Chlorine\]"

/obj/machinery/portable_atmospherics/canister/sulfur_dioxide
	name = "Canister \[Sulfur Dioxide\]"

/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "Canister \[Hydrogen\]"

/obj/machinery/portable_atmospherics/canister/tritium
	name = "Canister \[Tritium\]"

/obj/machinery/portable_atmospherics/canister/deuterium
	name = "Canister \[Deuterium\]"



/obj/machinery/portable_atmospherics/canister/proc/check_change()
	var/old_flag = update_flag
	update_flag = 0
	if(holding)
		update_flag |= 1
	if(connected_port)
		update_flag |= 2

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < 10)
		update_flag |= 4
	else if(tank_pressure < ONE_ATMOSPHERE)
		update_flag |= 8
	else if(tank_pressure < 15*ONE_ATMOSPHERE)
		update_flag |= 16
	else
		update_flag |= 32

	if(update_flag == old_flag)
		return 1
	else
		return 0

/obj/machinery/portable_atmospherics/canister/update_icon()
/*
update_flag
1 = holding
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if (src.destroyed)
		src.overlays = 0
		src.icon_state = text("[]-1", src.canister_color)
		return

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	if(check_change()) //Returns 1 if no change needed to icons.
		return

	src.overlays = 0

	if(update_flag & 1)
		overlays += "can-open"
	if(update_flag & 2)
		overlays += "can-connector"
	if(update_flag & 4)
		overlays += "can-o0"
	if(update_flag & 8)
		overlays += "can-o1"
	else if(update_flag & 16)
		overlays += "can-o2"
	else if(update_flag & 32)
		overlays += "can-o3"
	return

/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		health -= 5
		healthcheck()

/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(destroyed)
		return 1

	if (src.health <= 10)
		var/atom/location = src.loc
		location.assume_air(air_contents)

		src.destroyed = 1
		playsound(src.loc, 'sound/effects/spray.ogg', 10, 1, -3)
		src.density = 0
		update_icon()

		if (src.holding)
			src.holding.loc = src.loc
			src.holding = null

		return 1
	else
		return 1

/obj/machinery/portable_atmospherics/canister/process(delta_time)
	if (destroyed)
		return

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit

			var/returnval = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(returnval >= 0)
				src.update_icon()

	if(air_contents.return_pressure() < 1)
		can_label = 1
	else
		can_label = 0

	air_contents.react() //cooking up air cans - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE

/obj/machinery/portable_atmospherics/canister/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(Proj.damage)
		src.health -= round(Proj.damage / 2)
		healthcheck()
	..()

/obj/machinery/portable_atmospherics/canister/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(!W.is_wrench() && !istype(W, /obj/item/tank) && !istype(W, /obj/item/analyzer) && !istype(W, /obj/item/pda))
		visible_message("<span class='warning'>\The [user] hits \the [src] with \a [W]!</span>")
		src.health -= W.force
		src.add_fingerprint(user)
		healthcheck()

	if(istype(user, /mob/living/silicon/robot) && istype(W, /obj/item/tank/jetpack))
		var/datum/gas_mixture/thejetpack = W:air_contents
		var/env_pressure = thejetpack.return_pressure()
		var/pressure_delta = min(10*ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure)/2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure
		var/transfer_moles = 0
		if((air_contents.temperature > 0) && (pressure_delta > 0))
			transfer_moles = pressure_delta*thejetpack.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
			thejetpack.merge(removed)
			to_chat(user, "You pulse-pressurize your jetpack from the tank.")
		return

	..()

	SSnanoui.update_uis(src) // Update all NanoUIs attached to src

/obj/machinery/portable_atmospherics/canister/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_hand(var/mob/user as mob)
	return src.nano_ui_interact(user)

/obj/machinery/portable_atmospherics/canister/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if (src.destroyed)
		return

	// this is the data which will be sent to the ui
	var/data[0]
	data["name"] = name
	data["canLabel"] = can_label ? 1 : 0
	data["portConnected"] = connected_port ? 1 : 0
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["tankMoles"] = round(air_contents.total_moles, 0.01)
	data["releasePressure"] = round(release_pressure ? release_pressure : 0)
	data["minReleasePressure"] = round(ONE_ATMOSPHERE/10)
	data["maxReleasePressure"] = round(10*ONE_ATMOSPHERE)
	data["valveOpen"] = valve_open ? 1 : 0

	data["hasHoldingTank"] = holding ? 1 : 0
	if (holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "canister.tmpl", "Canister", 480, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/canister/Topic(href, href_list)

	//Do not use "if(..()) return" here, canisters will stop working in unpowered areas like space or on the derelict. // yeah but without SOME sort of Topic check any dick can mess with them via exploits as he pleases -walter0o
	//First comment might be outdated.
	if (!istype(src.loc, /turf))
		return 0

	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr)) // exploit protection -walter0o
		usr << browse(null, "window=canister")
		onclose(usr, "canister")
		return

	if(href_list["toggle"])
		if (valve_open)
			if (holding)
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the <font color='red'><b>air</b></font><br>"
		else
			if (holding)
				release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the <font color='red'><b>air</b></font><br>"
				log_open()
		valve_open = !valve_open

	if (href_list["remove_tank"])
		if(holding)
			if (valve_open)
				valve_open = 0
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the [holding]<br>"
			if(istype(holding, /obj/item/tank))
				holding.manipulated_by = usr.real_name
			holding.loc = loc
			holding = null

	if (href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		if(diff > 0)
			release_pressure = min(10*ONE_ATMOSPHERE, release_pressure+diff)
		else
			release_pressure = max(ONE_ATMOSPHERE/10, release_pressure+diff)

	if (href_list["relabel"])
		if (can_label)
			var/list/colors = list(\
				"\[N2O\]" = "redws", \
				"\[N2\]" = "red", \
				"\[O2\]" = "blue", \
				"\[Phoron\]" = "orangeps", \
				"\[CO2\]" = "black", \
				"\[Air\]" = "grey", \
				"\[CAUTION\]" = "yellow", \
			)
			var/label = input("Choose canister label", "Gas canister") as null|anything in colors
			if (label)
				src.canister_color = colors[label]
				src.icon_state = colors[label]
				src.name = "Canister: [label]"

	src.add_fingerprint(usr)
	update_icon()

	return 1

/obj/machinery/portable_atmospherics/canister/phoron/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/phoron, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/oxygen/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/oxygen, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/oxygen, MolesForPressure())
	src.air_contents.temperature = 80
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/nitrous_oxide/Initialize(mapload)
	. = ..()
	air_contents.adjust_gas(/datum/gas/nitrous_oxide, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/helium/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/helium, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/carbon_monoxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/carbon_monoxide, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/methyl_bromide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/methyl_bromide, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/nitrodioxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/nitrodioxide, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/nitricoxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/nitricoxide, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/methane/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/methane, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/argon/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/argon, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/krypton/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/krypton, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/neon/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/neon, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/ammonia/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/ammonia, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/xenon/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/xenon, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/chlorine/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/chlorine, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/sulfur_dioxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/sulfur_dioxide, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/hydrogen/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/hydrogen, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/tritium/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/hydrogen/tritium, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/deuterium/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/hydrogen/deuterium, MolesForPressure())
	src.update_icon()

//Dirty way to fill room with gas. However it is a bit easier to do than creating some floor/engine/n2o -rastaf0
/obj/machinery/portable_atmospherics/canister/nitrous_oxide/roomfiller/Initialize(mapload)
	. = ..()
	air_contents.gas[/datum/gas/nitrous_oxide] = 9*4000
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/portable_atmospherics/canister/nitrous_oxide/roomfiller/LateInitialize()
	. = ..()
	var/turf/simulated/location = src.loc
	if (istype(src.loc))
		while (!location.air)
			sleep(10)
		location.assume_air(air_contents)
		air_contents = new

/obj/machinery/portable_atmospherics/canister/nitrogen/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/nitrogen, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/carbon_dioxide, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/air/Initialize(mapload)
	. = ..()
	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi(/datum/gas/oxygen, air_mix[/datum/gas/oxygen], /datum/gas/nitrogen, air_mix[/datum/gas/nitrogen])
	src.update_icon()

//R-UST port
// Special types used for engine setup admin verb, they contain double amount of that of normal canister.
/obj/machinery/portable_atmospherics/canister/nitrogen/engine_setup/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/nitrogen, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/engine_setup/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/carbon_dioxide, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/phoron/engine_setup/Initialize(mapload)
	. = ..()
	src.air_contents.adjust_gas(/datum/gas/phoron, MolesForPressure())
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/take_damage(var/damage)
	src.health -= damage
	healthcheck()
