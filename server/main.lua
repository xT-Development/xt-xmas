local QBCore = exports['qb-core']:GetCoreObject()
local sharedItems = QBCore.Shared.Items
local trees = {}

local function HasUsedTree(closestTree, citizenId)
    local callback = false
    for _, v in pairs(trees[closestTree].citizenIDs) do
            if citizenId == v then
                callback = true
                break
            end
    end
    return callback
end

-- Get gifts from tree --
RegisterServerEvent('rs-xmas:server:GetGift', function(closestTree)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenId = Player.PlayerData.citizenid
    local idk = 0
    if not Player then return end

    if not HasUsedTree(closestTree, citizenId) then
        Player.Functions.AddItem('xmas_gift', Config.GiftAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['xmas_gift'], "add", Config.GiftAmount)
        table.insert(trees[closestTree].citizenIDs, citizenId)
    else
        TriggerClientEvent("QBCore:Notify", src, "There\'s no gifts at this tree with your name on it!", 'error')
    end
end)

-- Open Gifts --
RegisterServerEvent('rs-xmas:server:OpenGift', function(closestTree)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenId = Player.PlayerData.citizenid
    local idk = 0
    if not Player then return end
    local coalChance = math.random(1, 10)

    if coalChance <= 8 then -- 80% Chance to get actual gifts
        local gift = math.random(1, #Config.Gifts)
        local gifts = Config.Gifts[gift].items
        for r = 1, #gifts do
            idk = idk + 1
            Player.Functions.AddItem(gifts[r].item, gifts[r].amount)
            TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[gifts[r].item], "add", gifts[r].amount)
            if idk == #gifts then
                Player.Functions.RemoveItem('xmas_gift', 1)
                TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['xmas_gift'], "remove", 1)
            end
        end
    else -- 20% Chance to get coal
        local coalAmount = math.random(1, 5)
        Player.Functions.AddItem('coal', coalAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['coal'], "add", coalAmount)
        Player.Functions.RemoveItem('xmas_gift', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems['xmas_gift'], "remove", 1)

        TriggerClientEvent("QBCore:Notify", src, "Yikes, looks like you\'ve been naughty!", 'error')
    end
end)

-- Create Trees Table w/ IDs --
RegisterServerEvent('rs-xmas:server:TreesTable', function()
    for r = 1, #Config.Trees.spawnLocations do
        trees[r] = {
            citizenIDs = {}
        }
    end
end)

-- Create / Add Gift Item --
RegisterServerEvent('rs-xmas:server:AddItem', function()
    for r,s in pairs(Config.Items) do
        QBCore.Functions.AddItems({
            [s.item] = {
                name = s.item,
                label = s.label,
                weight = 10,
                type = 'item',
                image = s.image,
                unique = false,
                useable = true,
                shouldClose = true,
                combinable = nil,
                description = s.description
            },
        })
    end
end)

QBCore.Functions.CreateUseableItem('xmas_gift', function(source)
    local src = source
    TriggerClientEvent('rs-xmas:client:OpenGift', src)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('rs-xmas:server:TreesTable')
        if Config.NewCore then
            TriggerEvent('rs-xmas:server:AddItem')
        end
    end
end)
