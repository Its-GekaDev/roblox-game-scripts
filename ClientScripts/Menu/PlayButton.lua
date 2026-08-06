--[[
    Description: LocalScript attached to the Main Menu Play button.
    Restores player camera control back to the character's default view (Custom) 
    and hides the main menu interface to begin gameplay.
--]]
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Botao = script.Parent
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local cameraPart = Workspace:WaitForChild("Menu"):WaitForChild("Camera1")
local FramePrincipal = Botao.Parent
local Settings = FramePrincipal.Parent:WaitForChild("Settings")
local Store = FramePrincipal.Parent:WaitForChild("Store")
local Sla = FramePrincipal.Parent:WaitForChild("Sla")

Botao.Activated:Connect(function(hit)
	FramePrincipal.Visible = false
	Settings.Visible = false
	Store.Visible = false
	Sla.Visible = false
	camera.CameraType = Enum.CameraType.Custom
end)
