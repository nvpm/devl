mark:
	@echo -n > mark.txt
	@nvim --noplugin --clean -u mark.vim --headless --startuptime mark.txt +q
	@echo -n 'VimL time --> '
	@tail -1 mark.txt
	@echo -n 'Lua  time --> '
	@rm mark.txt
	@echo
