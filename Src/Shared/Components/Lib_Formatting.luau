--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Type_Handker = require(ReplicatedStorage.Handkerlib.Type_Handker)
local Lib_Formatting = {}

Lib_Formatting.AbbreviationsTemplate = {
	N = 10 ^ 30,
	O = 10 ^ 27,
	Sp = 10 ^ 24,
	Sx = 10 ^ 21,
	Qn = 10 ^ 18,
	Qd = 10 ^ 15,
	T = 10 ^ 12,
	B = 10 ^ 9,
	M = 10 ^ 6,
	K = 10 ^ 3,
}

function Lib_Formatting:FormatLogMessage(script: Type_Handker.Type_Scripts, message: string): string
	return `[{script.Name}] - {message}`
end

function Lib_Formatting:FormatTime(timeToFormat: number): string
	return "TODO"
end

function Lib_Formatting:FormatHugeNumbers(numberToFormat: number, abbreviations: { [string]: number }): string
	local abbreviatedNum: string = tostring(numberToFormat)
	local abbreviationChosen: number = 0

	for abbreviation, num in pairs(abbreviations or self.AbbreviationsTemplate) do
		if numberToFormat >= num and num > abbreviationChosen then
			local shortNum: number = math.floor((numberToFormat / num) * 100) / 100
			abbreviatedNum = tostring(string.format("%.2f", shortNum)) .. abbreviation
			abbreviationChosen = num
		end
	end
	return abbreviatedNum
end

return Lib_Formatting
