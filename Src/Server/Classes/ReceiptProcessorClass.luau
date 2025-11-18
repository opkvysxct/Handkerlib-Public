--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StoreSuperClass = require(ReplicatedStorage.Handkerlib.SuperClasses.StoreSuperClass)
local Types = require(ReplicatedStorage.Handkerlib.Types)
local ReceiptProcessorClass = {}
ReceiptProcessorClass.__index = ReceiptProcessorClass

type ProductFunction = (receiptInfo: Types.ReceiptInfo, player: Player) -> nil
type GamepassFunction = (gamepassId: number, player: Player) -> nil

type Params = {
	ProductStore: StoreSuperClass.Class,
	GamepasseStore: StoreSuperClass.Class,
}

export type Class = typeof(setmetatable({} :: Params, ReceiptProcessorClass))

function ReceiptProcessorClass.Create(): Class
	local self = {}
	self.ProductStore = StoreSuperClass.Create()
	self.GamepasseStore = StoreSuperClass.Create()
	return setmetatable(self, ReceiptProcessorClass)
end

function ReceiptProcessorClass.Run(self: Class)
	MarketplaceService.ProcessReceipt = function(receiptInfo: Types.ReceiptInfo): Enum.ProductPurchaseDecision
		local userId: number = receiptInfo.PlayerId
		local productId: number = receiptInfo.ProductId

		local player: Player? = Players:GetPlayerByUserId(userId)
		if not player then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end

		local handler: ProductFunction = self.ProductStore:ReturnGivenElement(productId)
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
			local handler: GamepassFunction = self.GamepasseStore:ReturnGivenElement(gamepassId)
			local success: boolean = pcall(handler, gamepassId, player)
			if success then
				print("[H] Purchase Granted", player, gamepassId)
			else
				warn("[H] Failed to process receipt:", gamepassId)
			end
		end
	)
end

function ReceiptProcessorClass.Clear(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return ReceiptProcessorClass
