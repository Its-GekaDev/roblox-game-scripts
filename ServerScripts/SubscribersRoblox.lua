--[[
    Description: Checks if a player has a Roblox Premium subscription or is the game owner.
    If true, grants enhanced physical attributes (WalkSpeed and JumpPower) upon character 
    spawning and fires a RemoteEvent to open a special subscriber UI on their first spawn.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Segurança: Espera o RemoteEvent carregar
local remote = ReplicatedStorage:WaitForChild("AbrirInterfaceAssinante")

-- Nome de usuário do Roblox do Dono
local SEU_USER_NAME = "XxDemon_HunterxX141" 

-- Função que verifica se o jogador é Premium ou se é você
local function ehPremiumOuDono(player)
	return player.MembershipType == Enum.MembershipType.Premium or player.Name == SEU_USER_NAME
end

-- Função que aplica a velocidade e o pulo (Roda toda vez que ele nasce)
local function darVantagens(player, character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.WalkSpeed = 30
		humanoid.JumpPower = 70
		humanoid.UseJumpPower = true
	end
end -- <-- O 'end' que estava faltando ficava AQUI!

local function onPlayerAdded(player)
	print("Alguém entrou no servidor: " .. player.Name)

	if ehPremiumOuDono(player) then
		print(player.Name .. " foi reconhecido com sucesso!")

		local interfaceEnviada = false

		-- Evento que roda TODA VEZ que o jogador nasce ou renasce
		player.CharacterAdded:Connect(function(character)
			darVantagens(player, character)

			-- SÓ ENVIAR A INTERFACE NA PRIMEIRA VEZ QUE ELE NASCER NO JOGO
			if not interfaceEnviada then
				interfaceEnviada = true
				task.wait(1) -- Pequeno delay para a UI do cliente carregar 100% no primeiro spawn
				remote:FireClient(player)
			end
		end)

		-- Se o personagem já existir (comum ao testar sozinho no Studio)
		if player.Character then
			darVantagens(player, player.Character)
			if not interfaceEnviada then
				interfaceEnviada = true
				remote:FireClient(player)
			end
		end
	else
		print("Falhou na checagem: Não é Premium e o nome não bate com o dono.")
	end
end

-- Conecta a função para quando novos jogadores entrarem
Players.PlayerAdded:Connect(onPlayerAdded)

-- Loop de segurança para o Roblox Studio (caso você carregue antes do script rodar)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(onPlayerAdded, player)
end
end
