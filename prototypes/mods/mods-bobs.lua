-- Bob's Logistics

local tiers = {
    {
        tier = 0,
        transport_belt = "basic-transport-belt",
        underground_belt = "basic-underground-belt",
        splitter = "basic-splitter",
        colour = {r=165,g=165,b=165},
        ingredients = nil,
        crafting_category = nil,
        technology = "bob-logistics-0",
        localisation_prefix = "bob",
    },
    {
        tier = 4,
        transport_belt = "turbo-transport-belt",
        underground_belt = "turbo-underground-belt",
        splitter = "turbo-splitter",
        colour = {r=165,g=10,b=225},
        ingredients = nil,
        crafting_category = nil,
        technology = "bob-logistics-4",
        localisation_prefix = "bob",
    },
    {
        tier = 5,
        transport_belt = "ultimate-transport-belt",
        underground_belt = "ultimate-underground-belt",
        splitter = "ultimate-splitter",
        colour = {r=10,g=225,b=25},
        ingredients = nil,
        crafting_category = nil,
        technology = "bob-logistics-5",
        localisation_prefix = "bob",
    },
}

for _,tier in pairs(tiers) do deadlock_loaders.create(tier) end