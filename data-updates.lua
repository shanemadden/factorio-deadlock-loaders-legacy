-- run individual mod support
if mods["xander-mod"] then
    require("prototypes.mods.mods-xander")
elseif mods["boblogistics"] then
    require("prototypes.mods.mods-bobs")
elseif mods["FactorioExtended-Plus-Transport"] then
    require("prototypes.mods.mods-fextendedplus")
elseif mods["FactorioExtended-Transport"] then
    require("prototypes.mods.mods-fextended")
end

-- fixes
--require("prototypes.fixes")
