--[[
    Description: LocalScript attached to the Settings menu button.
    Fires a client-side BindableEvent to signal the Settings GUI to execute its opening animation.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local button = script.Parent
local bindableEvent = ReplicatedStorage:WaitForChild("GuiConfigAtivarBindable")

local function abrirConfiguracoes()
	bindableEvent:Fire()
end

button.Activated:Connect(abrirConfiguracoes)
