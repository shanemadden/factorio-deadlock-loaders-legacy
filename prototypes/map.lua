-- map colours
if settings.startup["deadlock-loaders-map-colours"].value then
    for i = DCL.TIERS_MIN, DCL.TIERS_MAX do
        if data.raw["transport-belt"][DCL.BELTS[i]] then
            data.raw["transport-belt"][DCL.BELTS[i]].map_color = DCL.TIER_COLOURS[i]
        end
        if data.raw["splitter"][DCL.SPLITTERS[i]] then
            data.raw["splitter"][DCL.SPLITTERS[i]].map_color = DCL.maximise_colour(DCL.TIER_COLOURS[i])
        end
        if data.raw["underground-belt"][DCL.UNDERGROUNDS[i]] then
            data.raw["underground-belt"][DCL.UNDERGROUNDS[i]].map_color = DCL.multiply_colour(DCL.TIER_COLOURS[i], 0.6)
        end
        if data.raw["loader"]["deadlock-loader-"..i] then
            data.raw["loader"]["deadlock-loader-"..i].map_color = DCL.multiply_colour(DCL.TIER_COLOURS[i], 0.8)
        end
        if data.raw["furnace"]["deadlock-beltbox-entity-"..i] then
            data.raw["furnace"]["deadlock-beltbox-entity-"..i].map_color = DCL.maximise_colour(DCL.TIER_COLOURS[i])
        end
    end
end