local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InstanceLib = require(ReplicatedStorage.Handkerlib.Shared.Components.InstanceLib)
local AnimatorClass = {}
AnimatorClass.__index = AnimatorClass

function AnimatorClass.Create(animator: Animator)
	local self = setmetatable({}, AnimatorClass)
	self.anims = {
		uncategorized = {},
		categorized = {},
	}
	self.animator = animator
	return self
end

function AnimatorClass:NewCategory(categoryName: string)
	self.anims.categorized[categoryName] = {}
end

function AnimatorClass:RemoveCategory(categoryName: string)
	if not self.anims.categorized[categoryName] then
		error("[H] No category with given name: " .. categoryName)
	end
	self.anims.categorized[categoryName] = nil
end

function AnimatorClass:InsertNew(anim: Animation | number, animName: string, categoryName: string?)
	local function DoLogic(animFianl: AnimationTrack)
		if categoryName then
			if not self.anims.categorized[categoryName] then
				error("[H] No category with given name: " .. categoryName)
			end
			self.anims.categorized[categoryName][animName] = animFianl
		else
			self.anims.uncategorized[animName] = animFianl
		end
	end
	if typeof(anim) == "number" then
		DoLogic(InstanceLib:CreateAndLoadAnimation(anim, self.animator))
	elseif typeof(anim) == "Animation" then
		DoLogic(self.animator:LoadAnimation(anim))
	else
		error("[H] Invalid type for : " .. anim)
	end
end

function AnimatorClass:RemoveAnim(animName: string, categoryName: string?)
	if categoryName then
		self.anims[categoryName][animName] = nil
	else
		self.anims.uncategorized[animName] = nil
	end
end

function AnimatorClass:GetAnimation(categoryName: string, animationName: string): AnimationTrack
	if not self.anims.categorized[categoryName] then
		error("[H] No category with given name: " .. categoryName)
	end
	if not self.anims.categorized[categoryName][animationName] then
		error("[H] No animation with given name: " .. animationName)
	end
	return self.anims.categorized[categoryName][animationName]
end

function AnimatorClass:GetRandom(categoryName: string): AnimationTrack
	local allFromCategory = {}
	for name: string, anim: AnimationTrack in self.anims.categorized[categoryName] do -- from string to number conversion.
		table.insert(allFromCategory, anim)
	end
	return allFromCategory[math.random(1, #allFromCategory)]
end

function AnimatorClass:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return AnimatorClass
