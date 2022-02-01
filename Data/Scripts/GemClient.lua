local GEM_PICKUP_EFFECTS = script:GetCustomProperty("GemPickupEffects")

local localPlayer = Game.GetLocalPlayer()

Events.Connect("addgem", function(player, pos)
	if player == localPlayer then
		World.SpawnAsset(GEM_PICKUP_EFFECTS, { position = pos })
	end	
end)

Events.Connect("hidegem", function(player, gem)
	if player == localPlayer then
		gem.visibility = Visibility.FORCE_OFF
	end
end)