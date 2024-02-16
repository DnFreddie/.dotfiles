#!/bin/bash
lunarvim_server=$(lsof -c lunarvim -Fn | grep servername | sed 's/^.//')
lunarvim --remote-send "<ESC>:tabnew $1<CR>:lua require('client').set_server('$lunarvim_server')<CR>"
lvim --remote-tab-silent "$1"

