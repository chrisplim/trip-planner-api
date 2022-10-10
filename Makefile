
test:
	mix test

lint:
	mix credo

check: lint test

.PHONY: test lint check
