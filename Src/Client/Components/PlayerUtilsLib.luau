--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local FormattingLib = require(script.Parent.Parent.Parent.Shared.Components.FormattingLib)
local PlayerUtilsLib = {}

function PlayerUtilsLib:IsFirstPerson(threshold: number?): boolean
	if not Players.LocalPlayer.Character then return false end
	local head: Instance? = Players.LocalPlayer.Character:FindFirstChild("Head")
	if not head then return false end
	if not head:IsA("BasePart") then return false end
	local camera: Camera = workspace.CurrentCamera
	local diff = (head.Position - camera.CFrame.Position).Magnitude
	if diff < (threshold or 0.5) then return true end
	return false
end

function PlayerUtilsLib:ForceFirstPerson(State: boolean)
	if State then
		Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
	end
end

function PlayerUtilsLib:IsPC(): boolean
	return UserInputService.MouseEnabled or UserInputService.KeyboardEnabled
end

function PlayerUtilsLib:IsMobile(): boolean
	return UserInputService.AccelerometerEnabled or UserInputService.GyroscopeEnabled
end

function PlayerUtilsLib:IsConsole(): boolean
	return UserInputService.GamepadEnabled
end

function PlayerUtilsLib:GetPlayerDevice(): string
	local pc: boolean = self:IsPC()
	local mobile: boolean = self:IsMobile()
	local console: boolean = self:IsConsole()
	if pc then
		return "PC"
	elseif mobile then
		return "MOBILE"
	elseif console then
		return "CONSOLE"
	end
	error(FormattingLib:FormatLogMessage(script, `Couldn't detect player device.`))
	return "UNKNOWN"
end

return PlayerUtilsLib
