--!strict
local Types = require(script.Parent.Parent.Parent.Types)
local FormattingLib = {}

function FormattingLib:FormatLogMessage(script: Types.Scripts, message: string): string
	return `[{script.Name}] - {message}`
end

return FormattingLib
