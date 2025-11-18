--!strict
local StoreSuperClass = {}
StoreSuperClass.__index = StoreSuperClass

type Params = {
	Elements: { [number | any]: any },
	Type: boolean,
}

export type Class = typeof(setmetatable({} :: Params, StoreSuperClass))

function StoreSuperClass.Create(numeric: boolean?): Class
	local self = {}
	self.Type = numeric or true
	self.Elements = {}
	return setmetatable(self, StoreSuperClass)
end

function StoreSuperClass.Insert(self: Class, identificator: number | any, element: any)
	if self.Elements[identificator] then
		error("[H] Element with same index already exists.")
	end
	self.Elements[identificator] = element
end

function StoreSuperClass.Remove(self: Class, identificator: number | any)
	if not self.Elements[identificator] then
		error("[H] There is no Element with that index.")
	end
	self.Elements[identificator] = nil
end

function StoreSuperClass.GetHighestIndex(self: Class): number
	if not self.Type then
		error("[H] This is not a numeric array.")
	end
	return #self.Elements
end

function StoreSuperClass.ReturnElements(self: Class): { any }
	return self.Elements
end

function StoreSuperClass.ReturnGivenElement(self: Class, identificator: number | any): any
	if not self.Elements[identificator] then
		error("[H] There is no Element with that index.")
	end
	return self.Elements[identificator]
end

function StoreSuperClass.TryToReturnGivenElement(self: Class, identificator: number | any): any?
	return self.Elements[identificator]
end

function StoreSuperClass.Clear(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return StoreSuperClass
