data:extend({
    {
        type = "bool-setting",
        name = "deadlock-loaders-underneathie-style",
		order = "b",
        setting_type = "startup",
        default_value = false
    },
    {
        type = "bool-setting",
        name = "deadlock-loaders-map-colours",
		order = "c",
        setting_type = "startup",
        default_value = false
    },
    {
        type = "bool-setting",
        name = "deadlock-loaders-paradox-mode",
		order = "z",
        setting_type = "startup",
        default_value = false
    },
    {
        type = "bool-setting",
        name = "deadlock-loaders-snap-to-inventories",
		order = "a",
        setting_type = "runtime-per-user",
        default_value = true
    },
    {
        type = "bool-setting",
        name = "deadlock-loaders-snap-to-belts",
		order = "b",
        setting_type = "runtime-per-user",
        default_value = true
    },
})

if not mods["DeadlockIndustry"] then
    data:extend({
        {
            type = "bool-setting",
            name = "deadlock-loaders-belt-style",
            order = "a",
            setting_type = "startup",
            default_value = false
        }
    })
end