--!strict
local ParallelClass = {}
ParallelClass.__index = ParallelClass

type Thread = {
	UsedScript: BaseScript,
	UsedActor: Actor,
}

type Params = {
	ScriptToUse: BaseScript,
	Threads: { Thread },
}

export type Class = typeof(setmetatable({} :: Params, ParallelClass))

function ParallelClass.Create(scriptToUse: BaseScript, threads: number, where: Instance?): Class
	local self = {}
	self.ScriptToUse = scriptToUse
	self.Threads = {}
	for index: number = 1, threads do
		local createdActor: Actor = Instance.new("Actor", where)
		createdActor.Name = index .. "_" .. scriptToUse.Name
		local clonedScript: BaseScript = scriptToUse:Clone()
		clonedScript.Parent = createdActor
		local thread: Thread = {
			UsedScript = clonedScript,
			UsedActor = createdActor,
		}
		table.insert(self.Threads, thread)
	end
	return setmetatable(self, ParallelClass)
end

function ParallelClass.SendMessage(self: Class, identificator: string, ...: any)
	for index: number, thread: Thread in self.Threads do
		thread.UsedActor:SendMessage(identificator, ...)
	end
end

function ParallelClass.Clear(self: Class)
	for index: number, thread: Thread in self.Threads do
		thread.UsedScript:Destroy()
		thread.UsedActor:Destroy()
	end
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return ParallelClass
