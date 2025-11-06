local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Types = require(ReplicatedStorage.Handkerlib.Types)
local InstanceLib = {}

function InstanceLib:CreatePoint(where: Vector3): Attachment
	local toReturn: Attachment = Instance.new("Attachment")
	toReturn.CFrame.Position = where
	toReturn.Parent = Workspace
	return toReturn
end

function InstanceLib:CreateSound(
	where: Instance | Vector3,
	specs: Types.SoundSpecs,
	minTime: number?
): (Sound, Attachment?)
	local toDelete: Attachment
	local sound: Sound
	if typeof(where) == "Vector3" then
		local newWhere: Attachment = InstanceLib:CreatePoint(where)
		where = newWhere
		toDelete = newWhere
	end
	sound = Instance.new("Sound", where)
	sound.Name = specs.Name or "Sound"
	sound.SoundId = "rbxassetid://" .. (specs.SoundId or 0)
	sound.Volume = specs.Volume or 1
	sound.PlaybackSpeed = specs.PlaybackSpeed or 1
	sound.RollOffMaxDistance = specs.MaxDistance or 1000
	sound.RollOffMinDistance = specs.MinDistance or 10
	sound.SoundGroup = specs.SoundGroup or nil

	sound:Play()

	if toDelete then
		Debris:AddItem(where, sound.TimeLength + (minTime or 1))
	else
		Debris:AddItem(sound, sound.TimeLength + (minTime or 1))
	end
	return sound, toDelete
end

function InstanceLib:CreateAndPlaySound(where: Instance | Vector3, specs: any, minTime: number?)
	local sound: Sound, toDelete: Attachment? = InstanceLib:CreateSound(where, specs, minTime)
	sound:Play()
	if toDelete then
		Debris:AddItem(where, sound.TimeLength + (minTime or 1))
	else
		Debris:AddItem(sound, sound.TimeLength + (minTime or 1))
	end
end

function InstanceLib:CreateAndEmitParticle(
	where: Instance | Vector3,
	particle: ParticleEmitter,
	strength: number,
	autoDisable: boolean?,
	minTime: number?
): ParticleEmitter
	local toDelete: Attachment
	local newParticle: ParticleEmitter
	if typeof(where) == "Vector3" then
		local newWhere: Attachment = InstanceLib:CreatePoint(where)
		where = newWhere
		toDelete = newWhere
	end
	newParticle = particle:Clone()
	if autoDisable then
		newParticle.Enabled = false
	end
	newParticle.Parent = where :: Instance
	newParticle:Emit(strength)

	if toDelete then
		Debris:AddItem(where, newParticle.Lifetime.Max + (minTime or 1))
	else
		Debris:AddItem(newParticle, newParticle.Lifetime.Max + (minTime or 1))
	end
	return newParticle
end

function InstanceLib:CreateAndLoadAnimation(animationId: number, animator: Animator): AnimationTrack
	local animation: Animation = Instance.new("Animation", animator)
	animation.AnimationId = "rbxassetid://" .. animationId
	return animator:LoadAnimation(animation)
end

function InstanceLib:CreateMotor6D(first: BasePart, second: BasePart, parent: Instance): Motor6D
	local motor6D: Motor6D = Instance.new("Motor6D", parent)
	motor6D.Part0 = first
	motor6D.Part1 = second
	return motor6D
end

function InstanceLib:PutToParallel(scriptToUse: BaseScript, where: Instance, count: number?): Types.ThreadTable
	local threads: Types.ThreadTable = nil
	for i = 1, count or 1 do
		local actor: Actor = Instance.new("Actor")
		actor.Name = scriptToUse.Name .. "_Actor"
		actor.Parent = where

		local newScriptToUse = scriptToUse:Clone() :: BaseScript
		newScriptToUse.Parent = actor

		table.insert(threads, {
			["Script"] = scriptToUse,
			["Actor"] = actor,
		})
	end
	return threads
end

return InstanceLib
