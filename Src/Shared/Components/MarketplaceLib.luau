--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local PlayerLib = require(script.Parent.PlayerLib)
local MarketplaceLib = {}

function MarketplaceLib:CheckPlayerGamepass(id: number, prompt: boolean, player: Player?): boolean
	local playerToUse: Player = PlayerLib:IsPlayer(player)
	local hasPass: boolean = false
	local success: boolean, message: string = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(playerToUse.UserId, id)
	end)
	if not success then
		warn("[H]", "Error while checking gamepass ownership", tostring(message))
		return false
	end
	if prompt == true then
		MarketplaceService:PromptGamePassPurchase(playerToUse, id)
	end
	return hasPass
end

function MarketplaceLib:PromptProductPurchase(id: number, player: Player?)
	MarketplaceService:PromptProductPurchase(PlayerLib:IsPlayer(player), id)
end

function MarketplaceLib:PromptPremiumPurchase(player: Player?)
	MarketplaceService:PromptPremiumPurchase(PlayerLib:IsPlayer(player))
end

return MarketplaceLib
