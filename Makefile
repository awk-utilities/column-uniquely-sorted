#!/usr/bin/make -f


# Install/Uninstall make script for awk-utilities/column-uniquely-sorted
# Copyright (C) 2021 S0AndS0
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


#
#    Make variables to satisfy conventions
#
NAME = column-uniquely-sorted
VERSION = 0.0.1
PKG_NAME = $(NAME)-$(VERSION)


#
#    Lambda-like functions
#
path_append = $(strip $(1))$(__PATH_SEPARATOR__)$(strip $(2))


#
#    Make variables set upon run-time
#
##  Note ':=' is to avoid late binding that '=' entails
## Attempt to detect Operating System
ifeq '$(findstring :,$(PATH))' ';'
	__OS__ := Windows
else
	__OS__ := $(shell uname 2>/dev/null || echo 'Unknown')
	__OS__ := $(patsubst CYGWIN%,Cygwin,$(__OS__))
	__OS__ := $(patsubst MSYS%,MSYS,$(__OS__))
	__OS__ := $(patsubst MINGW%,MSYS,$(__OS__))
endif


ifeq '$(__OS__)' 'Windows'
	__PATH_SEPARATOR__ := \\
else
	__PATH_SEPARATOR__ := /
endif


## Obtain directory path that this Makefile lives in
ROOT_DIRECTORY_PATH := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
ROOT_DIRECTORY_NAME := $(notdir $(patsubst %/,%,$(ROOT_DIRECTORY_PATH)))


#
#    Make variables that readers &/or maintainers may wish to modify
#
SCRIPT_NAME := column-uniquely-sorted.awk
SCRIPT_TYPE	:= script
MAN_PATH := $(firstword $(subst :, ,$(shell manpath)))
MAN_DIR_NAME := man1
GIT_BRANCH := main
GIT_REMOTE := origin
## Note, path lists are separated by ':'
AWKPATH := $(shell gawk 'BEGIN {\
	split(ENVIRON["AWKPATH"], AWKPATH_ARRAY, ":");\
	print AWKPATH_ARRAY[length(AWKPATH_ARRAY)];\
}')

AWKLIBPATH := $(shell gawk 'BEGIN {\
	split(ENVIRON["AWKLIBPATH"], AWKLIBPATH_ARRAY, ":");\
	print AWKLIBPATH_ARRAY[length(AWKLIBPATH_ARRAY)];\
}')

ifeq ($(SCRIPT_TYPE), include)
	INSTALL_DIRECTORY := $(AWKPATH)
else ifeq ($(SCRIPT_TYPE), lib)
	INSTALL_DIRECTORY := $(AWKLIBPATH)
else
	INSTALL_DIRECTORY := $(HOME)/bin
endif


#
#    Override variables via optional configuration file
#
CONFIG := $(ROOT_DIRECTORY_PATH)/.make-config
ifneq ("$(wildcard $(CONFIG))", "")
	include $(CONFIG)
endif


#
#    Make variables built from components
#
INSTALL_PATH := $(call path_append, $(INSTALL_DIRECTORY), $(SCRIPT_NAME))

SCRIPT__SOURCE_PATH := $(call path_append, $(ROOT_DIRECTORY_PATH), $(SCRIPT_NAME))

MAN__SOURCE_DIR := $(call path_append, $(ROOT_DIRECTORY_PATH), $(MAN_DIR_NAME))
MAN__INSTALL_DIR := $(call path_append, $(MAN_PATH), $(MAN_DIR_NAME))

GIT_MODULES_PATH := $(call path_append, $(ROOT_DIRECTORY_PATH), .gitmodules)


#
#    Make targets and settings
#
.PHONY: clean git-pull install link-script list uninstall unlink-script man link-manual unlink-manual
.SILENT: clean config git-pull install link-script list uninstall unlink-script man link-manual unlink-manual
.ONESHELL: install uninstall

clean: SHELL := /bin/bash
clean: ## Removes configuration file
	[[ -f "$(ROOT_DIRECTORY_PATH)/.make-config" ]] && {
		rm -v "$(ROOT_DIRECTORY_PATH)/.make-config"
	}

config: SHELL := /bin/bash
config: ## Writes configuration file
	tee "$(ROOT_DIRECTORY_PATH)/.make-config" 1>/dev/null <<EOF
	SCRIPT_NAME = $(SCRIPT_NAME)
	AWKPATH = $(AWKPATH)
	AWKLIBPATH = $(AWKLIBPATH)
	INSTALL_DIRECTORY = $(INSTALL_DIRECTORY)
	__OS__ = $(__OS__)
	GIT_BRANCH := $(GIT_BRANCH)
	GIT_REMOTE := $(GIT_REMOTE)
	EOF

install: ## Runs targets -> link-script
install: | link-script link-manual

uninstall: ## Runs targets -> unlink-script
uninstall: | unlink-script unlink-manual

upgrade: ## Runs targets -> uninstall git-pull install
upgrade: | uninstall git-pull install

