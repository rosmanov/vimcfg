install:
	./install

update:
	./update

clean:
	rm -rf $(HOME)/.vim*.vimcfg_backup_*

.PHONY: install update clean
