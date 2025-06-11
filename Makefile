.PHONY: test-latest test-integration test-main

test-latest:
	pip install -r requirements/latest.txt
	pytest --cov=testviper --html=report-latest.html --self-contained-html --junitxml=junit.xml -o junit_family=legacy

test-integration:
	pip install -r requirements/integration.txt
	pytest --cov=testviper --html=report-integration.html --self-contained-html --junitxml=junit.xml -o junit_family=legacy

test-main:
	pip install -r requirements/main.txt
	pytest --cov=testviper --html=report-main.html --self-contained-html --junitxml=junit.xml -o junit_family=legacy