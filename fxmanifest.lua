fx_version 'adamant'
game 'gta5'
author 'Reyghita Hafizh Firmanda'
lua54 'yes'

client_scripts {
    'client/cl_*.lua'
}

server_scripts {
    'server/sv_*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

files {
    'locales/*.json'
}