builddir := ../build
builddir_path := $(realpath $(builddir))

zsh_latest_tag := `/bin/zsh -c 'print $${$${(A)=$$(git tag --list)}[(R)r[0-9]*]}'`

all: mkdir_build configure_ninja run_ninja

release: fetch_latest_tag all

fetch_latest_tag:
	git checkout $(zsh_latest_tag)

mkdir_build: $(builddir_path)
	mkdir -p $(builddir_path)

configure_ninja: configure $(builddir_path)/include/OakAppKit/OakPasteboardSelector.h
	builddir=$(builddir_path) /bin/sh configure
	echo `rsync -aP Frameworks/OakAppKit/src/*.h $(builddir_path)/include/OakAppKit/`
	
run_ninja:
	ninja

clean:
	ninja -t clean
	rm -f build.ninja

.PHONY: clean fetch_latest_tag
