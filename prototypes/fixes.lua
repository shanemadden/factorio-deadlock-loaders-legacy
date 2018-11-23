local CFUNC = require("prototypes.create")

-- fixes
if not DCL.PARADOX then
    for tier = DCL.TIERS_MIN,DCL.TIERS_MAX do
        -- final speed check, because Bob
        if data.raw.loader["deadlock-loader-"..tier] and data.raw["transport-belt"][DCL.BELTS[tier]] then
            data.raw.loader["deadlock-loader-"..tier].speed = data.raw["transport-belt"][DCL.BELTS[tier]].speed
        end
        -- update recipes again, because Bob
        if not DCL.INGREDIENTS[tier] then CFUNC.base_loader_recipe_on_underground(tier) end
    end    
end