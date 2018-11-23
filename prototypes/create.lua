local CFUNC = {}

-- item
function CFUNC.create_loader_item(tier)
    data:extend({
        {
            type = "item",
            name = "deadlock-loader-"..tier,
            localised_name = {"entity-name."..DCL.LOCALISATION_PREFIX[tier].."-loader-"..tier},
            localised_description = {"entity-description.deadlock-loader"},
            icons = {
                { icon = "__DeadlockLoaders__/graphics/loader-icon-base.png" },
                { icon = "__DeadlockLoaders__/graphics/loader-icon-mask.png", tint = DCL.TIER_COLOURS[tier] },
            },
            icon_size = 32,
            stack_size = 50,
            flags = { "goes-to-quickbar" },
            place_result = "deadlock-loader-"..tier,
            group = "logistics",
            subgroup = "beltboxes",
            order = string.char(97+tier),
        }
    })
end

-- recipe
function CFUNC.create_loader_recipe(tier, ingredients)
    data:extend({
        {
        type = "recipe",
        name = "deadlock-loader-"..tier,
        localised_name = {"entity-name."..DCL.LOCALISATION_PREFIX[tier].."-loader-"..tier},
        localised_description = {"entity-description.deadlock-loader"},
        category = DCL.CRAFTING_CATEGORY[tier],
        group = "logistics",
        subgroup = "beltboxes",
        order = string.char(105+tier),
        enabled = false,
        ingredients = ingredients,
        result = "deadlock-loader-"..tier,
        energy_required = 2.0,
        },
    })
    if not ingredients then
        CFUNC.base_loader_recipe_on_underground(tier)
    end
end

-- tech
function CFUNC.create_loader_technology(tier)
    local tech = data.raw.technology[DCL.RESEARCH[tier]]
	if DCL.RESEARCH[tier] and tech then
        -- we could be overwriting a tier, so remove previous loader unlock
        if not tech.effects then tech.effects = {} end
        for _,effect in pairs(tech.effects) do
            if effect.recipe and string.find(effect.recipe,"deadlock-loader") then
                table.remove(effect)
                break
            end
        end
        -- insert into tech
        table.insert(tech.effects, 
            {
                type = "unlock-recipe",
                recipe = "deadlock-loader-"..tier,
            }
        )
    else
        -- no tech specified, so enable recipe by default
        data.raw.recipe["deadlock-loader-"..tier].enabled = true
	end
end

