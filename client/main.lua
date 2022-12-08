local QBCore = exports['qb-core']:GetCoreObject()
local trees = {}

-- Delete Trees --
local function RemoveTrees()
    for k,v in pairs(trees) do
        DeleteObject(trees[k])
    end
end

-- Spawn Trees --
local function SpawnTrees()
    for k, v in pairs(Config.Trees.spawnLocations) do
        RequestModel(Config.Trees.model)
        while not HasModelLoaded(Config.Trees.model) do
            Wait(2)
        end
        trees[k] = CreateObject(Config.Trees.model, v.x, v.y, v.z - 1, false, false, false)
        SetEntityHeading(trees[k], (v.w - 180))
        FreezeEntityPosition(trees[k], true)
        exports['qb-target']:AddTargetEntity(trees[k], {
            options = {
                {
                    icon = 'fas fa-gift',
                    label = 'Collect Gift',
                    action = function()
                        TriggerEvent('rs-xmas:client:GetGift', k)
                    end
                }
            },
            distance = 2.0
        })
    end
end

-- Open Gift --
RegisterNetEvent('rs-xmas:client:OpenGift', function()
    local hasItem = QBCore.Functions.HasItem('xmas_gift')
    if hasItem then
        QBCore.Functions.Progressbar('open_gift', 'Opening Christmas Gift...', 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
            anim = "weed_inspecting_high_base_inspector",
            flags = 49,
        }, {}, {}, function()
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('rs-xmas:server:OpenGift')
        end, function()
            ClearPedTasks(PlayerPedId())
            QBCore.Functions.Notify('Canceled...', 'error', 2000)
        end)
    end
end)

-- Get Gift from Tree --
RegisterNetEvent('rs-xmas:client:GetGift', function(closestTree)
    QBCore.Functions.Progressbar('get_gift', 'Looking for your gift...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'random@train_tracks',
        anim = 'idle_e',
        flags = 9,
    }, {}, {}, function()
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('rs-xmas:server:GetGift', closestTree)
    end, function()
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify('Canceled...', 'error', 2000)
    end)
end)

---------------------------------------------------------------
--------------- CREATE / REMOVE TARGET ENTITY -----------------
---------------------------------------------------------------
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    SpawnTrees()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    RemoveTrees()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    SpawnTrees()
end)

AddEventHandler('QBCore:Client:OnPlayerUnloaded', function()
    RemoveTrees()
end)