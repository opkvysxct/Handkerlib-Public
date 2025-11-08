local ParallelClass = {}

type Thread = {
	UsedScript: BaseScript,
	UsedActor: Actor,
}

export type Params = {
	ScriptToUse: BaseScript,
	_Threads: { Thread },
}

function ParallelClass:CreateParams(scriptToUse: BaseScript, threads: number, where: Instance?): Params
	local toReturn: Params = {
		ScriptToUse = scriptToUse,
		_Threads = {},
	}
	for index: number = 1, threads do
		local createdActor: Actor = Instance.new("Actor", where)
		createdActor.Name = index .. "_" .. scriptToUse.Name
		local clonedScript: BaseScript = scriptToUse:Clone()
		clonedScript.Parent = createdActor
		local thread: Thread = {
			UsedScript = clonedScript,
			UsedActor = createdActor,
		}
		table.insert(toReturn._Threads, thread)
	end
	return toReturn
end

function ParallelClass:SendMessage(params: Params, identificator: string, ...: any)
	for index: number, thread: Thread in params._Threads do
		thread.UsedActor:SendMessage(identificator, ...)
	end
end

function ParallelClass:Clear(params: Params)
	for index: number, thread: Thread in params._Threads do
		thread.UsedScript:Destroy()
		thread.UsedActor:Destroy()
	end
	table.clear(params)
	table.freeze(params)
end

return ParallelClass
