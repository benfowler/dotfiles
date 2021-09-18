#!/bin/bash

rm nvim-startup.log 

rm -f nvim-startup.log && nvim --startuptime nvim-startup.log -c 'q' && cat nvim-startup.log


