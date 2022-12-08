fx_version "cerulean"

description "Christmas resource for QB-Core"
author "Redline Studios"
version '1.0'

lua54 'yes'

games {
  "gta5",
}

shared_scripts  {
  "shared/*.lua"
}

client_scripts {
  "client/*.lua"
}

server_script  {
  "server/*.lua"
}