local config = require 'configs.shared'
local santa_config = config.santa
local blip_config = santa_config.blip
local Renewed = exports['Renewed-Lib']

local santaBlip

-- apply Santa's appearance to ped
local function applySantaAppearance(ped, appearance)
    -- set components
    for componentId, componentData in pairs(appearance.components) do
        SetPedComponentVariation(ped, componentId, componentData.drawable, componentData.texture, 0)
    end

    -- set props
    for propId, propData in pairs(appearance.props) do
        SetPedPropIndex(ped, propId, propData.drawable, propData.texture, true)
    end
end

-- spawn Santa's chair
local function spawnSantasChair()
    Renewed:addObject({
        id = 'santas_chair',
        model = santa_config.chairModel,
        coords = santa_config.coords.xyz,
        heading = santa_config.coords.w - 180.0,
        colissions = true,
        snapGround = true,
        freeze = true,
        invincible = true,
        target = {
            {
                type = 'info',
                icon = 'fas fa-tree',
                label = 'Check for Gifts',
            }
        }
    })
end

-- blip creation and removal
local function createSantaBlip()
    if santaBlip and DoesBlipExist(santaBlip) then
        return
    end

    santaBlip = AddBlipForCoord(santa_config.coords.x, santa_config.coords.y, santa_config.coords.z)
    SetBlipSprite(santaBlip, blip_config.sprite)
    SetBlipScale(santaBlip, blip_config.scale)
    SetBlipDisplay(santaBlip, 4)
    SetBlipColour(santaBlip, blip_config.color)
    SetBlipAsShortRange(santaBlip, true)
    SetBlipCategory(santaBlip, 25)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blip_config.label)
    EndTextCommandSetBlipName(santaBlip)
end

local function removeSantaBlip()
    if not santaBlip or not DoesBlipExist(santaBlip) then
        return
    end

    RemoveBlip(santaBlip)
    santaBlip = nil
end

-- santa creation and removal utils
local santa_utils = {}

function santa_utils.createSanta()
    Renewed:addPed({
        id = 'santa_claus',
        model = santa_config.appearance.model,
        coords = vec3(santa_config.coords.xyz.x, santa_config.coords.xyz.y, santa_config.coords.xyz.z - 0.5),
        heading = santa_config.coords.w,
        scenario = 'PROP_HUMAN_SEAT_CHAIR_UPRIGHT',
        snapToGround = true,
        tempevents = true,
        freeze = true,
        invincible = true,
        onSpawn = function(self)
            spawnSantasChair()
            applySantaAppearance(self.entity, santa_config.appearance)
        end,
        target = {
            {
                type = 'info',
                icon = 'fas fa-gift',
                label = 'Talk to Santa Claus',
                onSelect = function()
                    local confirmation = lib.alertDialog({
                        header = 'Ho ho ho! Hey there ' .. Renewed:getCharName() .. '!',
                        content = 'Make sure you have been good this year, or you might not get what you want!  \n\n' ..
                                  'I can check my list twice and tell you if you\'ve been naughty or nice!',
                        centered = true,
                        cancel = true,
                        labels = {
                            confirm = 'Check List',
                            cancel = 'Maybe Later'
                        }
                    }) if confirmation == 'cancel' then return end

                    local naughtyOrNice = (LocalPlayer.state.holidayKarma >= config.naughtyOrNiceThreshold) and 'Nice' or 'Naughty'
                    local naughtyOrNiceTxt = (naughtyOrNice == 'Nice') and 'Keep up the good work and you\'ll get plenty of nice gifts this year!' or 'Hmmm... A bit mischievous this year! Start being better to get some gifts!'
                    local response = lib.alertDialog({
                        header = 'Santa Claus\'s List',
                        content = 'After checking my list twice, I can confirm that you have been...  \n\n' .. ('**%s!**  \n\n'):format(naughtyOrNice) .. naughtyOrNiceTxt,
                        centered = true,
                        labels = {
                            confirm = 'Thank You, Santa!'
                        }
                    })
                end
            }
        }
    })

    createSantaBlip()
end

function santa_utils.removeSanta()
    Renewed:removePed('santa_claus')
    Renewed:removeObject('santas_chair')
    removeSantaBlip()
end

return santa_utils