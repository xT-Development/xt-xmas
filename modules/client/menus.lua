local shared = require 'configs.shared'

local xmas_menus = {}

function xmas_menus.naughtyOrNiceList()
    local allPlayers = lib.callback.await('xt-xmas:server:getCurrentPlayers', false)
    local menuOptions = {}

    if allPlayers and next(allPlayers) then
        for x = 1, #allPlayers do
            local player = allPlayers[x]
            local naughtyOrNice = player.karma >= shared.naughtyOrNiceThreshold and 'Nice' or 'Naughty'
            menuOptions[#menuOptions+1] = {
                title = player.name,
                description = '**Holiday Karma:** ' .. player.karma .. '  \n**Naughty or Nice:** ' .. naughtyOrNice,
                icon = (naughtyOrNice == 'Nice') and 'fas fa-check' or 'fas fa-ban',
                iconColor = (naughtyOrNice == 'Nice') and 'green' or 'red',
                onSelect = function()
                    local input = lib.inputDialog('Manage Holiday Karma:' .. player.name, {
                        { type = 'number', label = 'Holiday Karma', description = 'Enter new holiday karma for player', default = player.karma },
                    }) if not input or not input[1] then return end

                    TriggerServerEvent('xt-xmas:server:setHolidayKarma', {
                        source = player.source,
                        karma = input[1]
                    })
                end
            }
        end
    else
        menuOptions[#menuOptions+1] = {
            title = 'Nothing to Show!'
        }
    end

    lib.registerContext({
        id = 'xmas_players_menu',
        title = 'Active Players  \nHoliday Karma',
        options = menuOptions
    })

    lib.showContext('xmas_players_menu')
end

return xmas_menus