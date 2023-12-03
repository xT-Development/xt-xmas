local XMasTrees = {}

-- Open Gifts --
local function openXMasGift()
    local src = source
    local coalChance = math.random(1, 100)

    if coalChance >= Config.CoalChance then -- Get Gifts
        local gifts = Config.Gifts[math.random(1, #Config.Gifts)]
        local giftCount = 0

        for x = 1, #gifts do
            local receiveAmount = math.random(gifts[x].amount.min, gifts[x].amount.max)
            giftCount = giftCount + 1
            if exports.ox_inventory:AddItem(src, gifts[x].item, receiveAmount) then
                if giftCount == #gifts then
                    exports.ox_inventory:RemoveItem(src, 'xmas_gift', 1)
                end
            end
        end
    else -- Get Coal
        local coalAmount = math.random(1, 5)
        exports.ox_inventory:AddItem(src, 'xmas_coal', coalAmount)
        exports.ox_inventory:RemoveItem(src, 'xmas_gift', 1)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Naughty!',
            description = 'Yikes, looks like you\'ve been naughty!',
            type = 'error'
        })
    end
end

lib.callback.register('xt-xmas:server:openXMasGift', openXMasGift)

-- Check if Player Can Receive Gifts --
lib.callback.register('xt-xmas:server:canReceiveXMasGift', function(source, treeID)
    local src = source
    local pCoords = GetEntityCoords(GetPlayerPed(src))
    local dist = #(Config.Trees.spawnLocations[treeID].xyz - pCoords)
    local callback = false
    if dist > 5 then return callback end

    local charID = Bridge.getCharId(src)

    if not XMasTrees[treeID][charID] then
        callback = true
    end

    if not XMasTrees[treeID][charID] then
        local giftAmount = math.random(Config.GiftAmount.min, Config.GiftAmount.max)
        if exports.ox_inventory:AddItem(src, 'xmas_gift', giftAmount) then
            XMasTrees[treeID][charID] = true

            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Happy Holidays!',
                description = 'You received Christmas gifts!',
                type = 'success'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'No Gifts!',
            description = 'There\'s no gifts at this tree with your name on it!',
            type = 'error'
        })
    end

    return callback
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for x = 1, #Config.Trees.spawnLocations do
        XMasTrees[x] = {}
    end
end)