git-pull: SHELL := /bin/bash
git-pull: ## Pulls updates from default upstream Git remote
	pushd "$(ROOT_DIRECTORY_PATH)"
	git pull $(GIT_REMOTE) $(GIT_BRANCH)
	[[ -f "$(GIT_MODULES_PATH)" ]] && {
		git submodule update --init --merge --recursive
	}
	popd

link-script: SHELL := /bin/bash
link-script: ## Symbolically links to project script
	if [[ -L "$(INSTALL_PATH)" ]]; then
		printf >&2 'Link already exists -> %s\n' "$(INSTALL_PATH)"
	elif [[ -f "$(INSTALL_PATH)" ]]; then
		printf >&2 'Error link target is a file -> %s\n' "$(INSTALL_PATH)"
	else
		ln -sv "$(SCRIPT__SOURCE_PATH)" "$(INSTALL_PATH)"
	fi

unlink-script: SHELL := /bin/bash
unlink-script: ## Removes symbolic links to project script
	if [[ -L "$(INSTALL_PATH)" ]]; then
		rm -v "$(INSTALL_PATH)"
	elif [[ -f "$(INSTALL_PATH)" ]]; then
		printf >&2 'Error link target is a file -> %s\n' "$(INSTALL_PATH)"
	else
		printf >&2 'No link to remove at -> %s\n' "$(INSTALL_PATH)"
	fi

make-directory: SHELL := /bin/bash
make-directory: ## Makes sub-directory for Awk include, or lib, linked scripts
	if [[ -d "$(INSTALL_DIRECTORY)" ]]; then
		printf >&2 'Directory already exists -> %s\n' "$(INSTALL_DIRECTORY)"
	elif [[ "$(SCRIPT_TYPE)" =~ (include|^lib) ]]; then
		mkdir "$(INSTALL_DIRECTORY)"
	fi

remove-directory: SHELL := /bin/bash
remove-directory: ## Removes sub-directory for Awk include, or lib, linked scripts
	if ! [[ -d "$(INSTALL_DIRECTORY)" ]]; then
		printf >&2 'Directory does not exist -> %s\n' "$(INSTALL_DIRECTORY)"
	elif [[ "$(SCRIPT_TYPE)" =~ (include|^lib) ]]; then
		rmdir "$(INSTALL_DIRECTORY)"
	fi

man: SHELL := /bin/bash
man: ## Builds manual pages via `help2man` command
	if [[ -d "$(MAN__SOURCE_DIR)" ]]; then
		help2man "$(SCRIPT__SOURCE_PATH)" --help-option="--usage" --version-option="--license" --output="$(call path_append, $(MAN__SOURCE_DIR), $(NAME)).1" --no-info
	fi

link-manual: SHELL := /bin/bash
link-manual: ## Symbolically links project manual page(s)
	if ! [[ -d "$(MAN__SOURCE_DIR)" ]]; then
		printf >&2 'No manual entries found at -> %s\n' "$(MAN__SOURCE_DIR)"
		exit 0
	fi
	while read -r _page; do
		if [[ -L "$(MAN__INSTALL_DIR)$(__PATH_SEPARATOR__)$${_page}" ]]; then
			printf >&2 'Link already exists -> %s\n' "$(MAN__INSTALL_DIR)$(__PATH_SEPARATOR__)$${_page}"
		else
			ln -sv "$(MAN__SOURCE_DIR)$(__PATH_SEPARATOR__)$${_page}" "$(MAN__INSTALL_DIR)$(__PATH_SEPARATOR__)$${_page}"
		fi
	done < <(ls "$(MAN__SOURCE_DIR)")

unlink-manual: SHELL := /bin/bash
unlink-manual: ## Removes symbolic links to project manual page(s)
	if ! [[ -d "$(MAN__SOURCE_DIR)" ]]; then
		printf >&2 'No manual entries found at -> %s\n' "$(MAN__SOURCE_DIR)"
		exit 0
	fi
	while read -r _page; do
		if [[ -L "$(MAN__INSTALL_DIR)$(__PATH_SEPARATOR__)$${_page}" ]]; then
			rm -v "$(MAN__INSTALL_DIR)$(__PATH_SEPARATOR__)$${_page}"
		else
			printf >&2 'No manual page found at -> %s\n' "$(MAN__INSTALL_DIR)$(__PATH_SEPARATOR__)$${_page}"
		fi
	done < <(ls "$(MAN__SOURCE_DIR)")

list: SHELL := /bin/bash
list: ## Lists available make commands
	gawk 'BEGIN {
		delete matched_lines
	}
	{
		if ($$0 ~ "^[a-z0-9A-Z-]{1,32}: [#]{1,2}[[:print:]]*$$") {
			matched_lines[length(matched_lines)] = $$0
		}
	}
	END {
		print "## Make Commands for $(NAME) ##\n"
		for (k in matched_lines) {
			split(matched_lines[k], line_components, ":")
			gsub(" ## ", "    ", line_components[2])
			print line_components[1]
			print line_components[2]
			if ((k + 1) != length(matched_lines)) {
				print
			}
		}
	}' "$(ROOT_DIRECTORY_PATH)/Makefile"

