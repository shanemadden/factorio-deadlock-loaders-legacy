--local DCL = require("prototypes.shared")
if DCL.PARADOX then return end
local CFUNC = require("prototypes.create")

for tier = DCL.TIERS_MIN,DCL.TIERS_MAX do
    CFUNC.create_loader_technology(tier)
end