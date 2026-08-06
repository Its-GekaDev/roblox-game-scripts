--[[
    Description: LocalScript attached to a teleport cancellation modal button ("Não").
    Handles UI dismissal by setting the target modal interface visibility to false upon user activation.
--]]

local cancelButton = script.Parent
local mainInterface = cancelButton.Parent

local function fecharInterface()
	mainInterface.Visible = false
end

-- Utiliza Activated para suporte universal (PC, Mobile, Console)
cancelButton.Activated:Connect(fecharInterface)
