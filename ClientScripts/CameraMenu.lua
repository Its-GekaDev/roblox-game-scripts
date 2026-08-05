--[[
    Description: LocalScript for the main menu camera system. Locks the player's CurrentCamera to a 
    specific BasePart ('Camera1') in Workspace using Scriptable mode. Includes cleanup logic to restore 
    default Custom camera controls upon joining or closing the menu.
--]]
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("JogadorEntrouNoJogo")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Encontra a Part que serve de câmera no Workspace
local cameraPart = Workspace:WaitForChild("Menu"):WaitForChild("Camera1")
-- Espera a câmera carregar completamente
repeat task.wait() until camera.CameraSubject
-- Muda o modo da câmera para ser controlada por script
camera.CameraType = Enum.CameraType.Scriptable
-- Define a posição e a rotação da câmera exatamente iguais às da Part
camera.CFrame = cameraPart.CFrame

--Para a camera voltar ao normal
--camera.CameraType = Enum.CameraType.Custom
