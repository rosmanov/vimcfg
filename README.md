# Vimcfg - A Vim configuration

## Description

This is a fork of *spf13* Vim distribution. I'll try to keep things just a bit simpler.

## Installation

Enter the project's directory and run:

	make install

This should backup your existing `~/.vimrc` and/or `~/.vim/vimrc` files and pull in the new configuration.

## Upgrade

Note, if `~/.vim/conf.d/vimrc.bundles` file is changed (after `git pull`, for instance),
or you've installed or removed some bundle, then run the following commands to ensure
you have your bundles up to date (installed, at least):

	:BundleClean!
	:BundleInstall
	:BundleUpdate

Note, `make update` command can be used to run the first two commands above.

## Notes

For `neocomplete` you'll need Vim 7.3.885+ compiled with `if_lua`!
