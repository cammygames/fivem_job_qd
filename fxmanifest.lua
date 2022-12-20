fx_version 'cerulean'
game 'gta5'

author "Maurice Moss (Maurice Moss#0001)"
description 'Qualifications & Departments'
version '0.0.1'

shared_scripts {
	'@qb-core/shared/locale.lua',
	'lang/en.lua',
	'config.lua',
	'shared.lua'
}

client_scripts {
	'client/*.lua'
}
server_scripts {
	'server/*.lua'
}

lua54 'yes'
use_fxv2_oal 'yes'

escrow_ignore {
	'lang/*.lua',
	'config.lua',
}

dependency {
	"qb-core",
	"qb-management",
}
