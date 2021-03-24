SRC := bubblejail $(wildcard wrappers/*)


all:

test: all
	shfmt -ci -d $(SRC)
	shellcheck $(SRC)

check: test

.PHONY: all check test
