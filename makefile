plugpath = /i/proj/nvpm
devlpath = /i/proj/nvpm/devl/plug
rsync    = rsync -aAXvzu --delete --exclude '.git*'
repos    = $(shell ls plug)

repo = $(word 1,$(strip $(word 1,$(file < repo))))


main: null;@$(call makerepo,$(repo))

mall: ;@$(call mall)

null: ;@echo -n

make = make --no-print-directory --silent

mark: null;@$(make) -C mark/ mark

define mall
	for repo in $(repos);do
		$(call makerepo,$$repo)
	done
endef

define makerepo
	$(call sync,$1)
	$(call gith,$1)
endef
define sync
	$(rsync) plug/$1/ $(plugpath)/$1
	cp LICENSE $(plugpath)/$1
endef

define gith
	cd $(plugpath)/$1
	echo 'Creating HelpTags for "$1" plugin'
	nvim +'helptags doc' +'qall'
	echo
	git status
	echo
	echo 'at $(plugpath)/$1 do: git add .?[Y/n]'
	read add
	if test -z "$$add" || test "$$add" == "y" || test "$$add" == "Y";then
		git add .
	fi
	echo
	echo -n 'write the commit message: '
	read message
	if test ! -z "$$message";then
		git commit -m "$$message"
	else
		git commit
	fi
	echo
	echo 'Push to repo https://gitlab.com/nvpm/$1?[Y/n]'
	read push
	if test -z "$$push" || test "$$push" == "y" || test "$$push" == "Y";then
		git push orig main
	fi
endef

.ONESHELL:
#branch = $(shell git rev-parse --abbrev-ref HEAD)
#repo = $(shell \
			 #if test "$(branch)" == "main";then\
			 #echo -n testmake;else echo -n $(branch);fi)

