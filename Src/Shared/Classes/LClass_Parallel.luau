--!strict
local LClass_Parallel = {}
LClass_Parallel.__index = LClass_Parallel

type Type_Thread = {
	UsedScript: BaseScript,
	UsedActor: Actor,
}

export type Type_Class = typeof(setmetatable(
	{} :: {
		_ScriptToUse: BaseScript,
		_Threads: { Type_Thread },
	},
	LClass_Parallel
))

function LClass_Parallel.Create(scriptToUse: BaseScript, threads: number, where: Instance): Type_Class
	local self = {}
	self._ScriptToUse = scriptToUse
	self._Threads = {}
	for index: number = 1, threads do
		local createdActor: Actor = Instance.new("Actor")
		createdActor.Parent = where
		createdActor.Name = index .. "_" .. scriptToUse.Name
		local clonedScript: BaseScript = scriptToUse:Clone()
		clonedScript.Parent = createdActor
		local thread: Type_Thread = {
			UsedScript = clonedScript,
			UsedActor = createdActor,
		}
		table.insert(self._Threads, thread)
	end
	return setmetatable(self, LClass_Parallel)
end

function LClass_Parallel.SendMessage(self: Type_Class, identificator: string, ...: any)
	for index: number, thread: Type_Thread in self._Threads do
		thread.UsedActor:SendMessage(identificator, ...)
	end
end

function LClass_Parallel.Destroy(self: Type_Class)
	for index: number, thread: Type_Thread in self._Threads do
		thread.UsedScript:Destroy()
		thread.UsedActor:Destroy()
	end
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return LClass_Parallel
