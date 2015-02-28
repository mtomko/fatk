PRG=fatk

PACKAGES=-pkg re2 #-pkg bolt

all: $(PRG)

.PHONY: $(PRG)
$(PRG): main.native
	if [ ! -e bin ]; then mkdir bin; fi
	make main.native
	cp src/_build/main.native bin/$@

%.native %.byte:
	(cd src/; corebuild ${PACKAGES} $@)

.PHONY: semi-clean
semi-clean:
	ocamlbuild -clean

.PHONY: clean
clean: semi-clean
	rm -f bin/fastcue

.PHONY: all-clean
all-clean: clean
	rmdir bin
