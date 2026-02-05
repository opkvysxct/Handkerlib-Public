--!strict
local CLClass_Input = {}
CLClass_Input.__index = CLClass_Input

export type Type_Class = typeof(setmetatable(
	{} :: {
		Value: boolean,
	},
	CLClass_Input
))

function CLClass_Input.Create(): Type_Class
	local self = {}
	self.Value = true
	return setmetatable(self, CLClass_Input)
end

function CLClass_Input.Function(self: Type_Class) end

function CLClass_Input.Destroy(self: Type_Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return CLClass_Input
