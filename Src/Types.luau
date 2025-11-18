--!strict
export type GenericFunction = any
export type GenericClass = any
export type GenericLoadedModule = any
export type Remote = RemoteFunction & RemoteEvent & UnreliableRemoteEvent
export type Scripts = Script & LocalScript & ModuleScript

export type ThreadTable = {
	Script: ModuleScript,
	Actor: Actor,
}

export type ReceiptInfo = {
	PurchaseId: number,
	PlayerId: number,
	ProductId: number,
	PlaceIdWherePurchased: number,
	CurrencySpent: number,
	CurrencyType: Enum.CurrencyType,
	ProductPurchaseChannel: Enum.ProductPurchaseChannel,
}

export type SoundSpecs = {
	Name: string?,
	SoundId: number?,
	Volume: number?,
	PlaybackSpeed: number?,
	MaxDistance: number?,
	MinDistance: number?,
	SoundGroup: SoundGroup?,
}

return nil
