--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InstanceLib = require(ReplicatedStorage.Handkerlib.Shared.Components.InstanceLib)
local AnimatorClass = {}
AnimatorClass.__index = AnimatorClass

type Params = {
	Anims: {
		Uncategorized: { [string]: AnimationTrack },
		Categorized: { [string]: { [string]: AnimationTrack } },
	},
	Animator: Animator,
}

export type Class = typeof(setmetatable({} :: Params, AnimatorClass))

function AnimatorClass.Create(animator: Animator): Class
	local self = {}
	self.Anims = {}
	self.Anims.Uncategorized = {}
	self.Anims.Categorized = {}
	self.Animator = animator
	return setmetatable(self, AnimatorClass)
end

function AnimatorClass.NewCategory(self: Class, categoryName: string)
	self.Anims.Categorized[categoryName] = {}
end

function AnimatorClass.RemoveCategory(self: Class, categoryName: string)
	if not self.Anims.Categorized[categoryName] then
		error("[H] No category with given name: " .. categoryName)
	end
	self.Anims.Categorized[categoryName] = nil
end

function AnimatorClass.GetAnimTrack(self: Class, animName: string, categoryName: string?): AnimationTrack?
	local animTrackToReturn: AnimationTrack
	if categoryName then
		if not self.Anims[categoryName] then
			error("[H] No category with given name: " .. categoryName)
			return nil
		end
		if not self.Anims[categoryName][animName] then
			error("[H] No animation with given name: " .. animName)
			return nil
		end
		animTrackToReturn = self.Anims[categoryName][animName]
	else
		if not self.Anims.Uncategorized[animName] then
			error("[H] No animation with given name: " .. animName)
			return nil
		end
		animTrackToReturn = self.Anims.Uncategorized[animName]
	end
	return animTrackToReturn
end

function AnimatorClass.InsertNew(self: Class, anim: Animation | number, animName: string, categoryName: string?)
	local function DoLogic(animFianl: AnimationTrack)
		if categoryName then
			if not self.Anims.Categorized[categoryName] then
				error("[H] No category with given name: " .. categoryName)
			end
			self.Anims.Categorized[categoryName][animName] = animFianl
		else
			self.Anims.Uncategorized[animName] = animFianl
		end
	end
	if typeof(anim) == "number" then
		DoLogic(InstanceLib:CreateAndLoadAnimation(anim, self.Animator))
	elseif typeof(anim) == "Animation" then
		DoLogic(self.Animator:LoadAnimation(anim))
	else
		error("[H] Invalid type for : " .. anim)
	end
end

function AnimatorClass.BindToKeyFrameEvent(
	self: Class,
	signalName: string,
	functionToUse: () -> nil,
	animName: string,
	categoryName: string?
)
	local animTrack: AnimationTrack? = self:GetAnimTrack(animName, categoryName)
	if not animTrack then
		return
	end
	animTrack:GetMarkerReachedSignal(signalName):Connect(functionToUse)
end

function AnimatorClass.RemoveAnim(self: Class, animName: string, categoryName: string?)
	self:GetAnimTrack(animName, categoryName) -- checks whether animtrack exists or not.
	if categoryName then
		self.Anims[categoryName][animName] = nil
	else
		self.Anims.Uncategorized[animName] = nil
	end
end

function AnimatorClass.GetAnimation(self: Class, categoryName: string, animationName: string): AnimationTrack?
	local animTrack: AnimationTrack? = self:GetAnimTrack(animationName, categoryName)
	if not animTrack then
		return nil
	end
	return animTrack
end

function AnimatorClass.GetRandom(self: Class, categoryName: string): AnimationTrack
	local allFromCategory = {}
	for name: string, anim: AnimationTrack in self.Anims.Categorized[categoryName] do
		-- from string to number conversion, order doesn't matter.
		table.insert(allFromCategory, anim)
	end
	return allFromCategory[math.random(1, #allFromCategory)]
end

function AnimatorClass.Clear(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return AnimatorClass
