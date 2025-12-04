--!strict
local FormattingLib = require(script.Parent.Parent.Components.FormattingLib)
local InstanceLib = require(script.Parent.Parent.Components.InstanceLib)
local AnimatorClass = {}
AnimatorClass.__index = AnimatorClass

type Params = {
	_Anims: {
		Uncategorized: { [string]: AnimationTrack },
		Categorized: { [string]: { [string]: AnimationTrack } },
	},
	_Animator: Animator,
}

export type Class = typeof(setmetatable({} :: Params, AnimatorClass))

function AnimatorClass.Create(animator: Animator): Class
	local self = {}
	self._Anims = {}
	self._Anims.Uncategorized = {}
	self._Anims.Categorized = {}
	self._Animator = animator
	return setmetatable(self, AnimatorClass)
end

function AnimatorClass.NewCategory(self: Class, categoryName: string)
	self._Anims.Categorized[categoryName] = {}
end

function AnimatorClass.RemoveCategory(self: Class, categoryName: string)
	assert(not self._Anims.Categorized[categoryName], FormattingLib:FormatLogMessage(script, `No category with given name: {categoryName}`))
	self._Anims.Categorized[categoryName] = nil
end

function AnimatorClass.GetAnimTrack(self: Class, animName: string, categoryName: string?): AnimationTrack?
	local animTrackToReturn: AnimationTrack
	if categoryName then
		assert(self._Anims.Categorized[categoryName], FormattingLib:FormatLogMessage(script, `No category with given name: {categoryName}`))
		assert(self._Anims.Categorized[categoryName][animName], FormattingLib:FormatLogMessage(script, `No animation with given name: {animName}`))
		animTrackToReturn = self._Anims.Categorized[categoryName][animName]
	else
		assert(self._Anims.Uncategorized[animName], FormattingLib:FormatLogMessage(script, `No animation with given name: {animName}`))
		animTrackToReturn = self._Anims.Uncategorized[animName]
	end
	return animTrackToReturn
end

function AnimatorClass.InsertNew(self: Class, anim: Animation | number, animName: string, categoryName: string?)
	local function DoLogic(animFianl: AnimationTrack)
		if categoryName then
			assert(self._Anims.Categorized[categoryName], FormattingLib:FormatLogMessage(script, `No category with given name: {categoryName}`))
			self._Anims.Categorized[categoryName][animName] = animFianl
		else
			self._Anims.Uncategorized[animName] = animFianl
		end
	end
	if typeof(anim) == "number" then
		DoLogic(InstanceLib:CreateAndLoadAnimation(anim, self._Animator))
	elseif typeof(anim) == "Animation" then
		DoLogic(self._Animator:LoadAnimation(anim))
	else
		error(FormattingLib:FormatLogMessage(script, `Invalid type for : {anim}`))
	end
end

function AnimatorClass.BindToKeyFrameEvent(self: Class, signalName: string, functionToUse: () -> nil, animName: string, categoryName: string?)
	local animTrack: AnimationTrack? = self:GetAnimTrack(animName, categoryName)
	if not animTrack then return end
	animTrack:GetMarkerReachedSignal(signalName):Connect(functionToUse)
end

function AnimatorClass.RemoveAnim(self: Class, animName: string, categoryName: string?)
	self:GetAnimTrack(animName, categoryName) -- checks whether animtrack exists or not.
	if categoryName then
		self._Anims.Categorized[categoryName][animName] = nil
	else
		self._Anims.Uncategorized[animName] = nil
	end
end

function AnimatorClass.GetAnimation(self: Class, categoryName: string, animationName: string): AnimationTrack?
	local animTrack: AnimationTrack? = self:GetAnimTrack(animationName, categoryName)
	if not animTrack then return nil end
	return animTrack
end

function AnimatorClass.GetRandom(self: Class, categoryName: string): AnimationTrack
	local allFromCategory = {}
	for name: string, anim: AnimationTrack in self._Anims.Categorized[categoryName] do
		-- from string to number conversion, order doesn't matter.
		table.insert(allFromCategory, anim)
	end
	return allFromCategory[math.random(1, #allFromCategory)]
end

function AnimatorClass.Destroy(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return AnimatorClass
