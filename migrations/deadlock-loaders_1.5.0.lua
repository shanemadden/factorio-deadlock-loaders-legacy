function reapply_research(force, research) 
	if force.technologies[research] and force.technologies[research].researched then
		for _,effect in pairs(force.technologies[research].effects) do
			if effect.type == "unlock-recipe" then
				force.recipes[effect.recipe].enabled = true
			end
		end
		force.print({"info-message.dcl-tech-migration", force.technologies[research].localised_name},{r=0.5,g=1,b=0.5,a=1})
	end
end

for _, force in pairs(game.forces) do
	force.reset_technologies()
	force.reset_recipes()
	for _,research in pairs({"logistics", "logistics-2", "logistics-3", "logistics-4", "logistics-5", "bob-logistics-4", "bob-logistics-5", "logistics_0", "bob-logistics-0"}) do
        reapply_research(force, research)
    end
end