-- entity
function CFUNC.create_loader_entity(tier)
    local entity = table.deepcopy(data.raw["loader"]["loader"])
    entity.name = "deadlock-loader-"..tier
    entity.localised_name = {"entity-name."..DCL.LOCALISATION_PREFIX[tier].."-loader-"..tier}
    entity.localised_description = {"entity-description.deadlock-loader"}
    entity.icons = data.raw["item"]["deadlock-loader-"..tier].icons
    entity.icon_size = 32
    entity.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 1.0 }	
    entity.open_sound = { filename = "__base__/sound/wooden-chest-open.ogg", volume = 1.0 }	
    entity.close_sound = { filename = "__base__/sound/wooden-chest-close.ogg", volume = 1.0 }	
    entity.collision_box = { {-0.2, -0.2}, {0.2, 0.2} }
    entity.collision_mask = {"item-layer", "object-layer", "player-layer", "water-tile"}
    entity.selection_box = { {-0.5, -0.5}, {0.5, 0.5} }
    entity.minable = { hardness = 0.2, mining_time = 0.5, result = "deadlock-loader-"..tier }
    entity.belt_distance = 0
    entity.container_distance = 1.0
    entity.belt_length = 0.5
    entity.speed = data.raw["transport-belt"][DCL.BELTS[tier]].speed
    entity.structure = {
        direction_in = {
            sheets = {
                {
                    hr_version = {
                        filename = "__DeadlockLoaders__/graphics/hr-loader-base.png",
                        height = 64,
                        priority = "extra-high",
                        width = 80,
                        scale = 0.5,
                        shift = { 0.125, 0 }
                    },
                    filename = "__DeadlockLoaders__/graphics/lr-loader-base.png",
                    height = 32,
                    priority = "extra-high",
                    width = 40,
                    scale = 1,
                    shift = { 0.125, 0 }
                },
                {
                    hr_version = {
                        filename = "__DeadlockLoaders__/graphics/hr-loader-mask.png",
                        height = 64,
                        priority = "extra-high",
                        width = 80,
                        scale = 0.5,
                        tint = DCL.TIER_COLOURS[tier],
                        shift = { 0.125, 0 }
                    },
                    filename = "__DeadlockLoaders__/graphics/lr-loader-mask.png",
                    height = 32,
                    priority = "extra-high",
                    width = 40,
                    scale = 1,
                    tint = DCL.TIER_COLOURS[tier],
                    shift = { 0.125, 0 }
                },
            },
        },
        direction_out = {
            sheets = {
                {
                    hr_version = {
                        filename = "__DeadlockLoaders__/graphics/hr-loader-base.png",
                        height = 64,
                        priority = "extra-high",
                        width = 80,
                        scale = 0.5,
                        shift = { 0.125, 0 },
                    },
                    filename = "__DeadlockLoaders__/graphics/lr-loader-base.png",
                    height = 32,
                    priority = "extra-high",
                    width = 40,
                    scale = 1,
                    shift = { 0.125, 0 },
                },
                {
                    hr_version = {
                        filename = "__DeadlockLoaders__/graphics/hr-loader-mask.png",
                        height = 64,
                        priority = "extra-high",
                        width = 80,
                        scale = 0.5,
                        tint = DCL.TIER_COLOURS[tier],
                        shift = { 0.125, 0 },
                        y = 64
                    },
                    filename = "__DeadlockLoaders__/graphics/lr-loader-mask.png",
                    height = 32,
                    priority = "extra-high",
                    width = 40,
                    scale = 1,
                    tint = DCL.TIER_COLOURS[tier],
                    shift = { 0.125, 0 },
                    y = 32
                },
            },
        }
    }
    -- do it
    data:extend({entity})
end

-- functions for belt styling
local function generate_layer(target, filename, w, h, ll, fc, y, s)
    if not target then return nil end
    target.filename = filename
    target.width = w
    target.height = h
    target.line_length = ll
    target.frame_count = fc
    target.y = y
    target.scale = s
    target.priority = "extra-high"
    target.flags = { "no-crop", "low-object" }
    return target
end

local function generate_belt_graphic(target, tier, y)
    if not target then return nil end
    local new = { layers = {} }
    local sheets = {"belt-base", "belt-mask"}
    for i,sheet in ipairs(sheets) do
        new.layers[i] = table.deepcopy(target)
        if not new.layers[i].hr_version then new.layers[i].hr_version = table.deepcopy(target) end
        new.layers[i] = generate_layer(new.layers[i], "__DeadlockLoaders__/graphics/lr-"..sheet..".png", 40, 40, 32, 32, y/2, 1.0)
        new.layers[i].hr_version = generate_layer(new.layers[i].hr_version, "__DeadlockLoaders__/graphics/hr-"..sheet..".png", 80, 80, 32, 32, y, 0.5)
        if sheet == "belt-mask" then
            new.layers[i].tint = table.deepcopy(DCL.TIER_COLOURS[tier])
            new.layers[i].hr_version.tint = table.deepcopy(DCL.TIER_COLOURS[tier])
        end
    end
    return new
end

