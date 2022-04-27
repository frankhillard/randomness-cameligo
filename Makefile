SHELL := /bin/bash

LIGO=ligo
ifeq (, $(shell which ligo))
        LIGO=docker run -v "$(PWD):$(PWD)" -w "$(PWD)" --rm -i ligolang/ligo:0.40.0
endif
# ^ use ligo bin if available, otherwise use docker

protocol=--protocol ithaca

help:
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

compile = $(LIGO) compile contract $(protocol) ./contracts/$(1) -o ./compiled/$(2) $(3)
# ^ compile contract to michelson or micheline

test = $(LIGO) run test $(protocol) ./test/$(1)
# ^ run given test file

compile: ## compile contracts
	@if [ ! -d ./compiled ]; then mkdir ./compiled ; fi
	@$(call compile,main.mligo,randomness.tz)
	@$(call compile,main.mligo,randomness.json,--michelson-format json)

clean: ## clean up
	@rm -rf compiled

.PHONY: test
test: ## run tests
	@$(call test,test.mligo)
	@$(call test,test_bytes.mligo)

deploy: node_modules deploy.js
	@echo "Deploying contract"
	@node deploy/deploy.js

deploy.js:
	@cd deploy && tsc deploy.ts --resolveJsonModule -esModuleInterop

node_modules:
	@echo "Install node modules"
	@cd deploy && npm install
