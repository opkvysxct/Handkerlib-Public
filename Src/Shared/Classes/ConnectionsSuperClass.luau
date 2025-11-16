local ConnectionsSuperClass = {}
ConnectionsSuperClass.__index = ConnectionsSuperClass

type ConnectionFunction = ({ any }) -> nil

type Params = {
	Connections: { [number]: ConnectionFunction },
}

export type Class = typeof(setmetatable({} :: Params, ConnectionsSuperClass))

function ConnectionsSuperClass.Create(): Class
	local self = {}
	self.Connections = {}
	return setmetatable(self, ConnectionsSuperClass)
end

function ConnectionsSuperClass.Run(self: Class, whatChanged: { any })
	for index: number, connectionFunction: ConnectionFunction in self.Connections do
		connectionFunction(whatChanged)
	end
end

function ConnectionsSuperClass.Connect(self: Class, conIndex: number, conFunc: ConnectionFunction)
	for index: number, connection: ConnectionFunction in self.Connections do
		if index == conIndex then
			error("[H] Connection with same index already exists.")
		end
	end
	self.Connections[conIndex] = conFunc
end

function ConnectionsSuperClass.Disconnect(self: Class, conIndex: number)
	local toDelete: number
	for index: number, connection: ConnectionFunction in self.Connections do
		if index == conIndex then
			toDelete = index
			break
		end
	end
	if not toDelete then
		error("[H] Didn't found Connection with that index")
	end
	table.remove(self.Connections, toDelete)
end

function ConnectionsSuperClass.GetHighestIndex(self: Class): number
	return #self.Connections
end

function ConnectionsSuperClass.Clear(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return ConnectionsSuperClass