function CFUNC.create_belt_style(tier)
    -- styling
    if not mods["DeadlockIndustry"] and settings.startup["deadlock-loaders-belt-style"].value then
        -- add layered belts and update all belt-likes
        for i,proto in pairs( {data.raw["loader"]["deadlock-loader-"..tier], data.raw["transport-belt"][DCL.BELTS[tier]], data.raw["splitter"][DCL.SPLITTERS[tier]], data.raw["underground-belt"][DCL.UNDERGROUNDS[tier]]} ) do
            if proto then
                for bc,y in pairs(DCL.BELT_COMPONENTS) do
                    if proto[bc] then proto[bc] = generate_belt_graphic(proto[bc], tier, y) end
                end
                proto.animation_speed_coefficient = 32
                proto.ending_patch = {
                    sheet = {
                        filename = "__DeadlockLoaders__/graphics/blank.png",
                        height = 1,
                        width = 1,
                        priority = "low",
                    }
                }
                --log(serpent.block(proto))
            end
        end
        data.raw.item[DCL.BELTS[tier]].icon = nil
        data.raw.item[DCL.BELTS[tier]].icons = {
            { icon = "__DeadlockLoaders__/graphics/belt-icon-base.png" },
            { icon = "__DeadlockLoaders__/graphics/belt-icon-mask.png", tint = DCL.TIER_COLOURS[tier] },
        }
        data.raw.item[DCL.BELTS[tier]].icon_size = 32
    elseif not DCL.PARADOX then
        -- update belt components of loaders
        local entity = data.raw["loader"]["deadlock-loader-"..tier]
        if entity then
            for bc,y in pairs(DCL.BELT_COMPONENTS) do
                if entity[bc] then
                    entity[bc] = generate_layer(entity[bc],
                        data.raw["transport-belt"][DCL.BELTS[tier]][bc].filename,
                        data.raw["transport-belt"][DCL.BELTS[tier]][bc].width,
                        data.raw["transport-belt"][DCL.BELTS[tier]][bc].height,
                        data.raw["transport-belt"][DCL.BELTS[tier]][bc].line_length,
                        data.raw["transport-belt"][DCL.BELTS[tier]][bc].frame_count,
                        data.raw["transport-belt"][DCL.BELTS[tier]][bc].y,
                        data.raw["transport-belt"][DCL.BELTS[tier]][bc].scale
                    )
                    if (data.raw["transport-belt"][DCL.BELTS[tier]][bc].hr_version) then
                        entity[bc].hr_version = generate_layer(entity[bc].hr_version,
                            data.raw["transport-belt"][DCL.BELTS[tier]][bc].hr_version.filename,
                            data.raw["transport-belt"][DCL.BELTS[tier]][bc].hr_version.width,
                            data.raw["transport-belt"][DCL.BELTS[tier]][bc].hr_version.height,
                            data.raw["transport-belt"][DCL.BELTS[tier]][bc].hr_version.line_length,
                            data.raw["transport-belt"][DCL.BELTS[tier]][bc].hr_version.frame_count,
                            data.raw["transport-belt"][DCL.BELTS[tier]][bc].hr_version.y,
                            data.raw["transport-belt"][DCL.BELTS[tier]][bc].hr_version.scale
                        )
                    end
                end
            end
        end
    end
    if settings.startup["deadlock-loaders-underneathie-style"].value then
        -- update underneathies
		local entity = data.raw["underground-belt"][DCL.UNDERGROUNDS[tier]]
        if entity then
            entity.structure = {
                direction_in = {
                    sheets = {
                        {
                            hr_version = {
                                filename = "__DeadlockLoaders__/graphics/hr-under-base.png",
                                height = 64,
                                priority = "extra-high",
                                width = 80,
                                scale = 0.5,
                                shift = { 0.125, 0 },
                            },
                            filename = "__DeadlockLoaders__/graphics/lr-under-base.png",
                            height = 32,
                            priority = "extra-high",
                            width = 40,
                            scale = 1,
                            shift = { 0.125, 0 },
                        },
                        {
                            hr_version = {
                                filename = "__DeadlockLoaders__/graphics/hr-under-mask.png",
                                height = 64,
                                priority = "extra-high",
                                width = 80,
                                scale = 0.5,
                                tint = DCL.TIER_COLOURS[tier],
                                shift = { 0.125, 0 },
                                y = 64,
                            },
                            filename = "__DeadlockLoaders__/graphics/lr-under-mask.png",
                            height = 32,
                            priority = "extra-high",
                            width = 40,
                            scale = 1,
                            tint = DCL.TIER_COLOURS[tier],
                            shift = { 0.125, 0 },
                            y = 32,
                        },
                    },
                },
                direction_out = {
                    sheets = {
                        {
                            hr_version = {
                                filename = "__DeadlockLoaders__/graphics/hr-under-base.png",
                                height = 64,
                                priority = "extra-high",
                                width = 80,
                                scale = 0.5,
                                shift = { 0.125, 0 },
                            },
                            filename = "__DeadlockLoaders__/graphics/lr-under-base.png",
                            height = 32,
                            priority = "extra-high",
                            width = 40,
                            scale = 1,
                            shift = { 0.125, 0 },
                        },
                        {
                            hr_version = {
                                filename = "__DeadlockLoaders__/graphics/hr-under-mask.png",
                                height = 64,
                                priority = "extra-high",
                                width = 80,
                                scale = 0.5,
                                tint = DCL.TIER_COLOURS[tier],
                                shift = { 0.125, 0 },
                            },
                            filename = "__DeadlockLoaders__/graphics/lr-under-mask.png",
                            height = 32,
                            priority = "extra-high",
                            width = 40,
                            scale = 1,
                            tint = DCL.TIER_COLOURS[tier],
                            shift = { 0.125, 0 },
                        },
                    },
                }
            }
            local item = data.raw["item"][DCL.UNDERGROUNDS[tier]]
            item.icon = nil
            item.icons = {
                    { icon = "__DeadlockLoaders__/graphics/under-icon-base.png" },
                    { icon = "__DeadlockLoaders__/graphics/under-icon-mask.png", tint = DCL.TIER_COLOURS[tier] },
            }
            item.icon_size = 32
            entity.icon = nil
            entity.icons = item.icons
            entity.icon_size = 32
        end
    end
