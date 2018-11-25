-- Xander Mod

local tiers = {
    {
        tier = 0,
        transport_belt = "slow-transport-belt",
        underground_belt = "slow-underground-belt",
        splitter = "slow-splitter",
        colour =  {r=166,g=166,b=110},
        ingredients = nil,
        crafting_category = nil,
        technology = "logistics_0",
        localisation_prefix = "xander",
    },
    {
        tier = 3,
        transport_belt = "expedited-transport-belt",
        underground_belt = "expedited-underground-belt",
        splitter = "expedited-splitter",
        colour = {r=10,g=225,b=25},
        ingredients = nil,
        crafting_category = nil,
        technology = "logistics-3",
        localisation_prefix = "xander",
    },
    {
        tier = 4,
        transport_belt = "express-transport-belt",
        underground_belt = "express-underground-belt",
        splitter = "express-splitter",
        colour = {r=10,g=165,b=225},
        ingredients = nil,
        crafting_category = nil,
        technology = "logistics-4",
        localisation_prefix = "xander",
    },
}

for _,tier in pairs(tiers) do deadlock_loaders_legacy.create(tier) end