--local DCL = require("prototypes.shared")
local CFUNC = require("prototypes.create")

-- belt styling
for tier = DCL.TIERS_MIN,DCL.TIERS_MAX do
    CFUNC.create_belt_style(tier)
end