end


local function replace_ingredients(underground_ingredients, lower_underground, lower_loader)
    -- undergrounds replaced by 1 loader of previous tier, belts replaced by 1 belt, everything else halved
    if not underground_ingredients then return nil end
    underground_ingredients = table.deepcopy(underground_ingredients)
    for _,ingredient in pairs(underground_ingredients) do
        if ingredient.name and ingredient.name == lower_underground then 
            ingredient.name = lower_loader
            ingredient.amount = 1
        elseif ingredient[1] and ingredient[1] == lower_underground then 
            ingredient[1] = lower_loader
            ingredient[2] = 1
        elseif ingredient.name and data.raw["transport-belt"][ingredient.name] then ingredient.amount = 1
        elseif ingredient[1] and data.raw["transport-belt"][ingredient[1]] then ingredient[2] = 1
        elseif ingredient.amount then ingredient.amount = math.ceil(ingredient.amount/2)
        elseif ingredient[2] then ingredient[2] = math.ceil(ingredient[2]/2) end
    end
    return underground_ingredients
end

function CFUNC.base_loader_recipe_on_underground(tier)
    local underground_recipe = data.raw.recipe[DCL.UNDERGROUNDS[tier]]
    if not underground_recipe then return end
    local loader_recipe = table.deepcopy(data.raw.recipe["deadlock-loader-"..tier])
    local lower_underground = DCL.UNDERGROUNDS[tier-1]
    local lower_loader = "deadlock-loader-"..(tier-1)
    if underground_recipe.ingredients then
        loader_recipe.ingredients = replace_ingredients(underground_recipe.ingredients, lower_underground, lower_loader) 
    elseif underground_recipe.normal then
        loader_recipe.ingredients = nil
        loader_recipe.normal = table.deepcopy(underground_recipe.normal)
        loader_recipe.normal.ingredients = replace_ingredients(underground_recipe.normal.ingredients, lower_underground, lower_loader)
        loader_recipe.expensive = table.deepcopy(underground_recipe.expensive)
        loader_recipe.expensive.ingredients = replace_ingredients(underground_recipe.expensive.ingredients, lower_underground, lower_loader)
    end
    loader_recipe.category = underground_recipe.category
    -- override meddling mods which semi-randomly convert "result" to single-result "results"
    if loader_recipe.normal then
        loader_recipe.normal.results = nil
        loader_recipe.normal.result = "deadlock-loader-"..tier
        loader_recipe.normal.result_count = 1
        loader_recipe.expensive.results = nil
        loader_recipe.expensive.result = "deadlock-loader-"..tier
        loader_recipe.expensive.result_count = 1
    else
        loader_recipe.results = nil
        loader_recipe.result = "deadlock-loader-"..tier
        loader_recipe.result_count = 1
    end
    data.raw.recipe["deadlock-loader-"..tier] = loader_recipe
end

return CFUNC