--[[
    Description: Client-side LocalScript that manages store item purchase requests.
    Binds click events to buy buttons inside item frames (including dynamically added ones)
    and fires a RemoteEvent to request transaction validation on the server.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local mainInterface = script.Parent
local remoteComprarItem = ReplicatedStorage:WaitForChild("ComprarItemEvent")

-- Função para conectar o botão de compra de um quadro de item
local function conectarBotao(itemFrame)
	if not itemFrame:IsA("Frame") then return end

	-- Procura o botão 'Comprar' com tempo limite para não travar a thread
	local botaoComprar = itemFrame:WaitForChild("Comprar", 5)

	if not botaoComprar then
		warn("[LOJA CLIENTE] O botão 'Comprar' não foi encontrado em: " .. itemFrame.Name)
		return
	end

	-- Conecta o clique/toque do jogador
	botaoComprar.Activated:Connect(function()
		-- Envias apenas o identificador (nome) do item para validação segura no servidor
		remoteComprarItem:FireServer(itemFrame.Name)
	end)
end

-- 1. Vincula os itens já existentes na interface
for _, item in ipairs(mainInterface:GetChildren()) do
	conectarBotao(item)
end

-- 2. Vincula novos itens adicionados dinamicamente na interface
mainInterface.ChildAdded:Connect(conectarBotao)
