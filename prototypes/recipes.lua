--local DCL = require("prototypes.shared")
if DCL.PARADOX then return end
local CFUNC = require("prototypes.create")

-- crafting tab subgroup - shared with Deadlock's Stacking Beltbox
if not data.raw["item-subgroup"]["beltboxes"] then
    data:extend({
        {
        type = "item-subgroup",
        name = "beltboxes",
        group = "logistics",
        order = "bb",
        },
    })
end

for tier = DCL.TIERS_MIN,DCL.TIERS_MAX do
    CFUNC.create_loader_recipe(tier, DCL.INGREDIENTS[tier])
end