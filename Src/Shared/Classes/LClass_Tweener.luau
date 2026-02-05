--!strict
local TweenService = game:GetService("TweenService")
local LClass_Tweener = {}
LClass_Tweener.__index = LClass_Tweener

export type Type_Class = typeof(setmetatable(
	{} :: {
		_DefaultTime: number,
		_DefaultStyle: Enum.EasingStyle,
		_DefaultDirection: Enum.EasingDirection,
		_DefaultRepeatCount: number,
		_DefaultReverse: boolean,
	},
	LClass_Tweener
))

function LClass_Tweener.Create(defaultTime: number?, defaultStyle: Enum.EasingStyle?, defaultDirection: Enum.EasingDirection?, repeatCount: number?, reverse: boolean?): Type_Class
	local self = {}
	self._DefaultTime = defaultTime or 0
	self._DefaultStyle = defaultStyle or Enum.EasingStyle.Linear
	self._DefaultDirection = defaultDirection or Enum.EasingDirection.InOut
	self._DefaultRepeatCount = repeatCount or 0
	self._DefaultReverse = reverse or false
	return setmetatable(self, LClass_Tweener)
end

function LClass_Tweener.TweenTableYield(self: Type_Class, tableToUse: { { [any]: any } }, yield: boolean?, overwriteTime: number?, overwriteStyle: Enum.EasingStyle?, overwriteDirection: Enum.EasingDirection?)
	local timeToUse: number = overwriteTime or self._DefaultTime
	local styleToUse: Enum.EasingStyle = overwriteStyle or self._DefaultStyle
	local directionToUse: Enum.EasingDirection = overwriteDirection or self._DefaultDirection
	for index: number, element: any in tableToUse do
		TweenService:Create(element[1], TweenInfo.new(timeToUse, styleToUse, directionToUse), element[2]):Play()
	end
	if yield then task.wait(timeToUse) end
	return
end

function LClass_Tweener.TweenOnceYield(
	self: Type_Class,
	element: { [any]: any },
	yield: boolean?,
	overwriteTime: number?,
	overwriteStyle: Enum.EasingStyle?,
	overwriteDirection: Enum.EasingDirection?,
	overwriteRepeatCount: number?,
	overwriteReverse: boolean?
)
	local timeToUse: number = overwriteTime or self._DefaultTime
	local styleToUse: Enum.EasingStyle = overwriteStyle or self._DefaultStyle
	local directionToUse: Enum.EasingDirection = overwriteDirection or self._DefaultDirection
	local repeatCount: number = overwriteRepeatCount or self._DefaultRepeatCount
	local reverse: boolean = overwriteReverse or self._DefaultReverse
	TweenService:Create(element[1], TweenInfo.new(timeToUse, styleToUse, directionToUse, repeatCount, reverse), element[2]):Play()
	if yield then task.wait(timeToUse) end
	return
end

function LClass_Tweener.Destroy(self: Type_Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return LClass_Tweener
