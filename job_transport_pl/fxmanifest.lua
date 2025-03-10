fx_version 'cerulean'
game 'gta5'

author 'DucraDev by Ducratif'
description 'Job Transport PL - ESX'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client.lua',
    --'client/npc_spawn.lua',
    'client/npc_interaction.lua',
    'client/npc_delete_vehicle.lua',
    'client/npc_spawn_trailer.lua',
    'client/force_trailer_attach.lua',
    'client/livraison.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
    'server/livraison.lua'
}
