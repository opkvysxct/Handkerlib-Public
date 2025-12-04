--!strict
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local FormattingLib = require(script.Parent.FormattingLib)
local PlayerLib = {}

function PlayerLib:ReturnPlayerByPart(part: Instance): Player?
	local character: Instance = self:ReturnCharacterByPart(part)
	if not character:IsA("Model") then return end
	if Players:GetPlayerFromCharacter(character) then
		local player: Player? = Players:GetPlayerFromCharacter(character)
		if not player then return end
		return player
	end
	return
end

function PlayerLib:ReturnCharacterByPart(part: Instance): Instance?
	if part.Parent then
		if part.Parent:FindFirstChild("Humanoid") then return part.Parent end
	end
	return
end

function PlayerLib:IsPlayer(player: Player?): Player
	if RunService:IsClient() then
		return Players.LocalPlayer
	else
		assert(player, FormattingLib:FormatLogMessage(script, `Used IsPlayer() on server without providing a player`))
		return player
	end
end

return PlayerLib
