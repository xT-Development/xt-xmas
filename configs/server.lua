return {
    karmaMenuCommand = 'xmas',  -- command to open the karma admin menu
    adminPermission = 'admin',  -- ace permission required for admin commands/menu controls

    presents = {    -- gift types
        naughty = { -- naughty gifts
            {
                {
                    item = 'water',
                    amount = { min = 1, max = 3 }
                },

                {
                    item = 'burger',
                    amount = { min = 1, max = 3 }
                }
            }
        },

        nice = {    -- nice gifts
            {
                {
                    item = 'goldbar',
                    amount = { min = 1, max = 3 }
                },

                {
                    item = 'goldchain',
                    amount = { min = 1, max = 3 }
                }
            },

            {
                {
                    item = 'phone',
                    amount = { min = 1, max = 3 }
                },

                {
                    item = 'laptop',
                    amount = { min = 1, max = 3 }
                }
            }
        }
    }
}