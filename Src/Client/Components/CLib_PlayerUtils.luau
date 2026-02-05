--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lib_Formatting = require(ReplicatedStorage.Handkerlib.Shared.Components.Lib_Formatting)
local CLib_PlayerUtils = {}

function CLib_PlayerUtils:IsFirstPerson(threshold: number?): boolean
	if not Players.LocalPlayer.Character then return false end
	local head: Instance? = Players.LocalPlayer.Character:FindFirstChild("Head")
	if not head then return false end
	if not head:IsA("BasePart") then return false end
	local camera: Camera = workspace.CurrentCamera
	local diff = (head.Position - camera.CFrame.Position).Magnitude
	if diff < (threshold or 0.5) then return true end
	return false
end

function CLib_PlayerUtils:ForceFirstPerson(State: boolean)
	if State then
		Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
	end
end

function CLib_PlayerUtils:IsPC(): boolean
	return UserInputService.MouseEnabled or UserInputService.KeyboardEnabled
end

function CLib_PlayerUtils:IsMobile(): boolean
	return UserInputService.AccelerometerEnabled or UserInputService.GyroscopeEnabled
end

function CLib_PlayerUtils:IsConsole(): boolean
	return UserInputService.GamepadEnabled
end

function CLib_PlayerUtils:GetPlayerDevice(): string
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
	error(Lib_Formatting:FormatLogMessage(script, `Couldn't detect player device.`))
	return "UNKNOWN"
end

return CLib_PlayerUtils
