fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

client_scripts {
    'client/*.lua',
}

shared_script {
	'shared/*.lua'
}

server_scripts {
    'server/*.lua',
}

ui_page 'html/ui.html'
files {
	"html/ui.*",
	"html/img/*.png",
	"html/vendor/*.js",
}
