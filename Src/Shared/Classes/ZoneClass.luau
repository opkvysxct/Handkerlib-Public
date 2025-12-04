local ZoneClass = {}
ZoneClass.__index = ZoneClass

type Params = {
	Value: boolean,
}

export type Class = typeof(setmetatable({} :: Params, ZoneClass))

function ZoneClass.Create(): Class
	local self = {}
	self.Value = true
	return setmetatable(self, ZoneClass)
end

function ZoneClass.Function(self: Class) end

function ZoneClass.Destroy(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return ZoneClass
