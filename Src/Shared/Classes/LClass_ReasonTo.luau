--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lib_Formatting = require(ReplicatedStorage.Handkerlib.Shared.Components.Lib_Formatting)
local LClass_ReasonTo = {}
LClass_ReasonTo.__index = LClass_ReasonTo

export type Type_Class = typeof(setmetatable(
	{} :: {
		Reasons: {
			Any: number,
			Specific: { string },
		},
	},
	LClass_ReasonTo
))

function LClass_ReasonTo.Create(): Type_Class
	local self = {}
	self.Reasons = {
		Any = 0,
		Specific = {},
	}
	return setmetatable(self, LClass_ReasonTo)
end

function LClass_ReasonTo.AddAnyReasonTo(self: Type_Class)
	self.Reasons.Any += 1
end

function LClass_ReasonTo.RemoveAnyReasonTo(self: Type_Class)
	assert(self.Reasons.Any > 0, Lib_Formatting:FormatLogMessage(script, `Can't remove any reason when there are none to remove.`))
	self.Reasons.Any -= 1
end

function LClass_ReasonTo.AddSpecificReasonTo(self: Type_Class, reasonName: string)
	assert(not table.find(self.Reasons.Specific, reasonName), Lib_Formatting:FormatLogMessage(script, `Given reason "{reasonName}" already exists.`))
	table.insert(self.Reasons.Specific, reasonName)
end

function LClass_ReasonTo.RemoveSpecificReasonTo(self: Type_Class, reasonName: string)
	assert(table.find(self.Reasons.Specific, reasonName), Lib_Formatting:FormatLogMessage(script, `No reason "{reasonName}" exists.`))
	table.remove(self.Reasons.Specific, table.find(self.Reasons.Specific, reasonName))
end

function LClass_ReasonTo.AreThereReasonsTo(self: Type_Class): boolean
	if self.Reasons.Any > 0 or #self.Reasons.Specific > 0 then return true end
	return false
end

function LClass_ReasonTo.Destroy(self: Type_Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return LClass_ReasonTo
