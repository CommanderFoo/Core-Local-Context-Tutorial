local LOCAL_DAMAGEABLE_OBJECTS = script:GetCustomProperty("LocalDamageableObjects"):WaitForObject()

local children = LOCAL_DAMAGEABLE_OBJECTS:FindDescendantsByType("DamageableObject")

local function UpdateHealthData(obj)
	local data = {}

	for i, c in ipairs(children) do
		if Object.IsValid(c) then
			table.insert(data, c.hitPoints)
		end
	end

	script.parent:SetCustomProperty("HealthData", table.concat(data, "|"))
end

local function OnChildAdded(parent, child)
	children = LOCAL_DAMAGEABLE_OBJECTS:FindDescendantsByType("DamageableObject")

	if(Environment.IsServer()) then
		child.damagedEvent:Connect(UpdateHealthData)
	end
end

local function OnPropertyChanged(obj, prop, destroy)
	if prop == "HealthData" then
		local objs = LOCAL_DAMAGEABLE_OBJECTS:FindDescendantsByType("DamageableObject")
		local data = { CoreString.Split(script.parent:GetCustomProperty("HealthData"), "|") }

		for index, health in ipairs(data) do
			if Object.IsValid(objs[index]) and tonumber(health) == 0 then
				if destroy then
					objs[index]:Destroy()
				else
					objs[index]:Die()
				end
			end
		end
	end
end

if Environment.IsServer() then
	for i, damageable in ipairs(children) do
		damageable.damagedEvent:Connect(UpdateHealthData)
	end
end

if Environment.IsClient() then
	script.parent.customPropertyChangedEvent:Connect(OnPropertyChanged)

	OnPropertyChanged(nil, "HealthData", true)
end

LOCAL_DAMAGEABLE_OBJECTS.childAddedEvent:Connect(OnChildAdded)