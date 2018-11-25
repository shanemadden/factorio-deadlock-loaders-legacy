-- Factorio-Extended-Plus

local tiers = {
    {
        tier = 4,
        transport_belt = "rapid-transport-belt-mk1",
        underground_belt = "rapid-transport-belt-to-ground-mk1",
        splitter = "rapid-splitter-mk1",
        colour = {r=10,g=225,b=25},
        ingredients = nil,
        crafting_category = nil,
        technology = "logistics-4",
        localisation_prefix = "fextendedplus",
    },
    {
        tier = 5,
        transport_belt = "rapid-transport-belt-mk2",
        underground_belt = "rapid-transport-belt-to-ground-mk2",
        splitter = "rapid-splitter-mk2",
        colour = {r=225,g=25,b=225},
        ingredients = nil,
        crafting_category = nil,
        technology = "logistics-5",
        localisation_prefix = "fextendedplus",
    },
}

for _,tier in pairs(tiers) do deadlock_loaders_legacy.create(tier) end