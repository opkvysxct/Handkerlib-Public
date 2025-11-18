--!strict
local TweenService = game:GetService("TweenService")
local TweenerClass = {}
TweenerClass.__index = TweenerClass

type Params = {
	DefaultTime: number,
	DefaultStyle: Enum.EasingStyle,
	DefaultDirection: Enum.EasingDirection,
}

export type Class = typeof(setmetatable({} :: Params, TweenerClass))

function TweenerClass.Create(
	defaultTime: number,
	defaultStyle: Enum.EasingStyle,
	defaultDirection: Enum.EasingDirection
): Class
	local self = {}
	self.DefaultTime = defaultTime
	self.DefaultStyle = defaultStyle
	self.DefaultDirection = defaultDirection
	return setmetatable(self, TweenerClass)
end

function TweenerClass.TweenTable(
	self: Class,
	tableToUse: { [any]: any },
	yield: boolean?,
	overwriteTime: number?,
	overwriteStyle: Enum.EasingStyle?,
	overwriteDirection: Enum.EasingDirection?
)
	local timeToUse: number = overwriteTime or self.DefaultTime
	local styleToUse: Enum.EasingStyle = overwriteStyle or self.DefaultStyle
	local directionToUse: Enum.EasingDirection = overwriteDirection or self.DefaultDirection
	for index: any, value: any in tableToUse do
		TweenService:Create(index, TweenInfo.new(timeToUse, styleToUse, directionToUse), value):Play()
	end
	if yield then
		task.wait(timeToUse)
	end
	return
end

function TweenerClass.TweenOnce(
	self: Class,
	element: { [any]: any },
	yield: boolean?,
	overwriteTime: number?,
	overwriteStyle: Enum.EasingStyle?,
	overwriteDirection: Enum.EasingDirection?
)
	local timeToUse: number = overwriteTime or self.DefaultTime
	local styleToUse: Enum.EasingStyle = overwriteStyle or self.DefaultStyle
	local directionToUse: Enum.EasingDirection = overwriteDirection or self.DefaultDirection
	TweenService:Create(element[1], TweenInfo.new(timeToUse, styleToUse, directionToUse), element[2]):Play()
	if yield then
		task.wait(timeToUse)
	end
	return
end

function TweenerClass.Clear(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return TweenerClass
