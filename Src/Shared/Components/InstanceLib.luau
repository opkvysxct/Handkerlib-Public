--!strict
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local Types = require(script.Parent.Parent.Parent.Types)
local InstanceLib = {}

function InstanceLib:CreatePoint(where: Vector3): Attachment
	local attachment: Attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame.new(where)
	attachment.Parent = Workspace
	return attachment
end

function InstanceLib:CreateSound(where: Instance | Vector3, specs: Types.SoundSpecs): (Sound, Attachment?)
	local toDelete: Attachment?
	local sound: Sound
	if typeof(where) == "Vector3" then
		local newWhere: Attachment = self:CreatePoint(where)
		where = newWhere
		toDelete = newWhere
	end
	sound = Instance.new("Sound")
	sound.Parent = where :: Instance | Attachment
	sound.Name = specs.Name or "Sound"
	sound.SoundId = "rbxassetid://" .. (specs.SoundId or 0)
	sound.Volume = specs.Volume or 1
	sound.PlaybackSpeed = specs.PlaybackSpeed or 1
	sound.RollOffMaxDistance = specs.MaxDistance or 1000
	sound.RollOffMinDistance = specs.MinDistance or 10
	sound.SoundGroup = specs.SoundGroup or nil
	return sound, toDelete
end

function InstanceLib:CreateAndPlaySoundOnce(where: Instance | Vector3, specs: any)
	local sound: Sound, toDelete: Attachment? = self:CreateSound(where, specs)
	sound:Play()
	sound.Ended:Wait()
	if toDelete then
		toDelete:Destroy()
	else
		sound:Destroy()
	end
end

function InstanceLib:CloneAndEmitParticle(where: Instance | Vector3, particle: ParticleEmitter, strength: number, autoDisable: boolean?, minTime: number?): ParticleEmitter
	local toDelete: Attachment?
	local newParticle: ParticleEmitter
	if typeof(where) == "Vector3" then
		local newWhere: Attachment = self:CreatePoint(where)
		where = newWhere
		toDelete = newWhere
	end
	newParticle = particle:Clone()
	if autoDisable then newParticle.Enabled = false end
	newParticle.Parent = where :: Instance
	newParticle:Emit(strength)

	if toDelete then
		Debris:AddItem(where :: Instance, newParticle.Lifetime.Max + (minTime or 1))
	else
		Debris:AddItem(newParticle, newParticle.Lifetime.Max + (minTime or 1))
	end
	return newParticle
end

function InstanceLib:CreateAndLoadAnimation(animationId: number, animator: Animator): AnimationTrack
	local animation: Animation = Instance.new("Animation")
	animation.Parent = animator
	animation.AnimationId = "rbxassetid://" .. animationId
	return animator:LoadAnimation(animation)
end

function InstanceLib:CreateMotor6D(first: BasePart, second: BasePart, parent: Instance): Motor6D
	local motor6D: Motor6D = Instance.new("Motor6D")
	motor6D.Parent = parent
	motor6D.Part0 = first
	motor6D.Part1 = second
	return motor6D
end

return InstanceLib
