local config = require 'configs.server'
local shared = require 'configs.shared'
local kvp_utils = require "modules.server.kvp"
local holiday_karma = require "modules.server.karma"
local Renewed = exports['Renewed-Lib']

-- store trees checked by player
local checkedTreesByPlayer = {}

-- get players and their karma, return for admin menu
lib.callback.register('xt-xmas:server:getCurrentPlayers', function(source)
    if not IsPlayerAceAllowed(source, config.adminPermission) then return end

    local players = {}
    local allPlayers = GetPlayers()

    for _, src in pairs(allPlayers) do
        src = tonumber(src)

        local karma = holiday_karma.getHolidayKarma(src)

        table.insert(players, {
            source = src,
            name = Renewed:getCharName(src),
            karma = karma
        })
    end

   return players
end)

-- admin command to set holiday karma for a player
RegisterNetEvent('xt-xmas:server:setHolidayKarma', function(data)
    local src = source
    if not IsPlayerAceAllowed(src, config.adminPermission) then return end

    holiday_karma.setHolidayKarma(data.source, data.karma)

    lib.notify(src, {
        title = 'Holiday Karma',
        description = 'Set holiday karma for ' .. Renewed:getCharName(data.source) .. ' to ' .. data.karma .. '.',
        type = 'success'
    })

    debugTxt(('%s set holiday karma for %s to %s'):format(GetPlayerName(src), GetPlayerName(data.source), data.karma), 'info')
end)

-- admin command to open karma menu
lib.addCommand(config.karmaMenuCommand, {
    help = 'Manage holiday karma for players',
    params = {},
    restricted = config.adminPermission
}, function(source, args, raw)
    TriggerClientEvent('xt-xmas:client:openKarmaMenu', source)
end)

-- give player gifts based on their holiday karma
RegisterNetEvent('xt-xmas:server:checkForGifts', function(treeId)
    local src = source
    local charId = exports['Renewed-Lib']:getCharId(src)
    if checkedTreesByPlayer[charId] and lib.table.contains(checkedTreesByPlayer[charId], treeId) then
        lib.notify(src, {
            title = 'Christmas Tree',
            description = 'You have already checked this tree for gifts.',
            type = 'error'
        })
        return
    end

    -- check distance to tree
    local playerPos = GetEntityCoords(GetPlayerPed(src))
    local treePos = shared.trees[treeId].coords.xyz
    local distance = #(playerPos - treePos)
    if distance > 5.0 then
        return
    end

    -- get presents based on karma
    local holidayKarma = holiday_karma.getHolidayKarma(src)
    local naughtyOrNice = (holidayKarma >= shared.naughtyOrNiceThreshold) and 'nice' or 'naughty'
    local rewards = config.presents[naughtyOrNice]
    local randomReward = rewards[math.random(1, #rewards)]

    local giftCount = 0
    for x = 1, #randomReward do
        local item = randomReward[x]
        local count = math.random(item.amount.min, item.amount.max)

        if exports.ox_inventory:AddItem(src, item.item, count) then
            giftCount += 1
        end
    end

    -- mark tree as checked for player
    if not checkedTreesByPlayer[charId] then
        checkedTreesByPlayer[charId] = {}
    end
    table.insert(checkedTreesByPlayer[charId], treeId)

    lib.notify(src, {
        title = 'Christmas Tree',
        description = 'Looks like you\'ve been ' .. naughtyOrNice .. '! You received ' .. giftCount .. ' gift(s).',
        type = 'success'
    })

    debugTxt(('%s checked tree %s and received %s gifts for being %s'):format(GetPlayerName(src), treeId, giftCount, naughtyOrNice), 'info')
end)

-- load holiday karma from kvp on player load
AddEventHandler('Renewed-Lib:server:playerLoaded', function(source, player)
    local charId = player.charId
    local karma = kvp_utils.getPlayerKvp(source)

    holiday_karma.setHolidayKarma(source, karma)
end)

-- save holiday karma to kvp on player unload
AddEventHandler('Renewed-Lib:server:playerRemoved', function(source, player)
    local charId = player.charId
    local karma = holiday_karma.getHolidayKarma(source)

    kvp_utils.setPlayerKvp(source, 'holidayKarma', karma)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    kvp_utils.loadAllPlayers()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    kvp_utils.saveAllPlayers()
end)

-- exports
exports('increaseHolidayKarma', holiday_karma.increaseHolidayKarma)
exports('decreaseHolidayKarma', holiday_karma.decreaseHolidayKarma)
exports('getHolidayKarma', holiday_karma.getHolidayKarma)
exports('setHolidayKarma', holiday_karma.setHolidayKarma)