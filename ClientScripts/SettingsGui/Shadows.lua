--[[
    Description: LocalScript that toggles global ambient shadows on/off client-side 
    to improve rendering performance on low-end hardware without modifying individual BasePart properties.
--]]

local Lighting = game:GetService("Lighting")

local button = script.Parent

-- Cores do botão (RGB)
local COR_VERDE = Color3.fromRGB(46, 204, 113)
local COR_VERMELHA = Color3.fromRGB(231, 76, 60)

-- Variável de controle do estado
local sombrasAtivas = true

-- Estado inicial do botão
button.BackgroundColor3 = COR_VERDE
button.Text = "Sombras: ATIVADAS"

local function alternarSombras()
	sombrasAtivas = not sombrasAtivas

	-- Desativar/Ativar GlobalShadows é suficiente e não causa lag de iteração
	Lighting.GlobalShadows = sombrasAtivas

	if sombrasAtivas then
		button.Text = "Sombras: ATIVADAS"
		button.BackgroundColor3 = COR_VERDE
	else
		button.Text = "Sombras: DESATIVADAS"
		button.BackgroundColor3 = COR_VERMELHA
	end
end

-- Uso de Activated para suporte completo a Mobile, PC e Console
button.Activated:Connect(alternarSombras)
