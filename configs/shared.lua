return {
    debug = true,

    startingKarma = 50,              -- Starting holiday karma for players
    naughtyOrNiceThreshold = 50,    -- Player holiday karma should be higher than this for the "nice" outcome

    -- Santa Claus
    santa = {
        coords = vec4(200.62, -930.37, 30.68, 161.57),

        blip = {
            label = 'Santa Claus',
            sprite = 58,
            color = 2,
            scale = 0.6
        },

        appearance = {
            model = 'mp_m_freemode_01',
            components = { -- https://docs.fivem.net/natives/?_0x262B14F48D29DE80
                [1] = { drawable = 8, texture = 0 },     -- Mask
                [3] = { drawable = 75, texture = 0 },    -- Torso / Hands
                [4] = { drawable = 19, texture = 0 },    -- Legs
                [6] = { drawable = 19, texture = 0 },    -- Shoes
                [8] = { drawable = 19, texture = 0 },    -- Undershirt
                [11] = { drawable = 19, texture = 0 },   -- Top
            },

            props = { -- https://docs.fivem.net/natives/?_0x829F2E2
                -- [1] = { drawable = 0, texture = 0 }      -- Glasses
            }
        },

        chairModel  = 'v_ilev_m_dinechair'
    },

    -- Christmas Trees
    trees = {
        {
            coords = vec4(197.72, -930.78, 30.68, 189.92),
            model = 'prop_xmas_tree_int'
        }
    }
}