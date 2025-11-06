local RaycastLib = {}

function RaycastLib:RaycastLookAt(
	raycastParamsToUse: RaycastParams,
	from: Vector3,
	to: Vector3,
	strength: number
): RaycastResult<BasePart> | boolean
	local rayResult: RaycastResult<BasePart>? =
		workspace:Raycast(from, CFrame.lookAt(from, to).LookVector * strength, raycastParamsToUse)

	if rayResult then
		return rayResult
	else
		return false
	end
end

function RaycastLib:RaycastFromTo(
	raycastParamsToUse: RaycastParams,
	from: Vector3,
	to: Vector3,
	strength: number
): RaycastResult<BasePart> | boolean
	local rayResult: RaycastResult<BasePart>? = workspace:Raycast(from, to * strength, raycastParamsToUse)

	if rayResult then
		return rayResult
	else
		return false
	end
end

return RaycastLib
