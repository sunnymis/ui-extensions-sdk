export PATH := ./node_modules/.bin:${PATH}

.PHONY: build build-pages lint clean test-unit test-integration

# Compile the API from the lib directory into dist/cf-widget-api.js
build:
	webpack
	@echo "Created 'dist/cf-widget-api-js'"
	@mkdir -p dist
	./node_modules/stylus/bin/stylus -u nib lib/style/index.styl -o dist/cf-widget-api.css --sourcemap

docs: build
	cp ./lib/style/styleguide.css ./dist/styleguide
	./node_modules/kss/bin/kss-node --config kss-config.json

watch:
	webpack --watch

lint:
	eslint lib/ bin/ test/

clean:
	rm -rf dist/*

build-pages: gh-pages build
	$(MAKE) -C gh-pages

gh-pages:
	git clone git@github.com:contentful/widget-sdk $@
	cd $@
	git checkout $@

test: test-unit test-integration

test-unit:
	_mocha test/unit/**/*-test.js

test-integration:
	_mocha test/integration/**/*-test.js
