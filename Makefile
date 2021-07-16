SHELL := bash

ROOT := $(shell pwd)
TESTML := .testml
TESTML_REPO := https://github.com/testml-lang/testml

export PATH := $(TESTML)/bin:$(PATH)
export NODE_PATH := $(PWD)/lib
export TESTML_RUN := coffee-tap

test ?= test/*.tml

default:

.PHONY: test
test: $(TESTML)
	prove -v $(test)

clean:
	rm -fr $(TESTML) test/.testml

$(TESTML):
	git clone $(TESTML_REPO) $@
	make -C $@ work

