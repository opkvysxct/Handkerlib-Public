--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lib_Formatting = require(ReplicatedStorage.Handkerlib.Shared.Components.Lib_Formatting)
local Type_Handker = require(ReplicatedStorage.Handkerlib.Type_Handker)
local LSClass_ReceiptProcessor = {}
LSClass_ReceiptProcessor.__index = LSClass_ReceiptProcessor

type Type_ProductFunction = (receiptInfo: Type_Handker.Type_ReceiptInfo, player: Player) -> nil
type Type_GamepassFunction = (gamepassId: number, player: Player) -> nil

export type Type_Class = typeof(setmetatable(
	{} :: {
		ProductStore: { [number]: Type_ProductFunction },
		GamepasseStore: { [number]: Type_GamepassFunction },
	},
	LSClass_ReceiptProcessor
))

function LSClass_ReceiptProcessor.Create(): Type_Class
	local self = {}
	self.ProductStore = {}
	self.GamepasseStore = {}
	return setmetatable(self, LSClass_ReceiptProcessor)
end

function LSClass_ReceiptProcessor.Run(self: Type_Class)
	MarketplaceService.ProcessReceipt = function(receiptInfo: Type_Handker.Type_ReceiptInfo): Enum.ProductPurchaseDecision
		local userId: number = receiptInfo.PlayerId
		local productId: number = receiptInfo.ProductId

		local player: Player? = Players:GetPlayerByUserId(userId)
		if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end

		local handler: Type_ProductFunction = self.ProductStore[productId]
		local success: boolean = pcall(handler, receiptInfo, player)
		if success then
			print(Lib_Formatting:FormatLogMessage(script, `Product Granted {productId} for {player.Name}`))
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn(Lib_Formatting:FormatLogMessage(script, `Failed to process receipt: {receiptInfo.ProductId} for {receiptInfo.PlayerId}`))
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
	end

	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player: Player, gamepassId: number, wasPurchased: boolean)
		if not wasPurchased then return end
		local handler: Type_GamepassFunction = self.GamepasseStore[gamepassId]
		local success: boolean = pcall(handler, gamepassId, player)
		if success then
			print(Lib_Formatting:FormatLogMessage(script, `Purchase Granted for {player.Name} - {gamepassId}`))
		else
			warn(Lib_Formatting:FormatLogMessage(script, `Failed to process receipt: {gamepassId}`))
		end
	end)
end

function LSClass_ReceiptProcessor.Destroy(self: Type_Class)
	setmetatable(self :: any, nil)
	table.clear(self :: any)
	table.freeze(self :: any)
end

return LSClass_ReceiptProcessor
