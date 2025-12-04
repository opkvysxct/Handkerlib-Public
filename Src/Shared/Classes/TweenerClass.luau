--!strict
local TweenService = game:GetService("TweenService")
local TweenerClass = {}
TweenerClass.__index = TweenerClass

type Params = {
	_DefaultTime: number,
	_DefaultStyle: Enum.EasingStyle,
	_DefaultDirection: Enum.EasingDirection,
}

export type Class = typeof(setmetatable({} :: Params, TweenerClass))

function TweenerClass.Create(defaultTime: number, defaultStyle: Enum.EasingStyle, defaultDirection: Enum.EasingDirection): Class
	local self = {}
	self._DefaultTime = defaultTime
	self._DefaultStyle = defaultStyle
	self._DefaultDirection = defaultDirection
	return setmetatable(self, TweenerClass)
end

function TweenerClass.TweenTable(self: Class, tableToUse: { [any]: any }, yield: boolean?, overwriteTime: number?, overwriteStyle: Enum.EasingStyle?, overwriteDirection: Enum.EasingDirection?)
	local timeToUse: number = overwriteTime or self._DefaultTime
	local styleToUse: Enum.EasingStyle = overwriteStyle or self._DefaultStyle
	local directionToUse: Enum.EasingDirection = overwriteDirection or self._DefaultDirection
	for index: any, value: any in tableToUse do
		TweenService:Create(index, TweenInfo.new(timeToUse, styleToUse, directionToUse), value):Play()
	end
	if yield then task.wait(timeToUse) end
	return
end

function TweenerClass.TweenOnce(self: Class, element: { [any]: any }, yield: boolean?, overwriteTime: number?, overwriteStyle: Enum.EasingStyle?, overwriteDirection: Enum.EasingDirection?)
	local timeToUse: number = overwriteTime or self._DefaultTime
	local styleToUse: Enum.EasingStyle = overwriteStyle or self._DefaultStyle
	local directionToUse: Enum.EasingDirection = overwriteDirection or self._DefaultDirection
	TweenService:Create(element[1], TweenInfo.new(timeToUse, styleToUse, directionToUse), element[2]):Play()
	if yield then task.wait(timeToUse) end
	return
end

function TweenerClass.Destroy(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return TweenerClass
