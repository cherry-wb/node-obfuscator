
ACCEPTANCE_TESTS := $(wildcard test/acceptance/*.js)

all: lint test test-acceptance

lint:
	@node_modules/.bin/jshint \
		--verbose \
		index.js \
		lib/*.js \
		test/*.js

test:
	@node_modules/.bin/mocha -R spec -r should

test-acceptance: examples/express/node_modules $(ACCEPTANCE_TESTS)
	@echo 'everything looks good'

examples/express/node_modules:
	cd examples/express; npm install

$(ACCEPTANCE_TESTS):
	node $@

test-cov:
	@rm -rf lib-cov
	jscoverage lib lib-cov
	@OBF_COV=1 node_modules/.bin/mocha -r should -R html-cov > coverage.html

docs:
	@docs \
		--out docs.md \
		--title "Obfuscator Documentation" \
		--type md \
		lib/obfuscator.js lib/utils.js

.PHONY: lint test-cov test $(ACCEPTANCE_TESTS)
