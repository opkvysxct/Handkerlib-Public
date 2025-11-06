local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InstanceLib = require(ReplicatedStorage.Handkerlib.Shared.Components.InstanceLib)
local AnimatorClass = {}

export type Params = {
	Anims: {
		Uncategorized: {},
		Categorized: {},
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

function AnimatorClass:RemoveAnim(params: Params, animName: string, categoryName: string?)
	if categoryName then
		params.Anims[categoryName][animName] = nil
	else
		params.Anims.Uncategorized[animName] = nil
	end
end

function AnimatorClass:GetAnimation(params: Params, categoryName: string, animationName: string): AnimationTrack
	if not params.Anims.Categorized[categoryName] then
		error("[H] No category with given name: " .. categoryName)
	end
	if not params.Anims.Categorized[categoryName][animationName] then
		error("[H] No animation with given name: " .. animationName)
	end
	return params.Anims.Categorized[categoryName][animationName]
end

function AnimatorClass:GetRandom(params: Params, categoryName: string): AnimationTrack
	local allFromCategory = {}
	for name: string, anim: AnimationTrack in params.Anims.Categorized[categoryName] do -- from string to number conversion.
		table.insert(allFromCategory, anim)
	end
	return allFromCategory[math.random(1, #allFromCategory)]
end

return AnimatorClass
