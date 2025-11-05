-- VYSX 2025
-- VERSION 0.9.0

local Handkerlib = {}

Handkerlib.Shared = {}

Handkerlib.Types = require(script.Types)

local shared = script.Shared
Handkerlib.Shared.CustomSharedLib = require(shared.Components.CustomSharedLib)
Handkerlib.Shared.InstanceLib = require(shared.Components.InstanceLib)
Handkerlib.Shared.Marketplace = require(shared.Components.MarketplaceLib)
Handkerlib.Shared.MathLib = require(shared.Components.MathLib)
Handkerlib.Shared.PlayerLib = require(shared.Components.PlayerLib)
Handkerlib.Shared.TesterLib = require(shared.Components.TesterLib)

Handkerlib.Shared.AnimatorClass = require(shared.Classes.AnimatorClass)
Handkerlib.Shared.MiddlewareSuperClass = require(shared.Classes.MiddlewareSuperClass)
Handkerlib.Shared.RaycasterClass = require(shared.Classes.RaycasterClass)
Handkerlib.Shared.TweenerClass = require(shared.Classes.TweenerClass)

local server = script.Server
Handkerlib.Server = {}
Handkerlib.Server.CustomServerLib = require(server.Components.CustomServerLib)

local client = script.Client
Handkerlib.Client = {}
Handkerlib.Client.CustomClientLib = require(client.Components.CustomClientLib)
Handkerlib.Client.PlayerUtilsLib = require(client.Components.PlayerUtilsLib)

return Handkerlib
