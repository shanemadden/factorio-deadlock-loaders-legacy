-- If anyone's looking at this as an example: JSON migrations do most of this automatically (except recipe unlocks), and should always be used unless you need conditions around
-- your source entity and item names. If that's what you're here for, settle in for the ride..

local entity_mapping = {
	["deadlock-loader-1"] = "transport-belt-loader",
	["deadlock-loader-2"] = "fast-transport-belt-loader",
	["deadlock-loader-3"] = "express-transport-belt-loader",
}

if game.active_mods["xander-mod"] then
	entity_mapping["deadlock-loader-0"] = "slow-transport-belt-loader"
	entity_mapping["deadlock-loader-3"] = "expedited-transport-belt-loader"
	entity_mapping["deadlock-loader-4"] = "express-transport-belt-loader"
elseif game.active_mods["boblogistics"] then
	entity_mapping["deadlock-loader-0"] = "basic-transport-belt-loader"
	entity_mapping["deadlock-loader-4"] = "turbo-transport-belt-loader"
	entity_mapping["deadlock-loader-5"] = "ultimate-transport-belt-loader"
elseif game.active_mods["FactorioExtended-Plus-Transport"] then
	entity_mapping["deadlock-loader-4"] = "rapid-transport-belt-mk1-loader"
	entity_mapping["deadlock-loader-5"] = "rapid-transport-belt-mk2-loader"
elseif game.active_mods["FactorioExtended-Transport"] then
	entity_mapping["deadlock-loader-4"] = "blistering-transport-belt-loader"
	entity_mapping["deadlock-loader-5"] = "furious-transport-belt-loader"
end
-- same mapping for loaders, using a different variable to keep the logic clear since they're different mappings for beltboxes
local item_mapping = entity_mapping
-- mapping of assember recipes, also keys used for removing enabled recipes from forces
local recipe_mapping = entity_mapping

local all_inventory_types = {
	defines.inventory.fuel,
	defines.inventory.burnt_result,
	defines.inventory.chest,
	defines.inventory.furnace_source,
	defines.inventory.furnace_result,
	defines.inventory.furnace_modules,
	defines.inventory.player_quickbar,
	defines.inventory.player_main,
	defines.inventory.player_guns,
	defines.inventory.player_ammo,
	defines.inventory.player_armor,
	defines.inventory.player_tools,
	defines.inventory.player_vehicle,
	defines.inventory.player_trash,
	defines.inventory.god_quickbar,
	defines.inventory.god_main,
	defines.inventory.roboport_robot,
	defines.inventory.roboport_material,
	defines.inventory.robot_cargo,
	defines.inventory.robot_repair,
	defines.inventory.assembling_machine_input,
	defines.inventory.assembling_machine_output,
	defines.inventory.assembling_machine_modules,
	defines.inventory.lab_input,
	defines.inventory.lab_modules,
	defines.inventory.mining_drill_modules,
	defines.inventory.item_main,
	defines.inventory.rocket_silo_rocket,
	defines.inventory.rocket_silo_result,
	defines.inventory.rocket,
	defines.inventory.car_trunk,
	defines.inventory.car_ammo,
	defines.inventory.cargo_wagon,
	defines.inventory.turret_ammo,
	defines.inventory.beacon_modules,
	defines.inventory.character_corpse,
}
local types_added = {}
local inventory_types = {}
for _, inventory_type in ipairs(all_inventory_types) do
	if not types_added[inventory_type] then
		types_added[inventory_type] = true
		table.insert(inventory_types, inventory_type)
	end
end

local function scan_blueprint(blueprint)
	local blueprint_entities = blueprint.get_blueprint_entities()
	if blueprint_entities then
		for i, entity_table in ipairs(blueprint_entities) do
			if entity_mapping[entity_table.name] then
				entity_table.name = entity_mapping[entity_table.name]
			end
		end
		blueprint.clear_blueprint()
		blueprint.set_blueprint_entities(blueprint_entities)
	end
end

local scan_inventory

