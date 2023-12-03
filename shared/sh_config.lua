Config = {}

Config.Trees = {
    model = `prop_xmas_tree_int`,
    spawnLocations = {
        vector4(196.08, -930.34, 30.69, 309.4),     -- Legion Square
        vector4(200.1, -929.43, 30.69, 258.48),     -- Legion Square
        vector4(198.85, -932.09, 30.69, 201.2)      -- Legion Square
    }
}

Config.CoalChance = 20                              -- Chance to receive coal from gifts
Config.GiftAmount = { min = 1, max = 2 }            -- Amount of gifts you get from each tree
Config.Gifts = {                                    -- Loot pools for gifts
    {
        { item = 'metalscrap', amount = { min = 1, max = 2 } }
    },
    {
        { item = 'pistol_ammo', amount = { min = 1, max = 2 } },
        { item = 'tosti', amount = { min = 1, max = 2 } },
    }
}

-----------------------------------------------

Bridge = exports['Renewed-Lib']:getLib()