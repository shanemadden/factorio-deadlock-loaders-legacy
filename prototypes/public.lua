local CFUNC = require("prototypes.create")

if not deadlock_loaders_legacy then deadlock_loaders_legacy = {} end

local function log_error(string) 
    log("DCL: "..string)
end

local function is_table(t) return type(t) == 'table' end

local function is_colour(c)
    if not c or not is_table(c) or not c.r or not c.g or not c.b then return false end
    return true
end

function deadlock_loaders_legacy.create(tier_table)
    -- sanity checks
    if not tier_table or not is_table(tier_table) then
        log_error("Non-table passed to deadlock_loaders.create() - must be a properly formatted tier table.\nSee the readme.pdf.")
        return
    end
    if not tier_table.tier then
        log_error("No tier specified.")
        return
    end
    if tier_table.tier - DCL.TIERS_MAX > 1 then
        log_error("Current highest tier is "..DCL.TIERS_MAX.." but DCL was asked to create tier "..tier_table.tier..".\nSpecify tiers in order, tier "..(DCL.TIERS_MAX+1).." comes next.")
        return
    elseif DCL.TIERS_MIN - tier_table.tier > 1 then
        log_error("Current lowest tier is "..DCL.TIERS_MIN.." but DCL was asked to create tier "..tier_table.tier..".\nSpecify tiers in order, tier "..(DCL.TIERS_MIN-1).." comes next.")
        return
    end
    if not tier_table.transport_belt or not data.raw["transport-belt"][tier_table.transport_belt] then
        if not tier_table.transport_belt then log_error("Transport belt entity not specified (tier "..table.tier..").")
        else log_error("Transport belt entity does not exist ("..tier_table.transport_belt..").")
        end
        return
    end
    if tier_table.underground_belt and not data.raw["underground-belt"][tier_table.underground_belt] then
        log_error("Underground belt entity does not exist ("..tier_table.underground_belt..").")
        return
    end
    if tier_table.splitter and not data.raw["splitter"][tier_table.splitter] then
        log_error("Splitter entity does not exist ("..tier_table.splitter..").")
        return
    end
    if (not tier_table.ingredients or not is_table(tier_table.ingredients)) and not data.raw["underground-belt"][tier_table.underground_belt] then
        log_error("No way of getting ingredients (tier "..tier..").\nYou need to either specify a table of ingredients for this tier, or supply a valid underground belt entity's name.")
        return
    end
    if not is_colour(tier_table.colour) then
        if tier_table.tier >= DCL.TIERS_MIN and tier_table.tier <= DCL.TIERS_MAX then colour = DCL.TIER_COLOURS[tier_table.tier]
        else tier_table.colour = {r=1,g=0.8,b=0.8} end
    end
    if not tier_table.technology then tier_table.technology = DCL.RESEARCH[tier] end
    if not tier_table.crafting_category then tier_table.crafting_category = "crafting" end
    if not tier_table.localisation_prefix then tier_table.localisation_prefix = "deadlock" end
    -- expand tiers?
    if tier_table.tier > DCL.TIERS_MAX then DCL.TIERS_MAX = tier_table.tier
    elseif tier_table.tier < DCL.TIERS_MIN then DCL.TIERS_MIN = tier_table.tier
    end
    -- update data
    DCL.BELTS[tier_table.tier] = tier_table.transport_belt
    DCL.CRAFTING_CATEGORY[tier_table.tier] = tier_table.crafting_category
    DCL.LOCALISATION_PREFIX[tier_table.tier] = tier_table.localisation_prefix
    DCL.RESEARCH[tier_table.tier] = tier_table.technology
    DCL.SPLITTERS[tier_table.tier] = tier_table.splitter
    DCL.TIER_COLOURS[tier_table.tier] = tier_table.colour
    DCL.UNDERGROUNDS[tier_table.tier] = tier_table.underground_belt
    DCL.INGREDIENTS[tier_table.tier] = tier_table.ingredients
    -- do it
    if not DCL.PARADOX and data.raw["transport-belt"][tier_table.transport_belt] then
        CFUNC.create_loader_item(tier_table.tier)
        CFUNC.create_loader_recipe(tier_table.tier, tier_table.ingredients)
        --CFUNC.create_loader_technology(tier_table.tier)
        CFUNC.create_loader_entity(tier_table.tier)
    end
    CFUNC.create_belt_style(tier_table.tier)
end