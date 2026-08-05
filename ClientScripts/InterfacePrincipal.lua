--[[
    Description: LocalScript attached to a UI button. 
    Hides the target Frame/GUI upon activation and includes a debounce check 
    to prevent input spamming during screen transitions.
--]]

local button = script.Parent
local parentGui = button.Parent

-- Trava de clique para evitar duplo acionamento acidental
local isProcessing = false

button.Activated:Connect(function()
	if isProcessing then return end
	isProcessing = true

	-- Oculta a interface
	parentGui.Visible = false

	-- Pequena pausa antes de liberar o botão novamente (evita misclicks se a GUI reabrir)
	task.wait(0.3)
	isProcessing = false
end)
