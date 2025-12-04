--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local FormattingLib = require(script.Parent.Parent.Parent.Shared.Components.FormattingLib)
local StoreSuperClass = require(script.Parent.Parent.Parent.SuperClasses.StoreSuperClass)
local Types = require(script.Parent.Parent.Parent.Types)
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
	self.ProductStore = StoreSuperClass.Create("number", "function")
	self.GamepasseStore = StoreSuperClass.Create("number", "function")
	return setmetatable(self, ReceiptProcessorClass)
end

function ReceiptProcessorClass.Run(self: Class)
	MarketplaceService.ProcessReceipt = function(receiptInfo: Types.ReceiptInfo): Enum.ProductPurchaseDecision
		local userId: number = receiptInfo.PlayerId
		local productId: number = receiptInfo.ProductId

		local player: Player? = Players:GetPlayerByUserId(userId)
		if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

		local handler: ProductFunction = self.ProductStore:ReturnGivenElement(productId)
		local success: boolean = pcall(handler, receiptInfo, player)
		if success then
			print(FormattingLib:FormatLogMessage(script, `Product Granted {productId} for {player.Name}`))
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn(FormattingLib:FormatLogMessage(script, `Failed to process receipt: {receiptInfo.ProductId} for {receiptInfo.PlayerId}`))
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
	end

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player: Player, gamepassId: number, wasPurchased: boolean)
		if not wasPurchased then return end
		local handler: GamepassFunction = self.GamepasseStore:ReturnGivenElement(gamepassId)
		local success: boolean = pcall(handler, gamepassId, player)
		if success then
			print(FormattingLib:FormatLogMessage(script, `Purchase Granted for {player.Name} - {gamepassId}`))
		else
			warn(FormattingLib:FormatLogMessage(script, `Failed to process receipt: {gamepassId}`))
		end
	end)
end

function ReceiptProcessorClass.Destroy(self: Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return ReceiptProcessorClass
