local MiddlewareSuperClass = {}
MiddlewareSuperClass.__index = MiddlewareSuperClass

type MiddlewareFunction = ({ any }) -> any | nil

function MiddlewareSuperClass.Create()
	local self = setmetatable({}, MiddlewareSuperClass)
	self._middlewareConnections = {}
	return self
end

function MiddlewareSuperClass:Run(parameters: { any }): { any }
	for index: number, mConnection: MiddlewareFunction in self._middlewareConnections do
		local res: { any }? = mConnection(parameters)
		if res then
			parameters = res
		end
	end
	return parameters
end

function MiddlewareSuperClass:Connect(conIndex: number, conFunc: MiddlewareFunction)
	for index: number, mConnection: MiddlewareFunction in self._middlewareConnections do
		if index == conIndex then
			error("[H] MiddlewareConnection with same index already exists.")
			return false
		end
	end
	self._middlewareConnections[conIndex] = conFunc
	return true
end

function MiddlewareSuperClass:Disconnect(conIndex: number)
	local toDelete
	for index: number, mConnection: MiddlewareFunction in self._middlewareConnections do
		if index == conIndex then
			toDelete = index
			break
		end
	end
	if toDelete == nil then
		error("[H] Didn't found MiddelwareConnection with that index")
		return false
	end
	table.remove(self._middlewareConnections, toDelete)
	return true
end

function MiddlewareSuperClass:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return MiddlewareSuperClass
