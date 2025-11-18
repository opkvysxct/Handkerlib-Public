--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StoreSuperClass = require(ReplicatedStorage.Handkerlib.SuperClasses.StoreSuperClass)
local TickSchedulerClass = {}
TickSchedulerClass.__index = TickSchedulerClass

type Params = {
	TicksPerSecond: number,
	CanRun: boolean,
	FunctionStore: StoreSuperClass.Class,
}

export type Class = typeof(setmetatable({} :: Params, TickSchedulerClass))

function TickSchedulerClass.Create(ticksPerSecond: number): Class
	local self = {}
	self.TicksPerSecond = ticksPerSecond
	self.CanRun = true
	self.FunctionStore = StoreSuperClass.Create()
	return setmetatable(self, TickSchedulerClass)
end

function TickSchedulerClass.Run(self: Class)
	while task.wait(1 / self.TicksPerSecond) and self.CanRun do
		for index: number, functionToUse: () -> nil in self.FunctionStore:ReturnElements() do
			functionToUse()
		end
	end
end

function TickSchedulerClass.Clear(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return TickSchedulerClass
