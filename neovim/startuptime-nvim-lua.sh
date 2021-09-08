#!/bin/bash

export XDG_CONFIG_HOME=/Users/bfowler/.nvim-lua

rm vim-startup.log 

rm -f vim-startup.log && nvim --startuptime vim-startup.log -c 'q' && cat vim-startup.log


