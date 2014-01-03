#!/bin/bash -

dir=$(cd $(dirname "$0"); pwd)
vimdir='~/.vim'

tmpdir="/tmp/vimsetup`date +%s`"

cmd=( \
	"cp -R $dir $tmpdir" \
	"if [ -d $vimdir ]; then mv -f $vimdir ${vimdir}.`date +%s`; fi" \
	"if [ -f ~/.vimrc ]; then mv -f ~/.vimrc ~/.vimrc.`date +%s`; fi" \
	"mv $tmpdir $vimdir" \
	"ln -sf "$vimdir/conf.d/vimrc" ~/.vimrc" \
	"if [ ! -d $vimdir/bundle/vundle ]; then git clone https://github.com/gmarik/vundle.git $vimdir/bundle/vundle; fi" \
	"vim -u $vimdir/conf.d/vimrc.bundles +BundleInstall +qall"
	)

i=0
while [[ $i < ${#cmd[*]} ]]
do
	echo ${cmd[$i]}
	eval ${cmd[$i]} || exit 1
	(( ++i ))
done
