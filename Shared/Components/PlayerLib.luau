local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PlayerLib = {}

function PlayerLib:ReturnPlayerByPart(part: Instance): Player | boolean
	if part.Parent then
		if part.Parent:FindFirstChild("Humanoid") then
			local character: Instance = part.Parent
			if Players:GetPlayerFromCharacter(character) then
				return Players:GetPlayerFromCharacter(character)
			end
		end
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
