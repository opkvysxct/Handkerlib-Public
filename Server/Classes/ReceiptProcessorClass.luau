local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Handkerlib.Types)
local ReceiptProcessorClass = {}
ReceiptProcessorClass.__index = ReceiptProcessorClass

type ProductFunction = (receiptInfo: Types.ReceiptInfo, player: Player) -> nil
type GamepassFunction = (gamepassId: number, player: Player) -> nil

function ReceiptProcessorClass.Create()
	local self = setmetatable({}, ReceiptProcessorClass)
	self.producs = {}
	self.gamepasses = {}
	self:_Run()
	return self
end

function ReceiptProcessorClass:AddProductListener(id: number, funcAfter: ProductFunction)
	self.producs[id] = funcAfter
end

function ReceiptProcessorClass:AddGamepassListener(id: number, funcAfter: GamepassFunction)
	self.gamepasses[id] = funcAfter
end

function ReceiptProcessorClass:_Run()
	MarketplaceService.ProcessReceipt = function(receiptInfo: Types.ReceiptInfo): Enum.ProductPurchaseDecision
		local userId: number = receiptInfo.PlayerId
		local productId: number = receiptInfo.ProductId

		local player: Player? = Players:GetPlayerByUserId(userId)
		if not player then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end

		local handler: ProductFunction = self.producs[productId]
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
			local handler: GamepassFunction = self.producs[gamepassId]
			local success: boolean = pcall(handler, gamepassId, player)
			if success then
				print("[H] Purchase Granted", player, gamepassId)
			else
				warn("[H] Failed to process receipt:", gamepassId)
			end
		end
	)
end

function ReceiptProcessorClass:Destroy()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return ReceiptProcessorClass
