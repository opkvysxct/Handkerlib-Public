--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PlayerLib = {}

function PlayerLib:ReturnPlayerByPart(part: Instance): Player | boolean
	if not part.Parent then
		return false
	end
	if not part.Parent:FindFirstChild("Humanoid") then
		return false
	end
	local character: Instance = part.Parent
	if not character:IsA("Model") then
		return false
	end
	if Players:GetPlayerFromCharacter(character) then
		local player: Player? = Players:GetPlayerFromCharacter(character)
		if not player then
			return false
		end
		return player
	end
	return false
end

function PlayerLib:ReturnCharacterByPart(part: Instance): Instance | boolean
	if part.Parent then
		if part.Parent:FindFirstChild("Humanoid") then
			return part.Parent
		end
	end
	return false
end

function PlayerLib:IsPlayer(player: Player?): Player
	if RunService:IsClient() then
		return Players.LocalPlayer
	else
		if not player then
			error("[H] Used IsPlayer() on server without providing a player.")
		end
		return player
	end
end

return PlayerLib
