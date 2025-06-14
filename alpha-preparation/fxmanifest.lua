fx_version 'cerulean'
game 'gta5'

description 'Alpha Preparation Items'
version '1.0.0'

dependency {
    'ox_lib',
    'interact'
}

shared_script 'shared/config.lua'
shared_script '@ox_lib/init.lua'

client_script 'client/client.lua'
server_script 'server/server.lua'

lua54 'yes'