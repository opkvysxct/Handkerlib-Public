local RaycasterClass = {}
RaycasterClass.__index = RaycasterClass

function RaycasterClass.Create(params: RaycastParams)
	local self = setmetatable({}, RaycasterClass)
	self.params = params
	return self
end

function RaycasterClass:RaycastLookAt(from: Vector3, to: Vector3, strength: number): RaycastResult<BasePart> | boolean
	local rayResult: RaycastResult<BasePart>? =
		workspace:Raycast(from, CFrame.lookAt(from, to).LookVector * strength, self.params)

	if rayResult then
		return rayResult
	else
		return false
	end
end

function RaycasterClass:RaycastFromTo(from: Vector3, to: Vector3, strength: number): RaycastResult<BasePart> | boolean
	local rayResult: RaycastResult<BasePart>? = workspace:Raycast(from, to * strength, self.params)

	if rayResult then
		return rayResult
	else
		return false
	end
end

function RaycasterClass:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return RaycasterClass
