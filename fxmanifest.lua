fx_version 'cerulean'
games {'gta5' }

author 'mn#0810'
description 'CBR UI'
version '1.0.0'


client_scripts {
    "client.lua",
    'config.lua'
}

server_scripts {
  'server.lua',
  'config.lua',
  '@mysql-async/lib/MySQL.lua'
}



ui_page "html/index.html"


files {
  "html/*",
  "html/img/*",
  "html/fonts/*"
}