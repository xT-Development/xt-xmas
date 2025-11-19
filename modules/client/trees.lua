local config = require 'configs.client'
local trees = require 'configs.shared'.trees
local Renewed = exports['Renewed-Lib']

-- store created tree object ids
local createdTrees = {}

-- christmas tree creation and removal utils
local trees_utils = {}

function trees_utils.createTrees()
    for x = 1, #trees do
        local tree = trees[x]
        local treeModel = tree.model
        local treeCoords = tree.coords

        Renewed:addObject({
            id = ('xmas_tree_' .. x),
            model = treeModel,
            coords = vec3(treeCoords.x, treeCoords.y, treeCoords.z),
            heading = treeCoords.w,
            colissions = true,
            snapGround = true,
            freeze = true,
            target = {
                {
                    type = 'info',
                    icon = 'fas fa-tree',
                    label = 'Check for Gifts',
                    onSelect = function()
                        lib.playAnim(cache.ped, "amb@medic@standing@kneel@base" ,"base", 8.0, -8.0, -1, 1, 0, false, 0, false)
                        if lib.progressBar({
                            duration = (math.random(config.timeToSearch.min, config.timeToSearch.max) * 1000),
                            label = 'Checking for gifts...',
                            useWhileDead = false,
                            canCancel = false,
                            disable = {
                                car = true,
                            },
                            anim = {
                                dict = 'missexile3',
                                clip = 'ex03_dingy_search_case_a_michael'
                            },
                        }) then
                            ClearPedTasks(cache.ped)
                            TriggerServerEvent('xt-xmas:server:checkForGifts', x)
                        end
                    end
                }
            }
        })

        createdTrees[#createdTrees + 1] = ('xmas_tree_' .. x)
    end
end

function trees_utils.removeTrees()
    for x = 1, #createdTrees do
        Renewed:removeObject(createdTrees[x])
    end
end

return trees_utils