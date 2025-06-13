.PHONY: test-latest test-integration test-main

test-latest:
	pip install -r requirements/base.txt
	pip install -r requirements/latest.txt

test-integration:
	pip install -r requirements/base.txt
	pip install -r requirements/integration.txt

test-main:
	pip install -r requirements/base.txt
	pip install -r requirements/main.txt
