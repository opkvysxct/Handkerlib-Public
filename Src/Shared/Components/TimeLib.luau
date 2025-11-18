--!strict
local TimeLib = {}

TimeLib.Globals = {}
TimeLib.Globals.Second = 1
TimeLib.Globals.Minute = 60
TimeLib.Globals.Hour = 3600
TimeLib.Globals.Day = 86400
TimeLib.Globals.Week = 604800
TimeLib.Globals.Month = 2629800 -- On avarage, using 365.25/12
TimeLib.Globals.Year = 31557600 -- Also using 365.25

return TimeLib
