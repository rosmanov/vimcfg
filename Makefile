SRC_DIRS = conf.d
VIMRC_BACKUP = ~/.vimrc.$(shell date +%s)
VUNDLE_DIR = $(HOME)/.vim/bundle/vundle

pre-install:
	mkdir -p $(HOME)/.vim/bundle
	if [ -e $(HOME)/.vimrc ]; then cp $(HOME)/.vimrc $(VIMRC_BACKUP); fi
	if [ ! -d $(VUNDLE_DIR) ]; then git clone https://github.com/gmarik/vundle.git $(VUNDLE_DIR); fi

install: pre-install
	cp -R $(SRC_DIRS) $(HOME)/.vim
	ln -sf .vim/conf.d/vimrc $(HOME)/.vimrc
	vim -u conf.d/vimrc.bundles -i NONE -V1 -nNes +BundleInstall +qall!

.PHONY: pre-install install
