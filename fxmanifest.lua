
fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
games {"rdr3"}
lua54 "yes"

escrow_ignore {
    'server.lua',
	'config.lua', 
}

files {
    'not.js',
}

shared_scripts {
    'config.lua',
}

client_scripts {
    'client.lua',
    'not.js'
}


server_scripts {
    'server.lua',
}

export 'IsThompson' 
--[[
    How to use at client side:
    local a = exports.ricx_thompson:IsThompson()
    print(a) --prints nil or entity ID for thompson
]]