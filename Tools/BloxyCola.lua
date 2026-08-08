--[[
    Consumable Health Tool Script (e.g., Drink / Bloxy Cola)
    
    This script controls a consumable item in Roblox.
    - When equipped: Plays an opening audio effect.
    - When activated (clicked): Changes the character's hand grip to simulate 
      a drinking animation, plays a drink sound, waits 3 seconds, heals the 
      character by up to 15 HP (capped at MaxHealth), and resets the grip back to default.
--]]

local Tool = script.Parent
local enabled = true

function onActivated()
	if not enabled then
		return
	end

	enabled = false

	-- Temporarily adjust the tool grip position/rotation to simulate a drinking stance
	Tool.GripForward = Vector3.new(0, -.759, -.651)
	Tool.GripPos = Vector3.new(1.5, -.5, .3)
	Tool.GripRight = Vector3.new(1, 0, 0)
	Tool.GripUp = Vector3.new(0, .651, -.759)

	-- Play the drinking audio
	Tool.Handle.DrinkSound:Play()

	wait(3)
	
	-- Restore player health by 15 HP without exceeding MaxHealth
	local h = Tool.Parent:FindFirstChild("Humanoid")
	if (h ~= nil) then
		if (h.MaxHealth > h.Health + 15) then
			h.Health = h.Health + 15
		else	
			h.Health = h.MaxHealth
		end
	end

	-- Reset the tool grip back to its default idle position
	Tool.GripForward = Vector3.new(-.976, 0, -0.217)
	Tool.GripPos = Vector3.new(0.03, 0, 0)
	Tool.GripRight = Vector3.new(.217, 0, -.976)
	Tool.GripUp = Vector3.new(0, 1, 0)

	enabled = true
end

function onEquipped()
	-- Play opening audio when the tool is equipped
	Tool.Handle.OpenSound:play()
end

-- Event Listeners
script.Parent.Activated:connect(onActivated)
script.Parent.Equipped:connect(onEquipped)
