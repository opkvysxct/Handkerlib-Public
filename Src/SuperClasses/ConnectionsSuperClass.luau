--!strict
local StoreSuperClass = require(script.Parent.StoreSuperClass)
local ConnectionsSuperClass = {}
ConnectionsSuperClass.__index = ConnectionsSuperClass

type ConnectionFunction = ({ any }) -> nil

type Params = {
	ConnectionsStore: StoreSuperClass.Class,
}

export type Class = typeof(setmetatable({} :: Params, ConnectionsSuperClass))

function ConnectionsSuperClass.Create(): Class
	local self = {}
	self.ConnectionsStore = StoreSuperClass.Create("number", "function")
	return setmetatable(self, ConnectionsSuperClass)
end

function ConnectionsSuperClass.Run(self: Class, whatChanged: { any })
	for index: number, connectionFunction: ConnectionFunction in self.ConnectionsStore:ReturnElements() do
		connectionFunction(whatChanged)
	end
end

function ConnectionsSuperClass.Destroy(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return ConnectionsSuperClass
