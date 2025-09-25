#!/bin/bash

cd ~/.local/share/nvim/site/pack/packer

for i in start/* opt/*; do
	cd $i
	echo "$i,$(git log -1 --format=%cd,%at)"
	cd ../..
done
