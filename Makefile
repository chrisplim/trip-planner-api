
test:
	mix test

coverage:
	MIX_ENV=test mix coveralls.lcov

lint:
	mix credo

check: lint test

.PHONY: test lint check
