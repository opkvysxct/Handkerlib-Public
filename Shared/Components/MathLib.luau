local MathLib = {}

function MathLib:Chance(percent: number, max: number): boolean
	if math.random(1, max) <= percent then
		return true
	else
		return false
	end
end

function MathLib:ReturnChance(percent: number, total: number): number
	return math.floor((percent / total * 100) * 10 + 0.5) / 10
end

function MathLib:Lerp(a: number, b: number, t: number): number
	return a + ((b - a) * t)
end

function MathLib:LerpVector3(v3: Vector3, goal: Vector3, alpha: number): Vector3
	return Vector3.new(self:Lerp(v3.X, goal.X, alpha), self:Lerp(v3.Y, goal.Y, alpha), self:Lerp(v3.Z, goal.Z, alpha))
end

return MathLib
