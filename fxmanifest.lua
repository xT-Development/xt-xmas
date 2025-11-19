fx_version 'cerulean'
game 'gta5'
use_experimental_fxv2_oal 'yes'
lua54 'yes'

author 'xT Development'
description 'Christmas'

shared_scripts {
    '@ox_lib/init.lua',
    'modules/debug.lua',
    'configs/shared.lua'
}

client_scripts {
    'configs/client.lua',
    'modules/client/*.lua',
    'client/*.lua'
}

server_scripts {
    'configs/server.lua',
    'modules/server/*.lua',
    'server/*.lua'
}

dependencies {
    'ox_lib',
    'Renewed-Lib'
}