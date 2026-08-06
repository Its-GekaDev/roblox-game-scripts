--[[
    Description: LocalScript that manages store UI purchases (GamePasses & In-Game Currency items).
    Reads item metadata from a ModuleScript config, prompts Robux GamePass purchases via MarketplaceService,
    or fires a RemoteEvent to validate in-game currency purchases on the server.
--]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local ConfigItem = require(ReplicatedStorage:WaitForChild("ConfigItem"))
local player = Players.LocalPlayer
local painelLoja = player.PlayerGui:WaitForChild("GamePassGui"):WaitForChild("InterfacePrincipal")-- O frame principal da loja

-- Função que processa o clique de qualquer botão da loja
local function aoClicarNoBotao(botao)
	local nomeDoItem = botao.Name -- Pega o nome do botão (Ex: "EquipamentoDeMergulho")
	local dadosDoItem = ConfigItem.PegarItem(nomeDoItem)
	
	print(botao.Name)

	if not dadosDoItem then 
		warn("Item não encontrado no ModuleScript: " .. nomeDoItem)
		return 
	end

	if dadosDoItem.TipoMoeda == "Robux" then
		-- Se for Gamepass, abre a janela do Roblox
		MarketplaceService:PromptGamePassPurchase(player, dadosDoItem.GamepassId)
	else
		-- Se for por moedas do jogo, avisa o servidor
		local RemoteComprar = ReplicatedStorage:FindFirstChild("ComprarItemEvent")
		if RemoteComprar then
			RemoteComprar:FireServer(nomeDoItem)
		end
	end
end

-- Varre a interface procurando os botões para conectar a função de clique
for _, item in pairs(painelLoja:GetDescendants()) do
	-- Verifica se o objeto é um botão de texto e tem o texto "Comprar"
	if item:IsA("TextButton") and item.Text == "Buy" then
		item.MouseButton1Click:Connect(function()
			aoClicarNoBotao(item)
		end)
	end
end
