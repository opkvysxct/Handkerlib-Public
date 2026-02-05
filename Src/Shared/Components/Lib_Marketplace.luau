--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Lib_Formatting = require(script.Parent.Lib_Formatting)
local Lib_Player = require(script.Parent.Lib_Player)
local Lib_Marketplace = {}

function Lib_Marketplace:CheckPlayerGamepass(id: number, prompt: boolean, player: Player?): boolean
	local playerToUse: Player = Lib_Player:IsPlayer(player)
	local hasPass: boolean = false
	local success: boolean, message: string = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(playerToUse.UserId, id)
	end)
	if not success then
		warn(Lib_Formatting:FormatLogMessage(script, `Error while checking gamepass ownership {tostring(message)}`))
		return false
	end
	if prompt == true then MarketplaceService:PromptGamePassPurchase(playerToUse, id) end
	return hasPass
end

function Lib_Marketplace:PromptProductPurchase(id: number, player: Player?)
	MarketplaceService:PromptProductPurchase(Lib_Player:IsPlayer(player), id)
end

function Lib_Marketplace:PromptPremiumPurchase(player: Player?)
	MarketplaceService:PromptPremiumPurchase(Lib_Player:IsPlayer(player))
end

function Lib_Marketplace:CheckProductPrice(id: number): number?
	local price: number? = MarketplaceService:GetProductInfoAsync(id, Enum.InfoType.Product).PriceInRobux
	if price then
		return price
	else
		return
	end
end

function Lib_Marketplace:CheckGamepassPrice(id: number): number?
	local price: number? = MarketplaceService:GetProductInfoAsync(id, Enum.InfoType.GamePass).PriceInRobux
	if price then
		return price
	else
		return
	end
end

return Lib_Marketplace
