--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lib_Formatting = require(ReplicatedStorage.Handkerlib.Shared.Components.Lib_Formatting)
local Lib_Instance = require(ReplicatedStorage.Handkerlib.Shared.Components.Lib_Instance)
local Type_Handker = require(ReplicatedStorage.Handkerlib.Type_Handker)
local LClass_Animator = {}
LClass_Animator.__index = LClass_Animator

export type Type_Class = typeof(setmetatable(
	{} :: {
		_Anims: {
			Uncategorized: { [string]: AnimationTrack },
			Categorized: { [string]: { [string]: AnimationTrack } },
		},
		_Animator: Animator,
	},
	LClass_Animator
))

function LClass_Animator.Create(animator: Animator): Type_Class
	local self = {}
	self._Anims = {}
	self._Anims.Uncategorized = {}
	self._Anims.Categorized = {}
	self._Animator = animator
	return setmetatable(self, LClass_Animator)
end

function LClass_Animator.NewCategory(self: Type_Class, categoryName: string)
	self._Anims.Categorized[categoryName] = {}
end

function LClass_Animator.RemoveCategory(self: Type_Class, categoryName: string)
	assert(not self._Anims.Categorized[categoryName], Lib_Formatting:FormatLogMessage(script, `No category with given name: {categoryName}`))
	self._Anims.Categorized[categoryName] = nil
end

function LClass_Animator.GetAnimTrack(self: Type_Class, animName: string, categoryName: string?): AnimationTrack
	local animTrackToReturn: AnimationTrack
	if categoryName then
		assert(self._Anims.Categorized[categoryName], Lib_Formatting:FormatLogMessage(script, `No category with given name: {categoryName}`))
		assert(self._Anims.Categorized[categoryName][animName], Lib_Formatting:FormatLogMessage(script, `No animation with given name: {animName}`))
		animTrackToReturn = self._Anims.Categorized[categoryName][animName]
	else
		assert(self._Anims.Uncategorized[animName], Lib_Formatting:FormatLogMessage(script, `No animation with given name: {animName}`))
		animTrackToReturn = self._Anims.Uncategorized[animName]
	end
	return animTrackToReturn
end

function LClass_Animator.InsertNew(self: Type_Class, animParams: Type_Handker.Type_AnimationSpecs, animName: string, categoryName: string?)
	local function DoLogic(animFinal: AnimationTrack)
		animFinal.Priority = animParams.Priority or animFinal.Priority
		animFinal.Looped = animParams.Looped or animFinal.Looped
		if animParams.Speed then animFinal:AdjustSpeed(animParams.Speed) end
		if animParams.Weight then animFinal:AdjustSpeed(animParams.Weight) end
		if categoryName then
			assert(self._Anims.Categorized[categoryName], Lib_Formatting:FormatLogMessage(script, `No category with given name: {categoryName}`))
			assert(not self._Anims.Categorized[categoryName][animName], Lib_Formatting:FormatLogMessage(script, `Animation {animName} in {categoryName} already exists.`))
			self._Anims.Categorized[categoryName][animName] = animFinal
		else
			assert(not self._Anims.Uncategorized[animName], Lib_Formatting:FormatLogMessage(script, `Animation {animName} already exists.`))
			self._Anims.Uncategorized[animName] = animFinal
		end
	end
	if typeof(animParams.AnimationId) == "number" then
		DoLogic(Lib_Instance:CreateAndLoadAnimation(animParams.AnimationId, self._Animator))
	elseif typeof(animParams.AnimationId) == "Animation" then
		DoLogic(self._Animator:LoadAnimation(animParams.AnimationId))
	else
		error(Lib_Formatting:FormatLogMessage(script, `Invalid type for : {animParams.AnimationId}`))
	end
end

function LClass_Animator.BindToKeyFrameEvent(self: Type_Class, signalName: string, functionToUse: (params: string) -> nil, animName: string, categoryName: string?)
	local animTrack: AnimationTrack = self:GetAnimTrack(animName, categoryName)
	animTrack:GetMarkerReachedSignal(signalName):Connect(functionToUse)
end

function LClass_Animator.RemoveAnim(self: Type_Class, animName: string, categoryName: string?)
	self:GetAnimTrack(animName, categoryName) -- checks whether animtrack exists or not.
	if categoryName then
		self._Anims.Categorized[categoryName][animName] = nil
	else
		self._Anims.Uncategorized[animName] = nil
	end
end

function LClass_Animator.GetRandom(self: Type_Class, categoryName: string): AnimationTrack
	local allFromCategory = {}
	for name: string, anim: AnimationTrack in self._Anims.Categorized[categoryName] do
		-- from string to number conversion, order doesn't matter.
		table.insert(allFromCategory, anim)
	end
	return allFromCategory[math.random(1, #allFromCategory)]
end

function LClass_Animator.Destroy(self: Type_Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return LClass_Animator
