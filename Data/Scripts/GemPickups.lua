local triggers = script.parent:FindDescendantsByType("Trigger")
local players = {}

local function OverlappedTrigger(trigger, obj)
	if obj:IsA("Player") and (not players[obj] or not players[obj][trigger]) then
		if(not players[obj]) then
			players[obj] = {}
		end

		players[obj][trigger] = true
		
		local a = players[obj]
		
		if Environment.IsClient() then
			Events.Broadcast("hidegem", obj, trigger.parent)
		end

		Events.Broadcast("addgem", obj, trigger:GetWorldPosition())
	end
end

local function OnPlayerLeft(player)
	if players[player] ~= nil then
		players[player] = nil
	end
end

for index, trigger in ipairs(triggers) do
	trigger.parent:RotateContinuous(Rotation.New(0, 0, 30 + math.random(1, 60)))

	trigger.beginOverlapEvent:Connect(OverlappedTrigger)
end

Game.playerLeftEvent:Connect(OnPlayerLeft)