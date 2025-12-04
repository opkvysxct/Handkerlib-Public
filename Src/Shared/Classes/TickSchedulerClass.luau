--!strict
local CleanerClass = require(script.Parent.CleanerClass)
local StoreSuperClass = require(script.Parent.Parent.Parent.SuperClasses.StoreSuperClass)
local TickSchedulerClass = {}
TickSchedulerClass.__index = TickSchedulerClass

type Params = {
	_TicksPerSecond: number,
	_CanRun: boolean,
	_Cleaner: CleanerClass.Class,
	FunctionStore: StoreSuperClass.Class,
}

export type Class = typeof(setmetatable({} :: Params, TickSchedulerClass))

function TickSchedulerClass.Create(ticksPerSecond: number): Class
	local self = {}
	self._TicksPerSecond = ticksPerSecond
	self._CanRun = true
	self._Cleaner = CleanerClass.Create()
	self.FunctionStore = StoreSuperClass.Create("number", "function")
	return setmetatable(self, TickSchedulerClass)
end

function TickSchedulerClass.Run(self: Class)
	self._Cleaner:AddThread(task.spawn(function()
		while task.wait(1 / self._TicksPerSecond) and self._CanRun do
			for index: number, functionToUse: () -> nil in self.FunctionStore:ReturnElements() do
				functionToUse()
			end
		end
	end))
end

function TickSchedulerClass.Stop(self: Class)
	self._CanRun = false
	self._Cleaner:CleanUp()
end

function TickSchedulerClass.Destroy(self: Class)
	self:Stop()
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return TickSchedulerClass
