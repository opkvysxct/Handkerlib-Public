--!strict
local Players = game:GetService("Players")
local PlayerUtilsLib = {}

function PlayerUtilsLib:IsFirstPerson(threshold: number?): boolean
	if not Players.LocalPlayer.Character then
		return false
	end
	local head: Instance? = Players.LocalPlayer.Character:FindFirstChild("Head")
	if not head then
		return false
	end
	if not head:IsA("BasePart") then
		return false
	end
	local camera: Camera = workspace.CurrentCamera
	local diff = (head.Position - camera.CFrame.Position).Magnitude
	if diff < (threshold or 0.5) then
		return true
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
