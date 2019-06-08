.PHONY: docs
get:
	script/get sources.md

.PHONY: clean-docs
clean-docs:
	rm -fr docs/*
