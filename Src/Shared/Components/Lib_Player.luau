--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lib_Formatting = require(script.Parent.Lib_Formatting)
local Lib_Player = {}

function Lib_Player:ReturnPlayerByPart(part: Instance): Player?
	local character: Instance = self:ReturnCharacterByPart(part)
	if not character:IsA("Model") then return end
	if Players:GetPlayerFromCharacter(character) then
		local player: Player? = Players:GetPlayerFromCharacter(character)
		if not player then return end
		return player
	end
	return
end

function Lib_Player:ReturnCharacterByPart(part: Instance): Instance?
	if part.Parent then
		if part.Parent:FindFirstChild("Humanoid") then return part.Parent end
	end
	return
end

function Lib_Player:IsPlayer(player: Player?): Player
	if RunService:IsClient() then
		return Players.LocalPlayer
	else
		assert(player, Lib_Formatting:FormatLogMessage(script, `Used IsPlayer() on server without providing a player`))
		return player
	end
end

return Lib_Player
