--!strict
local Lib_Time = {}

Lib_Time.Globals = {}
Lib_Time.Globals.Second = 1
Lib_Time.Globals.Minute = 60
Lib_Time.Globals.Hour = 3600
Lib_Time.Globals.Day = 86400
Lib_Time.Globals.Week = 604800
Lib_Time.Globals.Month = 2629800 -- On avarage, using 365.25/12
Lib_Time.Globals.Year = 31557600 -- Also using 365.25

return Lib_Time
