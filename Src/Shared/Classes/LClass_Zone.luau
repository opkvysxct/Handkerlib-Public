--!strict
local HttpService = game:GetService("HttpService")
local PhysicsService = game:GetService("PhysicsService")
--local FormattingLib = require(script.Parent.Parent.Components.FormattingLib)
local LClass_Zone = {}
LClass_Zone.__index = LClass_Zone

export type Type_Class = typeof(setmetatable(
	{} :: {
		_ZoneId: string,
		_ZoneRegions: { [number]: BasePart },
		_AffectedPlayers: { [number]: Player },
	},
	LClass_Zone
))

function LClass_Zone.Create(zones: { BasePart }): Type_Class
	local self = {}
	self._ZoneId = HttpService:GenerateGUID(false)
	self._ZoneRegions = {}
	self._AffectedPlayers = {}

	PhysicsService:RegisterCollisionGroup(self._ZoneId)
	PhysicsService:CollisionGroupSetCollidable(self._ZoneId, "Default", false)

	for index: number, part: BasePart in zones do
		part.CollisionGroup = self._ZoneId
		table.insert(self._ZoneRegions, part)
	end

	return setmetatable(self, LClass_Zone)
end

function LClass_Zone.Start(self: Type_Class) end

function LClass_Zone.Stop(self: Type_Class) end

function LClass_Zone.Destroy(self: Type_Class)
	self:Stop()
	PhysicsService:UnregisterCollisionGroup(self._ZoneId)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return LClass_Zone
