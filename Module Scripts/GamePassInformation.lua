--[[
    Description: Centralized store item configuration (Single Source of Truth).
    Contains item pricing, currency types, and associated Gamepass IDs.
    
    Item Schema:
    [ItemKey] = {
        Nome = string,        -- Name displayed on UI
        Preco = number,       -- Price in Robux or In-Game Coins
        TipoMoeda = string,   -- "Robux" or "Coins"
        GamepassId = number,  -- Roblox Gamepass Product ID
    }
--]]

local ConfigItem = {
	["EquipamentoDeMergulho"] = {
		Nome = "Equipamento de Mergulho",
		Preco = 999,
		TipoMoeda = "Robux",
		GamepassId = 1918989086,
	},
	["Apple"] = {
		Nome = "Apple",
		Preco = 24,
		TipoMoeda = "Robux",
		GamepassId = 1919265379,
	},
	["Placa"] = {
		Nome = "Placa",
		Preco = 5,
		TipoMoeda = "Robux",
		GamepassId = 1917771825,
	},
	["Lemonade"] = {
		Nome = "Lemonade",
		Preco = 5,
		TipoMoeda = "Robux",
		GamepassId = 1918167876,
	},
	["Glider"] = {
		Nome = "Glider",
		Preco = 49,
		TipoMoeda = "Robux",
		GamepassId = 1917603947,
	},
	["Jetpack"] = {
		Nome = "Jetpack",
		Preco = 149,
		TipoMoeda = "Robux",
		GamepassId = 1919631815,
	},
	["Spray"] = {
		Nome = "Spray",
		Preco = 14,
		TipoMoeda = "Robux",
		GamepassId = 1932498253,
	},
	["BoomBox"] = {
		Nome = "BoomBox",
		Preco = 49,
		TipoMoeda = "Robux",
		GamepassId = 1927970311,
	},
}

-- Retorna a tabela de dados do item solicitado ou nil
function ConfigItem.PegarItem(nomeDoItem)
	return ConfigItem[nomeDoItem]
end

return ConfigItem
