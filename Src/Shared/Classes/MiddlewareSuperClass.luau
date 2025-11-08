local MiddlewareSuperClass = {}

type MiddlewareFunction = ({ any }) -> any?

export type Params = {
	MiddlewareConnections: { [number]: MiddlewareFunction },
}

function MiddlewareSuperClass:CreateParams(): Params
	return {
		MiddlewareConnections = {},
	}
end

function MiddlewareSuperClass:Run(params: Params, parameters: { any }): { any }
	for index: number, mConnection: MiddlewareFunction in params.MiddlewareConnections do
		local res: { any }? = mConnection(parameters)
		if res then
			parameters = res
		end
	end
	return parameters
end

function MiddlewareSuperClass:Connect(params: Params, conIndex: number, conFunc: MiddlewareFunction)
	for index: number, mConnection: MiddlewareFunction in params.MiddlewareConnections do
		if index == conIndex then
			error("[H] MiddlewareConnection with same index already exists.")
			return false
		end
	end
	params.MiddlewareConnections[conIndex] = conFunc
	return true
end

function MiddlewareSuperClass:Disconnect(params: Params, conIndex: number)
	local toDelete
	for index: number, mConnection: MiddlewareFunction in params.MiddlewareConnections do
		if index == conIndex then
			toDelete = index
			break
		end
	end
	if toDelete == nil then
		error("[H] Didn't found MiddelwareConnection with that index")
		return false
	end
	table.remove(params.MiddlewareConnections, toDelete)
	return true
end

function MiddlewareSuperClass:Clear(params: Params)
	table.clear(params)
	table.freeze(params)
end

return MiddlewareSuperClass
