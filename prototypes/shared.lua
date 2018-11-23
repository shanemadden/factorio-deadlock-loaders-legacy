local DCL = {}

-- print to log for non-errors
DCL.LOGGING = false
function DCL.debug(message)
	if DCL.LOGGING then log("DCL: "..message) end
end

-- loaders without loaders. the spice must flow
DCL.PARADOX = settings.startup["deadlock-loaders-paradox-mode"].value

-- how many tech tiers?
DCL.TIERS_MIN = 1
DCL.TIERS_MAX = 3

-- tier colours
DCL.TIER_COLOURS = {
	[1] = {r=225,g=165,b=10},
	[2] = {r=225,g=10,b=10},
	[3] = {r=10,g=165,b=225},
}
DCL.BELTS = {
	[1] = "transport-belt",
	[2] = "fast-transport-belt",
	[3] = "express-transport-belt",
}
DCL.UNDERGROUNDS = {
	[1] = "underground-belt",
	[2] = "fast-underground-belt",
	[3] = "express-underground-belt",
}
DCL.SPLITTERS = {
	[1] = "splitter",
	[2] = "fast-splitter",
	[3] = "express-splitter",
}
DCL.BELT_COMPONENTS = {
    ["animations"] = 0,
    ["belt_horizontal"] = 0,
    ["belt_vertical"] = 80,
    ["ending_top"] = 160,
    ["ending_bottom"] = 240,
    ["ending_side"] = 320,
    ["starting_top"] = 400,
    ["starting_bottom"] = 480,
    ["starting_side"] = 560,
}
DCL.LOCALISATION_PREFIX = {
	[1] = "deadlock",
	[2] = "deadlock",
	[3] = "deadlock",
}
DCL.RESEARCH = {
	[1] = "logistics",
	[2] = "logistics-2",
	[3] = "logistics-3",
}
DCL.CRAFTING_CATEGORY = {
	[1] = "crafting",
	[2] = "crafting",
	[3] = "crafting",
}
DCL.INGREDIENTS = {}

function DCL.multiply_colour(colour, factor)
	return {r = math.floor(colour.r*factor), g = math.floor(colour.g*factor), b = math.floor(colour.b*factor), a = colour.a}
end

function DCL.maximise_colour(colour)
    local max = math.max(colour.r, colour.g, colour.b)
    if max < 1 then return colour end
    local factor = 255 / max
	return DCL.multiply_colour(colour, factor)
end

return DCL