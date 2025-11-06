local TweenService = game:GetService("TweenService")
local TweenerClass = {}

export type Params = {
	DefaultTime: number,
	DefaultStyle: Enum.EasingStyle,
	DefaultDirection: Enum.EasingDirection,
}

function TweenerClass:CreateParams(
	time: number,
	defaultStyle: Enum.EasingStyle,
	defaultDirection: Enum.EasingDirection
): Params
	return {
		DefaultTime = time,
		DefaultStyle = defaultStyle,
		DefaultDirection = defaultDirection,
	}
end

function TweenerClass:TweenTable(
	params: Params,
	tableToUse: { [any]: any },
	yield: boolean?,
	overwriteTime: number?,
	overwriteStyle: Enum.EasingStyle?,
	overwriteDirection: Enum.EasingDirection?
)
	local timeToUse: number = overwriteTime or params.DefaultTime
	local styleToUse: Enum.EasingStyle = overwriteStyle or params.DefaultStyle
	local directionToUse: Enum.EasingDirection = overwriteDirection or params.DefaultDirection
	for index: any, value: any in tableToUse do
		TweenService:Create(index, TweenInfo.new(timeToUse, styleToUse, directionToUse), value):Play()
	end
	if yield then
		task.wait(timeToUse)
	end
	return
end

function TweenerClass:TweenOnce(
	params: Params,
	element: { [any]: any },
	yield: boolean?,
	overwriteTime: number?,
	overwriteStyle: Enum.EasingStyle?,
	overwriteDirection: Enum.EasingDirection?
)
	local timeToUse: number = overwriteTime or params.DefaultTime
	local styleToUse: Enum.EasingStyle = overwriteStyle or params.DefaultStyle
	local directionToUse: Enum.EasingDirection = overwriteDirection or params.DefaultDirection
	TweenService:Create(element[1], TweenInfo.new(timeToUse, styleToUse, directionToUse), element[2]):Play()
	if yield then
		task.wait(timeToUse)
	end
	return
end

return TweenerClass
