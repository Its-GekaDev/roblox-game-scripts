--[[
    Description: LocalScript attached to the Store menu button.
    Fires a client-side BindableEvent to trigger the opening animation for the GamePass / Store GUI.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local button = script.Parent
local bindableEvent = ReplicatedStorage:WaitForChild("GuiAtivarBindable")

local function abrirLoja()
	bindableEvent:Fire()
end

button.Activated:Connect(abrirLoja)
