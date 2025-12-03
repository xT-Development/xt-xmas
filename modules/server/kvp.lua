local startingKarma = require 'configs.shared'.startingKarma
local holiday_karma = require 'modules.server.karma'
local Renewed = exports['Renewed-Lib']

local kvp_utils = {}

-- get player karma kvp
function kvp_utils.getPlayerKvp(charId)
    local karma = GetResourceKvpInt('holidayKarma_' .. charId) or startingKarma

    return karma
end

-- set player karma kvp
function kvp_utils.setPlayerKvp(charId, value)
    SetResourceKvpInt('holidayKarma_' .. charId, value)

    return true
end

-- save/load all players holiday karma
function kvp_utils.saveAllPlayers()
    local allPlayers = GetPlayers()

    for _, src in pairs(allPlayers) do
        src = tonumber(src)

        local karma = holiday_karma.getHolidayKarma(src)
        local charId = Renewed:getCharId(src)

        kvp_utils.setPlayerKvp(charId, karma)
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