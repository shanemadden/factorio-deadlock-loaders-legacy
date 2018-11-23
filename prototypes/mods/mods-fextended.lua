-- Factorio-Extended

local tiers = {
    {
        tier = 4,
        transport_belt = "blistering-transport-belt",
        underground_belt = "blistering-transport-belt-to-ground",
        splitter = "blistering-splitter",
        colour = {r=10,g=225,b=25},
        ingredients = nil,
        crafting_category = nil,
        technology = "logistics-4",
        localisation_prefix = "fextended",
    },
    {
        tier = 5,
        transport_belt = "furious-transport-belt",
        underground_belt = "furious-transport-belt-to-ground",
        splitter = "furious-splitter",
        colour = {r=10,g=25,b=225},
        ingredients = nil,
        crafting_category = nil,
        technology = "logistics-5",
        localisation_prefix = "fextended",
    },
}

for _,tier in pairs(tiers) do deadlock_loaders.create(tier) end