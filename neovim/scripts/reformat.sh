#!/bin/bash

stylua --verbose --glob "**/*.lua" -- lua
echo exit code: $?