local function check_item(stack)
	if stack.valid and stack.valid_for_read then
		if stack.is_item_with_inventory then
			local inner_inventory = stack.get_inventory(defines.inventory.item_main)
			if inner_inventory then
				scan_inventory(inner_inventory)
			end
		elseif stack.is_blueprint and stack.is_blueprint_setup then
			scan_blueprint(stack)
		elseif stack.is_blueprint_book then
			scan_inventory(stack.get_inventory(defines.inventory.item_main))
		elseif item_mapping[stack.name] then
			-- replace it
			stack.set_stack({
				name = item_mapping[stack.name],
				count = stack.count,
				health = stack.health,
			})
		end
	end
end

function scan_inventory(inventory)
	for i = 1, #inventory do
		check_item(inventory[i])
	end
end


local function check_signal(signal)
	if signal.type == "item" and item_mapping[signal.name] then
		signal.name = item_mapping[signal.name]
	end
end
local on_off = {
	[defines.control_behavior.type.generic_on_off] = true,
	[defines.control_behavior.type.inserter] = true,
	[defines.control_behavior.type.lamp] = true,
	[defines.control_behavior.type.mining_drill] = true,
	[defines.control_behavior.type.transport_belt] = true,
}
local arith_decide = {
	[defines.control_behavior.type.decider_combinator] = true,
	[defines.control_behavior.type.arithmetic_combinator] = true,
}
local function check_control_behavior(cb)
	-- generic on off (inserters belts etc etc)
	if on_off[cb.type] then
		if cb.circuit_condition then
			if cb.circuit_condition.condition.first_signal then
				check_signal(cb.circuit_condition.condition.first_signal)
			end
			if cb.circuit_condition.condition.second_signal then
				check_signal(cb.circuit_condition.condition.second_signal)
			end
		end
		if cb.logistic_condition then
			if cb.logistic_condition.condition.first_signal then
				check_signal(cb.logistic_condition.condition.first_signal)
			end
			if cb.logistic_condition.condition.second_signal then
				check_signal(cb.logistic_condition.condition.second_signal)
			end
		end
	end
	-- combinators
	if cb.type == defines.control_behavior.type.constant_combinator then
		-- constant
		if cb.signals_count then
			local parameters = cb.parameters.parameters
			for i, parameter in ipairs(parameters) do
				if parameter.signal.type == "item" and item_mapping[parameter.signal.name] then
					cb.set_signal(i, {
						count = parameter.count,
						signal = {
							type = "item",
							name = item_mapping[parameter.signal.name],
						},
					})
				end
			end
		end
	elseif arith_decide[cb.type] then
		-- decider, arithmetic
		local parameters = cb.parameters
		if parameters.parameters.first_signal then
			check_signal(parameters.parameters.first_signal)
		end
		if parameters.parameters.second_signal then
			check_signal(parameters.parameters.second_signal)
		end
		if parameters.parameters.output_signal then
			check_signal(parameters.parameters.output_signal)
		end
		cb.parameters = parameters
	end
end
local function check_transport_line(tl)
	for i = 1, #tl do
		local stack = tl[i]
		check_item(stack)
	end
end

