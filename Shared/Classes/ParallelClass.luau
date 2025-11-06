local ParallelClass = {}

-- WIP

function ParallelClass:CreateParams(idString: string, moduleToUse: BaseScript)
	self._threads = {}
	self.idString = idString
	self.moduleToUse = moduleToUse
	return
end

function ParallelClass:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return ParallelClass
