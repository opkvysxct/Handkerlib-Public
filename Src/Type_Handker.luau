--!strict
export type Type_GenericFunction = any
export type Type_GenericClass = any
export type Type_GenericLoadedModule = any
export type Type_Remote = RemoteFunction & RemoteEvent & UnreliableRemoteEvent
export type Type_Scripts = Script | LocalScript | ModuleScript

export type Type_Character = Model & {
	PrimaryPart: BasePart,
	Humanoid: Humanoid & {
		Animator: Animator,
	},
	Head: BasePart,
	HumanoidRootPart: BasePart,
}

export type Type_ReceiptInfo = {
	PurchaseId: number,
	PlayerId: number,
	ProductId: number,
	PlaceIdWherePurchased: number,
	CurrencySpent: number,
	CurrencyType: Enum.CurrencyType,
	ProductPurchaseChannel: Enum.ProductPurchaseChannel,
}

export type Type_SoundSpecs = {
	Name: string,
	SoundId: number,
	Volume: number?,
	PlaybackSpeed: number?,
	MaxDistance: number?,
	MinDistance: number?,
	SoundGroup: SoundGroup?,
}

export type Type_AnimationSpecs = {
	AnimationId: number | Animation,
	Priority: Enum.AnimationPriority?,
	Looped: boolean?,
	Speed: number?,
	Weight: number?,
}

return nil
