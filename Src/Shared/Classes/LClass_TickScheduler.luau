--!strict
local LClass_Cleaner = require(script.Parent.LClass_Cleaner)
local LClass_TickScheduler = {}
LClass_TickScheduler.__index = LClass_TickScheduler

type Type_TickFunction = () -> nil

export type Type_FunctionStoreType = Type_TickFunction
export type Type_Class = typeof(setmetatable(
	{} :: {
		_TicksPerSecond: number,
		_CanRun: boolean,
		_Cleaner: LClass_Cleaner.Type_Class,
		FunctionStore: { [number]: () -> nil },
	},
	LClass_TickScheduler
))

function LClass_TickScheduler.Create(ticksPerSecond: number): Type_Class
	local self = {}
	self._TicksPerSecond = ticksPerSecond
	self._CanRun = true
	self._Cleaner = LClass_Cleaner.Create()
	self.FunctionStore = {}
	return setmetatable(self, LClass_TickScheduler)
end

function LClass_TickScheduler.Run(self: Type_Class)
	self._Cleaner:AddThread(task.spawn(function()
		while task.wait(1 / self._TicksPerSecond) and self._CanRun do
			for index: number, functionToUse: Type_TickFunction in self.FunctionStore do
				functionToUse()
			end
		end
	end))
end

function LClass_TickScheduler.Stop(self: Type_Class)
	self._CanRun = false
	self._Cleaner:CleanUp()
end

function LClass_TickScheduler.Destroy(self: Type_Class)
	self:Stop()
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return LClass_TickScheduler
