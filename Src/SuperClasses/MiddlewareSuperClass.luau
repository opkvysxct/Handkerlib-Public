--!strict
local StoreSuperClass = require(script.Parent.StoreSuperClass)
local MiddlewareSuperClass = {}
MiddlewareSuperClass.__index = MiddlewareSuperClass

type MiddlewareFunction = ({ any }) -> any?

type Params = {
	MiddlewareConnectionsStore: StoreSuperClass.Class,
}

export type Class = typeof(setmetatable({} :: Params, MiddlewareSuperClass))

function MiddlewareSuperClass.Create(): Class
	local self = {}
	self.MiddlewareConnectionsStore = StoreSuperClass.Create()
	return setmetatable(self, MiddlewareSuperClass)
end

function MiddlewareSuperClass.Run(self: Class, parameters: { any }): { any }
	for index: number, mConnection: MiddlewareFunction in self.MiddlewareConnectionsStore:ReturnElements() do
		local res: { any }? = mConnection(parameters)
		if res then
			parameters = res
		end
	end
	return parameters
end

function MiddlewareSuperClass.Clear(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return MiddlewareSuperClass
