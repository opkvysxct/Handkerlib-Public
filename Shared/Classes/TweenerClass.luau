local TweenService = game:GetService("TweenService")
local TweenerClass = {}
TweenerClass.__index = TweenerClass

function TweenerClass.Create(time: number, defaultStyle: Enum.EasingStyle, defaultDirection: Enum.EasingDirection)
	local self = setmetatable({}, TweenerClass)
	self.defaultTime = time
	self.defaultStyle = defaultStyle
	self.defaultDirection = defaultDirection
	return self
end

function TweenerClass:TweenTable(
	tableToUse: { [any]: any },
	yield: boolean?,
	time: number?,
	style: Enum.EasingStyle?,
	direction: Enum.EasingDirection?
)
	time = time or self.DefaultTime
	style = style or self.DefaultStyle
	direction = direction or self.DefaultDirection
	for index: any, value: any in tableToUse do
		TweenService:Create(index, TweenInfo.new(time, style, direction), value):Play()
	end
	if yield then
		task.wait(time)
	end
	return
end

function TweenerClass:TweenOnce(
	element: { [any]: any },
	yield: boolean?,
	time: number?,
	style: Enum.EasingStyle?,
	direction: Enum.EasingDirection?
)
	time = time or self.DefaultTime
	style = style or self.DefaultStyle
	direction = direction or self.DefaultDirection
	TweenService:Create(element[1], TweenInfo.new(time, style, direction), element[2]):Play()
	if yield then
		task.wait(time)
	end
	return
end

function TweenerClass:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return TweenerClass
