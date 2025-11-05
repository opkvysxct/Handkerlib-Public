local SpringClass = {}
SpringClass.__index = SpringClass

--WIP

function SpringClass.Create()
	local self = setmetatable({}, SpringClass)
	self.equalibrium = 0
	self.position = 0
	self.mass = 1
	self.constant = 1
	self.frequency = 1
	self.totalTime = 0
	return self
end

function SpringClass:Progress(deltaTime: number) end

function SpringClass:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return SpringClass
