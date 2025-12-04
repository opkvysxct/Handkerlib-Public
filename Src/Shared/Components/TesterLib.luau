--!strict
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
		if numberToCheck > maxRange or numberToCheck < minRange then return false end
	end
	return true
end

function TesterLib:ValidateString(stringToCheck: string, maxLenght: number?): boolean
	if typeof(stringToCheck) ~= "string" then return false end
	if stringToCheck:len() > (maxLenght or 32) then return false end
	return true
end

return TesterLib
