--!strict
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Type_Handker = require(ReplicatedStorage.Handkerlib.Type_Handker)
local Lib_Formatting = require(script.Parent.Lib_Formatting)
local Lib_Instance = {}

function Lib_Instance:CreatePoint(where: Vector3): Attachment
	local attachment: Attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame.new(where)
	attachment.Parent = Workspace
	return attachment
end

function Lib_Instance:CreateSound(where: Instance | Vector3, specs: Type_Handker.Type_SoundSpecs): (Sound, Attachment?)
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

function Lib_Instance:CreateAndPlaySoundOnce(where: Instance | Vector3, specs: any)
	local sound: Sound, toDelete: Attachment? = self:CreateSound(where, specs)
	task.spawn(function()
		sound:Play()
		sound.Ended:Wait()
		if toDelete then
			toDelete:Destroy()
		else
			sound:Destroy()
		end
	end)
end

function Lib_Instance:CloneAndEmitParticle(where: Instance | Vector3, particle: ParticleEmitter, strength: number, autoDisable: boolean?, minTime: number?): ParticleEmitter
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

function Lib_Instance:CreateAndLoadAnimation(animationId: number, animator: Animator): AnimationTrack
	local animation: Animation = Instance.new("Animation")
	animation.Parent = animator
	animation.AnimationId = "rbxassetid://" .. animationId
	return animator:LoadAnimation(animation)
end

function Lib_Instance:BulkCreateMotor6D(primary: BasePart, secondary: { Instance }, parent: Instance?)
	if not parent then parent = primary end
	for index: number, thing: Instance in secondary do
		if thing:IsA("BasePart") and primary ~= thing then
			local motor6D: Motor6D = Instance.new("Motor6D")
			motor6D.Name = thing.Name
			motor6D.Parent = parent

			motor6D.C0 = primary.CFrame:Inverse() * thing.CFrame
			motor6D.C1 = CFrame.new()

			motor6D.Part0 = primary
			motor6D.Part1 = thing
		end
	end
end

function Lib_Instance:BulkCreateWeldConstraint(primary: BasePart, secondary: { Instance }, parent: Instance?)
	if not parent then parent = primary end
	for index: number, thing: Instance in secondary do
		if thing:IsA("BasePart") and primary ~= thing then
			local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")
			weldConstraint.Name = thing.Name
			weldConstraint.Parent = parent
			weldConstraint.Part0 = primary
			weldConstraint.Part1 = thing
		end
	end
end

function Lib_Instance:BulkChangeCollisionGroup(instances: { Instance }, CollisionGroup: string)
	for index: number, instance: Instance in instances do
		if instance:IsA("BasePart") then instance.CollisionGroup = CollisionGroup end
	end
end

function Lib_Instance:SearchFor(startFrom: Instance, originalPath: string): Instance | any
	local convertedPath: { string } = string.split(originalPath, ".")
	local currentInstance: Instance? = startFrom
	assert(currentInstance, Lib_Formatting:FormatLogMessage(script, `startFrom was not a valid instance.`))
	for index: number, path: string in convertedPath do
		currentInstance = currentInstance:FindFirstChild(path)
		assert(currentInstance, Lib_Formatting:FormatLogMessage(script, `Instance {path} not found.`))
	end
	return currentInstance
end

function Lib_Instance:WaitFor(startFrom: Instance, originalPath: string, timeout: number?): Instance | any
	local convertedPath: { string } = string.split(originalPath, ".")
	local currentInstance: Instance? = startFrom
	assert(currentInstance, Lib_Formatting:FormatLogMessage(script, `startFrom was not a valid instance.`))
	for index: number, path: string in convertedPath do
		currentInstance = currentInstance:WaitForChild(path, timeout or 5)
		assert(currentInstance, Lib_Formatting:FormatLogMessage(script, `Instance {path} not found.`))
	end
	return currentInstance
end

function Lib_Instance:LookForAttribute(lookIn: { Instance }, attributeName: string, attributeValue: any): (Instance | any)?
	for index: number, instance: Instance in lookIn do
		local givenAttribute: any = instance:GetAttribute(attributeName)
		if givenAttribute then
			if givenAttribute == attributeValue then return instance end
		end
	end
	return
end

return Lib_Instance
