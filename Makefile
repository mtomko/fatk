PRG=fatk

PACKAGES=-pkg re2# bolt
TEST_PACKAGES=-pkg ounit ${PACKAGES}

all: $(PRG) tests

.PHONY: tests
tests: $(PRG) test/*.ml
	corebuild ${TEST_PACKAGES} -Is src,test test.native
	@./test.native

.PHONY: $(PRG)
$(PRG): main.native
	if [ ! -e bin ]; then mkdir bin; fi
	make main.native
	cp _build/src/main.native bin/$@

%.native %.byte:
	corebuild ${PACKAGES} -Is src $@

.PHONY: semi-clean
semi-clean:
	corebuild -clean

.PHONY: clean
clean: semi-clean
	rm -f bin/fatk

.PHONY: all-clean
all-clean: clean
	rmdir bin
