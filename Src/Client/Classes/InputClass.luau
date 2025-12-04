--!strict
local InputClass = {}
InputClass.__index = InputClass

type Params = {
	Value: boolean,
}

export type Class = typeof(setmetatable({} :: Params, InputClass))

function InputClass.Create(): Class
	local self = {}
	self.Value = true
	return setmetatable(self, InputClass)
end

function InputClass.Function(self: Class) end

function InputClass.Destroy(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return InputClass
