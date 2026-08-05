-- just makes the menu Gui work
local Remote = game.ReplicatedStorage:WaitForChild("JogadorEntrouNoJogo")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("MenuGUI")

Remote.OnClientEvent:Connect(function()
	gui.Enabled = true
end)
