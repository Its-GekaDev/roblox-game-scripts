--[[
    Description: LocalScript that creates a client-side white highlight outline around the local player's character.
    Sets FillTransparency to 1 so only the border is visible, and uses Occluded depth mode to prevent seeing through walls.
--]]

local character = script.Parent

-- Cria o Highlight e ajusta as propriedades ANTES de definir o Parent
local highlight = Instance.new("Highlight")
highlight.FillTransparency = 1
highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.Occluded

-- Define o Parent por último (Melhor performance)
highlight.Parent = character
