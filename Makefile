SHELL := /bin/bash

DOCFILES ?= $(shell script/get list sources.md)
SANITIZE_FILES ?= $(addprefix sanitize/, $(notdir $(DOCFILES)))

.PHONY: get
get: $(DOCFILES)

docs/%:
	script/get $@ sources.md

.PHONY: clean
clean:
	rm -fr docs/* sanitize/*

.PHONY: sanitize
sanitize: $(SANITIZE_FILES)

sanitize/%: docs/% script/sanitize
	script/sanitize $< $@
