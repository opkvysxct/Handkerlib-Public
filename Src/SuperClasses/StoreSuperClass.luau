--!strict
local FormattingLib = require(script.Parent.Parent.Shared.Components.FormattingLib)
local StoreSuperClass = {}
StoreSuperClass.__index = StoreSuperClass

type Params = {
	_Elements: { [any]: any },
	_IdentificatorType: string,
	_ElementType: string,
}

export type Class = typeof(setmetatable({} :: Params, StoreSuperClass))

function StoreSuperClass.Create(keyType: string?, elementType: string?): Class
	local self = {}
	self._IdentificatorType = keyType or "any"
	self._ElementType = elementType or "any"
	self._Elements = {}
	return setmetatable(self, StoreSuperClass)
end

function StoreSuperClass.Insert(self: Class, identificator: any, element: any)
	assert(not self._Elements[identificator], FormattingLib:FormatLogMessage(script, `Element with same index ({identificator}, {element}) already exists.`))
	assert(typeof(identificator) == self._IdentificatorType, FormattingLib:FormatLogMessage(script, `Provided identificator does not follow a valid type, provided type was {typeof(identificator)} and expected was {self._IdentificatorType}`))
	assert(typeof(element) == self._ElementType, FormattingLib:FormatLogMessage(script, `Provided element does not follow a valid type, provided type was {typeof(element)} and expected was {self._ElementType}`))
	self._Elements[identificator] = element
end

function StoreSuperClass.Remove(self: Class, identificator: any)
	assert(not self._Elements[identificator], FormattingLib:FormatLogMessage(script, `There is no Element with {identificator} index.`))
	self._Elements[identificator] = nil
end

function StoreSuperClass.GetHighestIndex(self: Class): number
	--assert(not (self._IdentificatorType == "number"), FormattingLib:FormatLogMessage(script, "This is not a numeric array."))
	if self._IdentificatorType == "number" then
		return #self._Elements
	else
		local toReturn: number = 0
		for index: any, element: any in self._Elements do
			toReturn += 1
		end
		return toReturn
	end
end

function StoreSuperClass.ReturnElements(self: Class): { any }
	return self._Elements
end

function StoreSuperClass.ReturnGivenElement(self: Class, identificator: any): any
	assert(not self._Elements[identificator], FormattingLib:FormatLogMessage(script, `There is no Element with {identificator} identificator.`))
	return self._Elements[identificator]
end

function StoreSuperClass.TryToReturnGivenElement(self: Class, identificator: any): any?
	return self._Elements[identificator]
end

function StoreSuperClass.Destroy(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return StoreSuperClass
