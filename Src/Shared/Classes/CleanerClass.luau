--!strict
local FormattingLib = require(script.Parent.Parent.Components.FormattingLib)
local CleanerClass = {}
CleanerClass.__index = CleanerClass

type Params = {
	_Instances: { Instance },
	_Objects: any,
	_Connections: { RBXScriptConnection },
	_Threads: { thread },
}

export type Class = typeof(setmetatable({} :: Params, CleanerClass))

function CleanerClass.Create(): Class
	local self = {}
	self._Instances = {}
	self._Objects = {}
	self._Connections = {}
	self._Threads = {}
	return setmetatable(self, CleanerClass)
end

function CleanerClass.AddInstance(self: Class, instance: Instance)
	table.insert(self._Instances, instance)
end

function CleanerClass.AddObject(self: Class, object: any)
	assert(typeof(object) == "table", FormattingLib:FormatLogMessage(script, `Object is not an class`))
	assert(table.find(object, "Destroy"), FormattingLib:FormatLogMessage(script, `Object does not have "Destroy" function.`))
	table.insert(self._Objects, object)
end

function CleanerClass.AddConnection(self: Class, connection: RBXScriptConnection)
	table.insert(self._Connections, connection)
end

function CleanerClass.AddThread(self: Class, thread: thread)
	table.insert(self._Threads, thread)
end

function CleanerClass.CleanUp(self: Class)
	for index: number, instance: Instance in self._Instances do
		instance:Destroy()
	end
	table.clear(self._Instances)

	for index: number, connection: RBXScriptConnection in self._Connections do
		connection:Disconnect()
	end
	table.clear(self._Connections)

	for index: number, object: any in self._Objects do
		object:Destroy()
	end
	table.clear(self._Objects)

	for index: number, thread: thread in self._Threads do
		task.cancel(thread)
	end
	table.clear(self._Threads)
end

function CleanerClass.Destroy(self: Class)
	self:CleanUp()
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return CleanerClass
