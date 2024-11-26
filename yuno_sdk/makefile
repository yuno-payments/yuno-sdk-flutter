COVERAGE_FILE := ../coverage/lcov_filtered.info
BADGE_FILE := coverage_badge.svg
COVERAGE_DIR := ./yuno_sdk
BADGE_URL_BASE := https://img.shields.io/badge/coverage-

.PHONY: coverage-badge

coverage-badge:
	# Remove generated files from coverage
	lcov --remove coverage/lcov.info 'lib/**/*.g.dart' 'lib/**/generated/*.dart' --ignore-errors unused -o coverage/lcov_filtered.info
	# Generate HTML report
	genhtml coverage/lcov_filtered.info -o coverage/html
	# Calculate coverage percentage and generate badge
	echo "Calculating coverage percentage..." && \
	COVERAGE=$$(lcov --summary $(COVERAGE_FILE) | grep "lines......" | cut -d ' ' -f 4 | cut -d '%' -f 1) && \
	echo "Coverage: $$COVERAGE%" && \
	echo "Generating badge URL..." && \
	BADGE_URL="$(BADGE_URL_BASE)$$COVERAGE%25-brightgreen?style=for-the-badge" && \
	echo "Badge URL: $$BADGE_URL" && \
	echo "Fetching badge image..." && \
	curl -o $(BADGE_FILE) $$BADGE_URL && \
	echo "Coverage badge saved to $(BADGE_FILE)"