fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Alpha Burger Shot Script'
version '1.0.0'

dependencies {
    'qb-core'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    'shared/*.lua'
}

ui_page 'nui/index.html'

files {
    'nui/**/*'
}