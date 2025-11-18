--!strict
local RaycastLib = {}

function RaycastLib:RaycastLookAt(
	raycastParamsToUse: RaycastParams,
	from: Vector3,
	to: Vector3,
	strength: number
): RaycastResult?
	local rayResult: RaycastResult? =
		workspace:Raycast(from, CFrame.lookAt(from, to).LookVector * strength, raycastParamsToUse)

	if rayResult then
		return rayResult
	else
		return nil
	end
end

function RaycastLib:RaycastFromTo(
	raycastParamsToUse: RaycastParams,
	from: Vector3,
	to: Vector3,
	strength: number
): RaycastResult?
	local rayResult: RaycastResult? = workspace:Raycast(from, to * strength, raycastParamsToUse)

	if rayResult then
		return rayResult
	else
		return nil
	end
end

return RaycastLib
