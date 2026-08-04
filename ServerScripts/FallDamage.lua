--Description: Calculates dynamic fall damage based on the player's downward vertical velocity (AssemblyLinearVelocity.Y) upon landing (Enum.HumanoidStateType.Landed). The lethal speed threshold and damage scaling are customizable via NumberValue instances inside the script.
local MaxVelocity = script:WaitForChild("MaxFallDistance")
local MinVelocity = script:WaitForChild("MinimumFallDistance")

game.Players.PlayerAdded:Connect(function(Plr)
	Plr.CharacterAdded:Connect(function(Char)
		local Humanoid = Char:WaitForChild("Humanoid")
		local HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")

		Humanoid.StateChanged:Connect(function(OldState, NewState)
			local PlrVelocity = HumanoidRootPart.Velocity.Y
			PlrVelocity *= -1
			
			if PlrVelocity > MaxVelocity.Value then
				Humanoid.Health = 0
			elseif PlrVelocity > MinVelocity.Value then
				Humanoid.Health -= PlrVelocity / 4
			end
		end)
	end)
end)
