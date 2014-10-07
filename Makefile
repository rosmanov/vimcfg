DOT_VIM_SRC = vimrc conf.d
BACKUP_SUFFIX = .vimcfg_backup_$(shell date +%s)
VUNDLE_DIR = $(HOME)/.vim/bundle/vundle
VIMRC_BUNDLES_CONF = conf.d/vimrc.bundles

pre-install:
	mkdir -p $(VUNDLE_DIR)
	for f in $(HOME)/.vimrc $(HOME)/.vim; do \
		[ -e "$f" ] && mv -f "$f" "$f."$(BACKUP_SUFFIX); \
	done; \
	git clone https://github.com/gmarik/vundle.git $(VUNDLE_DIR)

install: pre-install $(DOT_VIM_SRC)
	cp -R $(DOT_VIM_SRC) $(HOME)/.vim
	vim -u $(VIMRC_BUNDLES_CONF) -i NONE -V1 -nNes +BundleClean! +BundleInstall +BundleUpdate +qall!

update: pre-install
	git pull
	vim -u $(VIMRC_BUNDLES_CONF) -i NONE -V1 -nNes +BundleClean! +BundleInstall +qall!

clean:
	rm -rf $(HOME)/.vim*.vimcfg_backup_*

.PHONY: pre-install install update clean
