SHELL := /bin/bash

DOCFILES ?= $(shell script/get list sources.md)
SANITIZED_HTML ?= $(addprefix sanitize/, $(notdir $(DOCFILES)))
SANITIZED_MARKDOWN ?= $(SANITIZED_HTML:.html=.md)
FILENAME = google_cloud_architect_docs
MOBI = $(FILENAME).mobi
EPUB = $(FILENAME).epub
MD = $(FILENAME).md

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
single-md: $(MD)

sanitize/%.md: sanitize/%.html
	pandoc -s $< -o $@

$(MD): $(SANITIZED_MARKDOWN)
	cat $^ > $@

.PHONY: epub
epub: .ensure-pandoc $(EPUB)

.PHONY: mobi
mobi: $(MOBI)

%.mobi: %.epub script/mobi
	script/mobi $<

$(EPUB): $(MD)
	pandoc -s $< -o $@

.PHONY: .ensure-pandoc
.ensure-pandoc:
	@command -v pandoc>/dev/null
