ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SCRIPTS = $(ROOT)/scripts

.PHONY: xcodegen

xcodegen:
	mint run xcodegen \
		--spec $(ROOT)/project.yml
