--[[
    Description: Central player data manager that creates the 'leaderstats' folder (Money and Wins).
    Utilizes DataStoreService to safely load and persist player progression asynchronously upon joining,
    leaving, or server shutdown (BindToClose).
--]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1")
local WinsLeaderboardStore = DataStoreService:GetOrderedDataStore("TopWinsLeaderboard")

local function setupStats(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local wins = Instance.new("IntValue")
	wins.Name = "Wins"
	wins.Value = 0
	wins.Parent = leaderstats

	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = 0
	money.Parent = leaderstats

	local userKey = "Player_" .. player.UserId

	-- Carrega os dados em uma única requisição (Save Table)
	local success, data = pcall(function()
		return PlayerDataStore:GetAsync(userKey)
	end)

	if success and data then
		wins.Value = data.Wins or 0
		money.Value = data.Money or 0
	elseif not success then
		warn("Falha ao carregar dados de " .. player.Name)
	end
end

local function saveData(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local winsVal = leaderstats.Wins.Value
	local moneyVal = leaderstats.Money.Value
	local userKey = "Player_" .. player.UserId

	-- Estrutura os dados para salvar tudo de uma só vez
	local dataToSave = {
		Wins = winsVal,
		Money = moneyVal
	}

	-- Salva dados gerais do jogador
	local success, err = pcall(function()
		PlayerDataStore:SetAsync(userKey, dataToSave)
	end)

	if not success then
		warn("Erro ao salvar dados de " .. player.Name .. ": " .. tostring(err))
	end

	-- Atualiza a tabela global de vitórias
	pcall(function()
		WinsLeaderboardStore:SetAsync(userKey, winsVal)
	end)
end

Players.PlayerAdded:Connect(setupStats)
Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveData(player)
	end
end)
