local startingKarma = require 'configs.shared'.startingKarma
local holiday_karma = require 'modules.server.karma'
local Renewed = exports['Renewed-Lib']

local kvp_utils = {}

-- get player karma kvp
function kvp_utils.getPlayerKvp(src)
    local charId = Renewed:getCharId(src)

    local karma = GetResourceKvpInt('holidayKarma_' .. charId) or startingKarma

    return karma
end

-- set player karma kvp
function kvp_utils.setPlayerKvp(src, value)
    local charId = Renewed:getCharId(src)

    SetResourceKvpInt('holidayKarma_' .. charId, value)

    return true
end

-- save/load all players holiday karma
function kvp_utils.saveAllPlayers()
    local allPlayers = GetPlayers()

    for _, src in pairs(allPlayers) do
        src = tonumber(src)

        local karma = holiday_karma.getHolidayKarma(src)

        kvp_utils.setPlayerKvp(src, karma)
    end
end

-- load all players holiday karma
function kvp_utils.loadAllPlayers()
    local allPlayers = GetPlayers()

    for _, src in pairs(allPlayers) do
        src = tonumber(src)

        local karma = kvp_utils.getPlayerKvp(src)

        holiday_karma.setHolidayKarma(src, karma)
    end
end

return kvp_utils