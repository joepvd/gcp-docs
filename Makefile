SHELL := /bin/bash

DOCFILES ?= $(shell script/get list sources.md)
SANITIZED_HTML ?= $(addprefix sanitize/, $(notdir $(DOCFILES)))
SANITIZED_MARKDOWN ?= $(SANITIZED_HTML:.html=.md)

.PHONY: get
get: $(DOCFILES)

docs/%:
	script/get $@ sources.md

.PHONY: clean
clean:
	rm -fr docs/* sanitize/*

.PHONY: sanitize
sanitize: $(SANITIZED_HTML)

sanitize/%: docs/% script/sanitize
	script/sanitize $< > $@

.PHONY: markdown
markdown: .ensure-pandoc $(SANITIZED_MARKDOWN)

.PHONY: single-md
single-md: sanitize/alldocs.md

sanitize/%.md: sanitize/%.html
	pandoc -s $< -o $@

sanitize/alldocs.md: $(SANITIZED_MARKDOWN)
	cat $^ > $@

.PHONY: epub
epub: .ensure-pandoc docs.epub

docs.epub: sanitize/alldocs.md
	pandoc -s $< -o $@

.PHONY: .ensure-pandoc
.ensure-pandoc:
	@command -v pandoc>/dev/null
