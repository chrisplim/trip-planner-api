
test:
	mix test

lint:
	mix credo

checks: lint test

.PHONY: test lint checks
