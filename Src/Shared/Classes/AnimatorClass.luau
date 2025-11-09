local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InstanceLib = require(ReplicatedStorage.Handkerlib.Shared.Components.InstanceLib)
local AnimatorClass = {}

export type Params = {
	Anims: {
		Uncategorized: { [string]: AnimationTrack },
		Categorized: { [string]: { [string]: AnimationTrack } },
	},
	Animator: Animator,
}

function AnimatorClass:CreateParams(animator: Animator): Params
	return {
		Anims = {
			Uncategorized = {},
			Categorized = {},
		},
		Animator = animator,
	}
end

function AnimatorClass:NewCategory(params: Params, categoryName: string)
	params.Anims.Categorized[categoryName] = {}
end

function AnimatorClass:RemoveCategory(params: Params, categoryName: string)
	if not params.Anims.Categorized[categoryName] then
		error("[H] No category with given name: " .. categoryName)
	end
	params.Anims.Categorized[categoryName] = nil
end

function AnimatorClass:GetAnimTrack(params: Params, animName: string, categoryName: string?): AnimationTrack?
	local animTrackToReturn: AnimationTrack
	if categoryName then
		if not params.Anims[categoryName] then
			error("[H] No category with given name: " .. categoryName)
			return nil
		end
		if not params.Anims[categoryName][animName] then
			error("[H] No animation with given name: " .. animName)
			return nil
		end
		animTrackToReturn = params.Anims[categoryName][animName]
	else
		if not params.Anims.Uncategorized[animName] then
			error("[H] No animation with given name: " .. animName)
			return nil
		end
		animTrackToReturn = params.Anims.Uncategorized[animName]
	end
	return animTrackToReturn
end

function AnimatorClass:InsertNew(params: Params, anim: Animation | number, animName: string, categoryName: string?)
	local function DoLogic(animFianl: AnimationTrack)
		if categoryName then
			if not params.Anims.Categorized[categoryName] then
				error("[H] No category with given name: " .. categoryName)
			end
			params.Anims.Categorized[categoryName][animName] = animFianl
		else
			params.Anims.Uncategorized[animName] = animFianl
		end
	end
	if typeof(anim) == "number" then
		DoLogic(InstanceLib:CreateAndLoadAnimation(anim, params.Animator))
	elseif typeof(anim) == "Animation" then
		DoLogic(params.Animator:LoadAnimation(anim))
	else
		error("[H] Invalid type for : " .. anim)
	end
end

-- TODO AnimatorClass:BindToKeyFrameEvent()
function AnimatorClass:BindToKeyFrameEvent(
	params: Params,
	signalName: string,
	functionToUse: () -> nil,
	animName: string,
	categoryName: string?
)
	local animTrack: AnimationTrack? = AnimatorClass:GetAnimTrack(params, animName, categoryName)
	if not animTrack then
		return
	end
	animTrack:GetMarkerReachedSignal(signalName):Connect(functionToUse)
end

function AnimatorClass:RemoveAnim(params: Params, animName: string, categoryName: string?)
	AnimatorClass:GetAnimTrack(params, animName, categoryName) -- checks whether animtrack exists or not.
	if categoryName then
		params.Anims[categoryName][animName] = nil
	else
		params.Anims.Uncategorized[animName] = nil
	end
end

function AnimatorClass:GetAnimation(params: Params, categoryName: string, animationName: string): AnimationTrack?
	local animTrack: AnimationTrack? = AnimatorClass:GetAnimTrack(params, animationName, categoryName)
	if not animTrack then
		return nil
	end
	return animTrack
end

function AnimatorClass:GetRandom(params: Params, categoryName: string): AnimationTrack
	local allFromCategory = {}
	for name: string, anim: AnimationTrack in params.Anims.Categorized[categoryName] do
		-- from string to number conversion, order doesn't matter.
		table.insert(allFromCategory, anim)
	end
	return allFromCategory[math.random(1, #allFromCategory)]
end

function AnimatorClass:Clear(params: Params)
	table.clear(params)
	table.freeze(params)
end

return AnimatorClass
