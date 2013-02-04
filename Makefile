builddir = build

zsh_latest_tag := `/bin/zsh -c 'print $${$${(A)=$$(git tag --list)}[(R)r[0-9]*]}'`

all: head

head: fetch_master build_all

release: fetch_latest_tag build_all

build_all: mkdir_build configure_ninja run_ninja

fetch_master:
	git fetch origin master
	git checkout master
	git submodule update --init

fetch_latest_tag:
	git fetch origin master
	git checkout $(zsh_latest_tag)
	git submodule update --init


mkdir_build: $(builddir_path)
	mkdir -p $(builddir)
	$(eval builddir_path := $(realpath $(builddir)))

configure_ninja: configure
	@echo Building in $(builddir_path)
	builddir=$(builddir_path) /bin/sh configure

#echo `rsync -aP Frameworks/OakAppKit/src/*.h $(builddir_path)/include/OakAppKit/`
	
run_ninja:
	ninja

clean:
	ninja -t clean
	rm -f build.ninja

.PHONY: clean fetch_latest_tag fetch_master
