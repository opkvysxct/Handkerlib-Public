local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Handkerlib.Types)
local ReceiptProcessorClass = {}

type ProductFunction = (receiptInfo: Types.ReceiptInfo, player: Player) -> nil
type GamepassFunction = (gamepassId: number, player: Player) -> nil

export type Params = {
	Products: { [number]: ProductFunction },
	Gamepasses: { [number]: GamepassFunction },
}

function ReceiptProcessorClass:Create(): Params
	local params: Params = {
		Products = {},
		Gamepasses = {},
	}
	ReceiptProcessorClass:_Run(params)
	return params
end

function ReceiptProcessorClass:AddProductListener(params: Params, id: number, funcAfter: ProductFunction)
	params.Products[id] = funcAfter
end

function ReceiptProcessorClass:AddGamepassListener(params: Params, id: number, funcAfter: GamepassFunction)
	params.Gamepasses[id] = funcAfter
end

function ReceiptProcessorClass:_Run(params: Params)
	MarketplaceService.ProcessReceipt = function(receiptInfo: Types.ReceiptInfo): Enum.ProductPurchaseDecision
		local userId: number = receiptInfo.PlayerId
		local productId: number = receiptInfo.ProductId

		local player: Player? = Players:GetPlayerByUserId(userId)
		if not player then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end

		local handler: ProductFunction = params.Products[productId]
		local success: boolean = pcall(handler, receiptInfo, player)
		if success then
			print("[H] Product Granted", player, productId)
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("[H] Failed to process receipt:", receiptInfo)
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
	end

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(
		function(player: Player, gamepassId: number, wasPurchased: boolean)
			if not wasPurchased then
				return
			end
			local handler: GamepassFunction = params.Gamepasses[gamepassId]
			local success: boolean = pcall(handler, gamepassId, player)
			if success then
				print("[H] Purchase Granted", player, gamepassId)
			else
				warn("[H] Failed to process receipt:", gamepassId)
			end
		end
	)
end

function MarketplaceService:Clear(params: Params)
	table.clear(params)
	table.freeze(params)
end

return ReceiptProcessorClass
