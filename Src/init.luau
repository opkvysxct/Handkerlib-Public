-- VYSX 2025
-- VERSION 0.12.0

-- Handkerlib uses errors and asserts (with expection of processing platform purchases),
-- which will halt execution of the code instead of warns if something goes wrong, please be aware of it.

local Handkerlib = {}

Handkerlib.Types = require(script.Types)

Handkerlib.Shared = {}
Handkerlib.Client = {}
Handkerlib.Server = {}

local shared = script.Shared
Handkerlib.Shared.CustomSharedLib = require(shared.Components.CustomSharedLib)
Handkerlib.Shared.InstanceLib = require(shared.Components.InstanceLib)
Handkerlib.Shared.Marketplace = require(shared.Components.MarketplaceLib)
Handkerlib.Shared.MathLib = require(shared.Components.MathLib)
Handkerlib.Shared.PlayerLib = require(shared.Components.PlayerLib)
Handkerlib.Shared.RaycastLib = require(shared.Components.RaycastLib)
Handkerlib.Shared.TesterLib = require(shared.Components.TesterLib)
Handkerlib.Shared.TimeLib = require(shared.Components.TimeLib)

Handkerlib.Shared.AnimatorClass = require(shared.Classes.AnimatorClass)
Handkerlib.Shared.ConnectionsSuperClass = require(shared.Classes.ConnectionsSuperClass)
Handkerlib.Shared.MiddlewareSuperClass = require(shared.Classes.MiddlewareSuperClass)
Handkerlib.Shared.ParallelClass = require(shared.Classes.ParallelClass)
Handkerlib.Shared.TweenerClass = require(shared.Classes.TweenerClass)

local server = script.Server
Handkerlib.Server.CustomServerLib = require(server.Components.CustomServerLib)

local client = script.Client
Handkerlib.Client.CustomClientLib = require(client.Components.CustomClientLib)
Handkerlib.Client.PlayerUtilsLib = require(client.Components.PlayerUtilsLib)

return Handkerlib
