--!strict
local ParallelClass = {}
ParallelClass.__index = ParallelClass

type Thread = {
	UsedScript: BaseScript,
	UsedActor: Actor,
}

type Params = {
	_ScriptToUse: BaseScript,
	_Threads: { Thread },
}

export type Class = typeof(setmetatable({} :: Params, ParallelClass))

function ParallelClass.Create(scriptToUse: BaseScript, threads: number, where: Instance): Class
	local self = {}
	self._ScriptToUse = scriptToUse
	self._Threads = {}
	for index: number = 1, threads do
		local createdActor: Actor = Instance.new("Actor")
		createdActor.Parent = where
		createdActor.Name = index .. "_" .. scriptToUse.Name
		local clonedScript: BaseScript = scriptToUse:Clone()
		clonedScript.Parent = createdActor
		local thread: Thread = {
			UsedScript = clonedScript,
			UsedActor = createdActor,
		}
		table.insert(self._Threads, thread)
	end
	return setmetatable(self, ParallelClass)
end

function ParallelClass.SendMessage(self: Class, identificator: string, ...: any)
	for index: number, thread: Thread in self._Threads do
		thread.UsedActor:SendMessage(identificator, ...)
	end
end

function ParallelClass.Destroy(self: Class)
	for index: number, thread: Thread in self._Threads do
		thread.UsedScript:Destroy()
		thread.UsedActor:Destroy()
	end
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return ParallelClass
