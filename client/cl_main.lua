local santa_utils = require "modules.client.santa"
local trees_utils = require "modules.client.trees"
local xmas_menus = require "modules.client.menus"

-- event to open karma menu for admins
RegisterNetEvent('xt-xmas:client:openKarmaMenu', function()
    if GetInvokingResource() then return end

    xmas_menus.naughtyOrNiceList()
end)

-- load/unload handlers
local function onLoad()
    santa_utils.createSanta()
    trees_utils.createTrees()
end

local function onUnload()
    santa_utils.removeSanta()
    trees_utils.removeTrees()
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    onLoad()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    onUnload()
end)

AddEventHandler('Renewed-Lib:client:PlayerLoaded', onLoad)
AddEventHandler('Renewed-Lib:client:PlayerUnloaded', onUnload)