local blueprint_entity
for _, surface in pairs(game.surfaces) do
	for _, entity in ipairs(surface.find_entities_filtered({})) do
		local revived = false
		if entity.name == "entity-ghost" and entity_mapping[entity.ghost_name] then
			_, entity = entity.revive()
			revived = true
		end
		-- check the entity for inventories
		if entity.get_inventory then
			for _, inventory_type in ipairs(inventory_types) do
				local inventory = entity.get_inventory(inventory_type)
				if inventory then
					scan_inventory(inventory)
				end
			end
		end
		-- check if it's an inserter holding a stack
		if entity.type == "inserter" then
			check_item(entity.held_stack)
		end
		-- inserter/loader filters get_filter() set_filter()
		if entity.type == "inserter" or entity.type == "loader" then
			for i = 1, entity.filter_slot_count do
				if item_mapping[entity.get_filter(i)] then
					entity.set_filter(i, item_mapping[entity.get_filter(i)])
				end
			end
		end
		-- check if it's a belt, iterate transport lines
		if entity.type == "splitter" or entity.type == "underground-belt" or entity.type == "transport-belt" or entity.type == "loader" then
			check_transport_line(entity.get_transport_line(1))
			check_transport_line(entity.get_transport_line(2))
		end
		if entity.type == "splitter" or entity.type == "underground-belt" then
			check_transport_line(entity.get_transport_line(3))
			check_transport_line(entity.get_transport_line(4))
		end
		if entity.type == "splitter" then
			check_transport_line(entity.get_transport_line(5))
			check_transport_line(entity.get_transport_line(6))
			check_transport_line(entity.get_transport_line(7))
			check_transport_line(entity.get_transport_line(8))
		end
		-- item-entity check if there's an inventory and check if it needs directly replaced
		if entity.type == "item-entity" then
			check_item(entity.stack)
		end

		-- assembler recipes
		if entity.type == "assembling-machine" then
			if entity.get_recipe() and recipe_mapping[entity.get_recipe().name] then
				entity.set_recipe(recipe_mapping[entity.get_recipe().name])
			end
		end

		-- circuit conditions
		if entity.get_control_behavior and entity.get_control_behavior() then
			check_control_behavior(entity.get_control_behavior())
		end

		-- logistic chest requests
		if entity.request_slot_count then
			for i = 1, entity.request_slot_count do
				local request = entity.get_request_slot(i)
				if request and item_mapping[request.name] then
					entity.set_request_slot({
						name = item_mapping[request.name],
						count = request.count,
					}, i)
				end
			end
		end
		if revived then
			-- this was a ghost, blueprint it and destroy it to make it a ghost once more
			if not blueprint_entity then
				blueprint_entity = surface.create_entity({
					name = "item-on-ground",
					position = surface.find_non_colliding_position("item-on-ground", {0,0}, 0, 1),
					stack = {
						name = "blueprint",
						count = 1,
					},
				})
			end
			local area = {{entity.position.x - 0.5, entity.position.y - 0.5}, {entity.position.x + 0.5, entity.position.y + 0.5}}
			local blueprint = blueprint_entity.stack
			blueprint.clear_blueprint()
			blueprint.create_blueprint({
				surface = surface,
				force = entity.force,
				area = area,
			})

			scan_blueprint(blueprint)
			local force = entity.force
			local position = entity.position
			entity.destroy()
			blueprint.build_blueprint({
				surface = surface,
				force = force,
				position = position,
			})
		else
			-- one of our entities? fast replace it
			if entity_mapping[entity.name] then
				local entity_table = {
					name = entity_mapping[entity.name],
					position = entity.position,
					direction = entity.direction,
					force = entity.force,
					fast_replace = true,
					spill = false,
				}
				if entity.type == "loader" then
					entity_table.type = entity.loader_type
				end
				local new_entity = surface.create_entity(entity_table)
			end
		end
		-- not worrying about cargo wagon filters
		-- not worrying about train schedules
	end
end
-- nuke the temp blueprint used for upgrades
if blueprint_entity then
	blueprint_entity.destroy()
end

-- players
for _, player in pairs(game.players) do
	check_item(player.cursor_stack)
	for _, inventory_type in ipairs(inventory_types) do
		local inventory = player.get_inventory(inventory_type)
		if inventory then
			scan_inventory(inventory)
		end
	end
end

-- recipes
for _, force in pairs(game.forces) do
	force.reset_technologies()
	for tech_name, technology in pairs(force.technologies) do
		if technology.researched then
			for _, effect in pairs(technology.effects) do
				if effect.type == "unlock-recipe" then
					force.recipes[effect.recipe].enabled = true
				end
			end
		end
	end
	for recipe_name, recipe in pairs(force.recipes) do
		if recipe_mapping[recipe_name] then
			force.recipes[recipe_name].enabled = false
		end
	end
end