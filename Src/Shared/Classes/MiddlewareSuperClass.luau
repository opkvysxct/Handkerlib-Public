local MiddlewareSuperClass = {}
MiddlewareSuperClass.__index = MiddlewareSuperClass

type MiddlewareFunction = ({ any }) -> any?

type Params = {
	MiddlewareConnections: { [number]: MiddlewareFunction },
}

export type Class = typeof(setmetatable({} :: Params, MiddlewareSuperClass))

function MiddlewareSuperClass.Create(): Class
	local self = {}
	self.MiddlewareConnections = {}
	return setmetatable(self, MiddlewareSuperClass)
end

function MiddlewareSuperClass.Run(self: Class, parameters: { any }): { any }
	for index: number, mConnection: MiddlewareFunction in self.MiddlewareConnections do
		local res: { any }? = mConnection(parameters)
		if res then
			parameters = res
		end
	end
	return parameters
end

function MiddlewareSuperClass.Connect(self: Class, conIndex: number, conFunc: MiddlewareFunction)
	for index: number, mConnection: MiddlewareFunction in self.MiddlewareConnections do
		if index == conIndex then
			error("[H] MiddlewareConnection with same index already exists.")
		end
	end
	self.MiddlewareConnections[conIndex] = conFunc
end

function MiddlewareSuperClass.Disconnect(self: Class, conIndex: number)
	local toDelete: number
	for index: number, mConnection: MiddlewareFunction in self.MiddlewareConnections do
		if index == conIndex then
			toDelete = index
			break
		end
	end
	if not toDelete then
		error("[H] Didn't found MiddelwareConnection with that index")
	end
	table.remove(self.MiddlewareConnections, toDelete)
end

function MiddlewareSuperClass.GetHighestIndex(self: Class): number
	return #self.MiddlewareConnections
end

function MiddlewareSuperClass.Clear(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return MiddlewareSuperClass
