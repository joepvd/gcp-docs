SHELL := /bin/bash

DOCFILES ?= $(shell script/get list sources.md)
SANITIZED_HTML ?= $(addprefix scratch/, $(notdir $(DOCFILES)))
SANITIZED_MARKDOWN ?= $(SANITIZED_HTML:.html=.md)

FILENAME = google_cloud_architect_docs
MOBI = $(FILENAME).mobi
EPUB = $(FILENAME).epub
MD = $(FILENAME).md

.PHONY: all
all: epub mobi

.PHONY: test
test: .ensure-shfmt .ensure-shellcheck
	shfmt -w -i 2 $$(shfmt -l .)
	shellcheck $$(shfmt -l .)
	git diff --exit-code -- $$(shfmt -l .)

.PHONY: get
get: $(DOCFILES)

docs/%:
	script/get $@ sources.md

.PHONY: clean
clean:
	rm -fr docs/* scratch/* $(MD) $(EPUB) $(MOBI)

.PHONY: sanitize
sanitize: $(SANITIZED_HTML)

scratch/%: docs/% script/sanitize
	script/sanitize $< > $@

.PHONY: markdown
markdown: .ensure-pandoc $(SANITIZED_MARKDOWN)

.PHONY: single-md
single-md: $(MD)

scratch/%.md: scratch/%.html
	pandoc -s $< -o $@

$(MD): $(SANITIZED_MARKDOWN)
	cat $^ > $@

.PHONY: epub
epub: .ensure-pandoc $(EPUB)

.PHONY: mobi
mobi: .ensure-calibre $(MOBI)

%.mobi: %.epub script/mobi
	script/mobi $<

$(EPUB): $(MD)
	pandoc -s $< -o $@

.PHONY: .ensure-pandoc
.ensure-pandoc:
	@command -v pandoc >/dev/null

.PHONY: .ensure-shfmt
.ensure-shfmt:
	@command -v shfmt >/dev/null

.PHONY: .ensure-shellcheck
.ensure-shellcheck:
	@command -v shellcheck >/dev/null
