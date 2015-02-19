PRG=fatk

all: $(PRG)

.PHONY: $(PRG)
$(PRG): main.native
#	if [ ! -e bin ]; then mkdir bin; fi
#	make fatk.native
#	cp `readlink fatk.native` bin/$@
#	rm fatk.native

%.native %.byte:
	(cd src/; corebuild -pkg re2 -pkg bolt $@)

.PHONY: semi-clean
semi-clean:
	ocamlbuild -clean

.PHONY: clean
clean: semi-clean
	rm -f bin/fastcue

.PHONY: all-clean
all-clean: clean
	rmdir bin
