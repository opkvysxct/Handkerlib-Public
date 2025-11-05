local ParallelClass = {}
ParallelClass.__index = ParallelClass

function ParallelClass.Create()
	local self = setmetatable({}, ParallelClass)
	self.threads = {}
	return self
end

function ParallelClass:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return ParallelClass
