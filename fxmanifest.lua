fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'pigeon-vehicle-access'
author 'Pigeon Studios'
description 'Decide who can drive which vehicles, by job, grade, gang, ACE permission or whitelist, for Qbox and QBCore.'
version '1.0.0'
repository 'https://github.com/WelshPigeon/pigeon-vehicle-access'

-- Pigeon Studios version registry entry, read by server/version_check.lua.
pigeon_slug 'pigeon-vehicle-access'

-- Server-side vehicle checks need OneSync.
dependencies {
    '/onesync',
    'oxmysql',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'configuration/config.lua',
    'locales/*.lua',
    'server/rules.lua',
    'server/queries.lua',
    'server/bridge.lua',
    'server/main.lua',
    'server/version_check.lua',
}

client_scripts {
    'client/main.lua',
}
