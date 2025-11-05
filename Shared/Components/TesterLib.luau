local TesterLib = {}

function TesterLib:ValidateNumber(numberToCheck: number, minRange: number?, maxRange: number?): boolean
	if typeof(numberToCheck) ~= "number" then -- Not a number
		return false
	end
	if numberToCheck ~= numberToCheck then -- number, but a NaN
		return false
	end
	if math.abs(numberToCheck) == math.huge then -- Infinite number
		return false
	end
	if minRange and maxRange then
		if numberToCheck > maxRange or numberToCheck < minRange then
			return false
		end
	end
	return true
end

function TesterLib:ValidateString(stringToCheck: string, maxLenght: number?): boolean
	if typeof(stringToCheck) ~= "string" then
		return false
	end
	if stringToCheck:len() > (maxLenght or 32) then
		return false
	end
	return true
end

--[[function TesterLib:ValidateTable(listToCheck: any, templateList: any, stringLimit: number?): boolean
	for index: any, value: any in listToCheck do
		local corresponding = templateList[index] -- change this
		if not corresponding then
			return false
		end
		if typeof(value) ~= typeof(corresponding) then
			return false
		end
		for _, additionalValue: any in { index, value } do
			if typeof(additionalValue) == "number" then
				local success: boolean = self:ValidateNumber(value)
				if not success then
					return false
				end
			elseif typeof(additionalValue) == "string" then
				local success: boolean = self:ValidateString(value, stringLimit or 256)
				if not success then
					return false
				end
			end
		end
		if typeof(corresponding) == "table" then
			local success: boolean = self:ValidateTable(value, corresponding)
			if not success then
				return false
			end
		end
	end
	return true
end]]

return TesterLib
