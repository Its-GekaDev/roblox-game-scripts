--[[
    Description: Server-side Script attached to an in-game ProximityPrompt.
    Fires a RemoteEvent to the interacting player's client to trigger the Store GUI opening.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local subidor = script.Parent
local proximityPrompt = subidor:WaitForChild("ProximityPrompt")
local remoteAbrirLoja = ReplicatedStorage:WaitForChild("AbrirLoja")

local function aoAtivarPrompt(player)
	-- Dispara o evento apenas para o jogador que acionou o prompt
	remoteAbrirLoja:FireClient(player)
end

proximityPrompt.Triggered:Connect(aoAtivarPrompt)
