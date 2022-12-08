print("^1rs-xmas ^7| v1.0 - Christmas Script by ^1Redline Studios")
Config = {}

Config.Trees = {
    model = `prop_xmas_tree_int`,
    spawnLocations = {
        [1] = vector4(196.08, -930.34, 30.69, 309.4), -- Legion Square
        [2] = vector4(200.1, -929.43, 30.69, 258.48), -- Legion Square
        [3] = vector4(198.85, -932.09, 30.69, 201.2) -- Legion Square
    }
}

Config.GiftAmount = math.random(1,2) -- Amount of gifts you get from each tree
Config.Gifts = {
    [1] = {
        items = {
            [1] = {item = 'metalscrap', amount = math.random(1,2)}
        }
    },
    [2] = {
        items = {
            [1] = {item = 'pistol_ammo', amount = math.random(1,2)},
            [2] = {item = 'tosti', amount = math.random(1,2)},
        }
    }
}

-- IGNORE THESE --
Config.Items = {
    [1] = {item = 'xmas_gift', label = 'Christmas Gift', image = 'gift.png', description = 'A nice Christmas Gift'},
    [2] = {item = 'coal', label = 'Coal', image = 'coal.png', description = 'Coal for all the naughty people!'},
}