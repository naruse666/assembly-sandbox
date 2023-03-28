filename = compiler
output_dir = ./output_files/
out_path = $(output_dir)$(filename)
# output_files にオブジェクトファイルをまとめてgitignoreする

.DEFAULT_GOAL := build
assemble:
	nasm -f macho64 $(filename).s -o $(out_path).o
.PHONY: assemble

build: assemble
	ld -arch x86_64 -o $(out_path) $(out_path).o -macosx_version_min 11.0 -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem
.PHONY: build