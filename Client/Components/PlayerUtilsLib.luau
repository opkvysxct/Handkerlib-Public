local Players = game:GetService("Players")
local PlayerUtilsLib = {}

function PlayerUtilsLib:IsFirstPerson(threshold: number?): boolean
	if Players.LocalPlayer.Character ~= nil then
		if Players.LocalPlayer.Character.Head.LocalTransparencyModifier > (threshold or 0.2) then
			return true
		end
	end
	return false
end

function PlayerUtilsLib:ForceFirstPerson(State: boolean)
	if State then
		Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
	end
end

return PlayerUtilsLib
