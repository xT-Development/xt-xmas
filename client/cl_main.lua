local XMasTrees = {}

-- Receive Gift --
local function openGift(id)
    local giftCount = exports.ox_inventory:Search('count', 'xmas_gift')
    if not giftCount then return end

    if lib.progressCircle({
        duration = 2500,
        label = 'Opening Gift',
        useWhileDead = false,
        canCancel = true,
        position = 'bottom',
        disable = { car = true, move = true, combat = true },
        anim = {
            dict = 'anim@amb@business@weed@weed_inspecting_high_dry@',
            clip = 'weed_inspecting_high_base_inspector',
        },
    }) then
        ClearPedTasks(cache.ped)
        lib.callback.await('xt-xmas:server:openXMasGift', false)
    else
        ClearPedTasks(cache.ped)
        lib.notify({ title = 'Canceled...', type = 'error' })
    end
end

-- Receive Gift --
local function receiveGift(id)
    if lib.progressCircle({
        duration = 5000,
        label = 'Looking for gifts...',
        useWhileDead = false,
        canCancel = true,
        position = 'bottom',
        disable = { car = true, move = true, combat = true },
        anim = {
            dict = 'random@train_tracks',
            clip = 'idle_e',
            flag = 9
        },
    }) then
        ClearPedTasks(cache.ped)
        lib.callback.await('xt-xmas:server:canReceiveXMasGift', false, id)
    else
        ClearPedTasks(cache.ped)
        lib.notify({ title = 'Canceled...', type = 'error' })
    end
end

-- Spawn Tree --
local function createXMasTree(coords)
    local newTree = CreateObject(Config.Trees.model, coords.x, coords.y, coords.z - 1, false, false, false)
    SetEntityHeading(newTree, (coords.w - 180))
    FreezeEntityPosition(newTree, true)
    return newTree
end

-- Spawn Trees --
local function spawnXMasTrees()
    for id, coords in pairs(Config.Trees.spawnLocations) do
        lib.requestModel(Config.Trees.model)
        XMasTrees[id] = createXMasTree(coords)
        exports.ox_target:addLocalEntity(XMasTrees[id], {
            {
                label = 'Check for Gifts',
                icon = 'fas fa-gift',
                distance = 2.0,
                onSelect = function()
                    receiveGift(id)
                end
            }
        })
    end
end

-- Delete Trees --
local function removeXMasTrees()
    for x = 1, #XMasTrees do
        DeleteObject(XMasTrees[x])
    end
end

-- Handlers --
AddEventHandler('onResourceStart', function(resourceName) if GetCurrentResourceName() ~= resourceName then return end spawnXMasTrees() end)
AddEventHandler('onResourceStop', function(resourceName) if GetCurrentResourceName() ~= resourceName then return end removeXMasTrees() end)
AddEventHandler('Renewed-Lib:client:PlayerLoaded', function() spawnXMasTrees() end)
AddEventHandler('Renewed-Lib:client:PlayerUnloaded', function() removeXMasTrees() end)

exports('xmas_gift', function(data, slot)
    local giftCount = exports.ox_inventory:Search('count', 'xmas_gift')
    if not giftCount then return end
    openGift()
end)