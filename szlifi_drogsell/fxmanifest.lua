fx_version 'cerulean'
games { 'gta5' }

author 'Szlifike'
description 'Simple Drog Seller Script'
version '1.0.0'

shared_script {
    'config.lua'
}

server_scripts {
    'server/main.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

lua54 'yes'