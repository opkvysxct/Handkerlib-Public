--!strict
local Lib_Raycast = {}

function Lib_Raycast:RaycastLookAt(raycastParamsToUse: RaycastParams, from: Vector3, to: Vector3, strength: number): RaycastResult?
	local rayResult: RaycastResult? = workspace:Raycast(from, CFrame.lookAt(from, to).LookVector * strength, raycastParamsToUse)

	if rayResult then
		return rayResult
	else
		return nil
	end
end

function Lib_Raycast:RaycastFromTo(raycastParamsToUse: RaycastParams, from: Vector3, to: Vector3, strength: number): RaycastResult?
	local rayResult: RaycastResult? = workspace:Raycast(from, to * strength, raycastParamsToUse)

	if rayResult then
		return rayResult
	else
		return nil
	end
end

return Lib_Raycast
