# This Makefile uses GNU extensions and must be run with a copy of GNU Make.

npm.vim.zip: npm.vim
	zip -r $@ $<

npm.vim: npm.vim/COPYING npm.vim/doc/npm.txt npm.vim/plugin/npm.vim

npm.vim/%: %
	mkdir -p $(@D)
	cp $^ $@

clean:
	rm -rf npm.vim npm.vim.zip

.PHONY: clean
