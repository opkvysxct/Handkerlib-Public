--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lib_Formatting = require(ReplicatedStorage.Handkerlib.Shared.Components.Lib_Formatting)
local LClass_Cleaner = {}
LClass_Cleaner.__index = LClass_Cleaner

export type Type_Class = typeof(setmetatable(
	{} :: {
		_Instances: { Instance },
		_Objects: any,
		_Connections: { RBXScriptConnection },
		_Threads: { thread },
	},
	LClass_Cleaner
))

function LClass_Cleaner.Create(): Type_Class
	local self = {}
	self._Instances = {}
	self._Objects = {}
	self._Connections = {}
	self._Threads = {}
	return setmetatable(self, LClass_Cleaner)
end

function LClass_Cleaner.AddInstance(self: Type_Class, instance: Instance)
	table.insert(self._Instances, instance)
end

function LClass_Cleaner.AddObject(self: Type_Class, object: any)
	assert(typeof(object) == "table", Lib_Formatting:FormatLogMessage(script, `Object is not an class`))
	assert(table.find(object, "Destroy"), Lib_Formatting:FormatLogMessage(script, `Object does not have "Destroy" function.`))
	table.insert(self._Objects, object)
end

function LClass_Cleaner.AddConnection(self: Type_Class, connection: RBXScriptConnection)
	table.insert(self._Connections, connection)
end

function LClass_Cleaner.AddThread(self: Type_Class, thread: thread)
	table.insert(self._Threads, thread)
end

function LClass_Cleaner.CleanUp(self: Type_Class)
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

function LClass_Cleaner.Destroy(self: Type_Class)
	self:CleanUp()
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return LClass_Cleaner
