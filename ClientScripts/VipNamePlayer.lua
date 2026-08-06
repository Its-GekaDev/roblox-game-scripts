--[[
    Description: LocalScript attached to a TextLabel/TextButton UI element.
    Dynamically sets the text property to the LocalPlayer's DisplayName (with fallback to Username).
--]]

local Players = game:GetService("Players")

local textElement = script.Parent
local localPlayer = Players.LocalPlayer

-- 1. Valida se o script está rodando no cliente
if not localPlayer then
	warn("[UI PLAYER NAME] Este script precisa ser um LocalScript para acessar o LocalPlayer!")
	return
end

-- 2. Valida se o elemento possui propriedade de texto (TextLabel ou TextButton)
if textElement:IsA("TextLabel") or textElement:IsA("TextButton") then
	-- Define o DisplayName com fallback seguro para o Name (@)
	local nomeExibicao = (localPlayer.DisplayName and localPlayer.DisplayName ~= "") 
		and localPlayer.DisplayName 
		or localPlayer.Name

	textElement.Text = nomeExibicao
else
	warn("[UI PLAYER NAME] O objeto pai não possui propriedade de texto. Tipo atual: " .. textElement.ClassName)
end
