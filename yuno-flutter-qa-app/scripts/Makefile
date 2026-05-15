.PHONY: help setup-firebase install-deps install-deps-ios install-deps-android ios android all clean notify-version changelog-summary update-docs-pr

BRANCH_NAME = CI/release-flow
FLUTTER_SCRIPTS_PATH := $(shell pwd)

# Default target
.DEFAULT_GOAL := help

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(GREEN)Available targets:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

setup-firebase: ## Generate google-services.json from Bitrise secret
	@echo "$(GREEN)🔧 Setting up Firebase configuration...$(NC)"
	@if [ -z "$$GOOGLE_SERVICES_JSON" ]; then \
		echo "$(RED)❌ ERROR: GOOGLE_SERVICES_JSON environment variable is not set"; \
		exit 1; \
	fi
	@echo "$$GOOGLE_SERVICES_JSON" > ../android/app/google-services.json
	@if [ ! -f "../android/app/google-services.json" ]; then \
		echo "$(RED)❌ ERROR: google-services.json no se generó"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ google-services.json generado correctamente$(NC)"

install-deps-ios: ## Install iOS dependencies (Flutter, iOS pods, Fastlane gems)
	@echo "$(GREEN)📦 Installing iOS dependencies...$(NC)"
	@echo "$(YELLOW)Installing Flutter dependencies...$(NC)"
	@cd .. && flutter pub get
	@cd .. && flutter precache --ios
	@echo "$(YELLOW)Installing iOS pods...$(NC)"
	@cd ../ios && pod install && cd ../scripts
	@echo "$(YELLOW)Installing iOS Fastlane dependencies...$(NC)"
	@cd ../ios && \
	if [ -f "Gemfile" ]; then \
		bundle install; \
	fi && cd ../scripts
	@echo "$(GREEN)✅ iOS dependencies installed!$(NC)"

install-deps-android: ## Install Android dependencies (Flutter, Fastlane gems)
	@echo "$(GREEN)📦 Installing Android dependencies...$(NC)"
	@echo "$(YELLOW)Installing Flutter dependencies...$(NC)"
	@cd .. && flutter pub get
	@cd .. && flutter precache --android
	@echo "$(YELLOW)Installing Android Fastlane dependencies...$(NC)"
	@cd ../android && \
	if [ -f "Gemfile" ]; then \
		bundle install; \
	fi && cd ../scripts
	@echo "$(GREEN)✅ Android dependencies installed!$(NC)"

install-deps: install-deps-ios install-deps-android ## Install all dependencies (iOS and Android)
	@echo "$(GREEN)✅ All dependencies installed!$(NC)"

ios: ## Build iOS app, upload to TestFlight and LambdaTest
	@echo "$(GREEN)🚀 Starting iOS build and deployment...$(NC)"
	@cd ../ios && fastlane ios build_and_upload
	@echo "$(GREEN)✅ iOS deployment completed!$(NC)"

android: ## Build Android app, upload to Firebase App Tester and LambdaTest
	@echo "$(GREEN)🤖 Starting Android build and deployment...$(NC)"
	@cd ../android && fastlane android build_and_upload
	@echo "$(GREEN)✅ Android deployment completed!$(NC)"

all: setup-firebase install-deps android ios ## Build and deploy both iOS and Android apps
	@echo "$(GREEN)🎉 All deployments completed!$(NC)"


clean: ## Clean Flutter build artifacts
	@echo "$(YELLOW)🧹 Cleaning Flutter build artifacts...$(NC)"
	@cd .. && flutter clean
	@echo "$(GREEN)✅ Clean completed!$(NC)"

# Extract version info (useful for scripts)
version:
	@VERSION_LINE=$$(grep "^version:" ../pubspec.yaml | head -1); \
	VERSION_NAME=$$(echo $$VERSION_LINE | sed -n 's/.*version: *\([^+]*\).*/\1/p'); \
	VERSION_CODE=$$(echo $$VERSION_LINE | sed -n 's/.*version: *[^+]*+\(.*\)/\1/p'); \
	echo "Version Name: $$VERSION_NAME"; \
	echo "Version Code: $$VERSION_CODE"

changelog-summary: ## Generate AI summary of CHANGELOG.md and send to Slack (requires version=X.Y.Z)
	@if [ -z "$(version)" ]; then \
		echo "❌ Error: Version parameter required. Usage: make changelog-summary version=1.0.12"; \
		exit 1; \
	fi
	@./slack_changelog_summary.sh $(version)

update-docs-pr: ## Update Flutter release notes in yuno-docs and open a PR (requires version=X.Y.Z)
	@if [ -z "$(version)" ]; then \
		echo "❌ Error: Version parameter required. Usage: make update-docs-pr version=1.0.12"; \
		exit 1; \
	fi
	@echo "📚 Updating Flutter release notes in GitHub docs repository..."
	@if [ ! -f "RELEASE_SUMMARY.md" ]; then \
		echo "RELEASE_SUMMARY.md not found. Run 'make changelog-summary version=$(version)' first."; \
		exit 1; \
	fi
	@echo "🔄 Cloning/updating yuno-docs repository..."
	@if [ ! -d "./../../../yuno-docs" ]; then \
		git clone "https://$${REPO_USER}:$${GITHUB_TOKEN}@github.com/yuno-payments/yuno-docs.git" "./../../../yuno-docs"; \
	fi
	@cd "./../../../yuno-docs" && \
	git fetch origin main && \
	git checkout -B $(BRANCH_NAME)/$(version)-Flutter origin/main && \
	echo "📝 Updating Flutter release notes JSON..." && \
	$(FLUTTER_SCRIPTS_PATH)/build_release_json_flutter.sh changelog/source/flutter.json $(version) $(FLUTTER_SCRIPTS_PATH)/RELEASE_SUMMARY.md && \
	echo "✅ Release notes updated successfully" && \
	git add -A && \
	git commit -m "Update Flutter SDK release notes for version $(version)" && \
	echo "🚀 Pushing branch to origin..." && \
	git push origin $(BRANCH_NAME)/$(version)-Flutter --verbose 2>&1 && \
	echo "⏳ Waiting 5 seconds for GitHub API propagation..." && \
	sleep 5 && \
	echo "🔗 Creating Pull Request..." && \
	PR_RESPONSE=$$(curl -s -X POST \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer $${GITHUB_TOKEN}" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		https://api.github.com/repos/yuno-payments/yuno-docs/pulls \
		-d '{"title":"Update Flutter SDK release notes for version $(version)", \
			"body":"Automated update of Flutter SDK release notes for version $(version)", \
			"head":"yuno-payments:$(BRANCH_NAME)/$(version)-Flutter", \
			"base":"main"}') && \
	echo "🔍 GitHub API Response:" && \
	echo "$${PR_RESPONSE}" && \
	PR_URL=$$(echo "$${PR_RESPONSE}" | grep -o '"html_url": "[^"]*"' | head -1 | cut -d'"' -f4) && \
	echo "🔗 Extracted PR URL: $${PR_URL}" && \
	if [ -z "$${PR_URL}" ]; then \
		echo "❌ Error: Could not extract PR URL from API response."; \
		exit 1; \
	fi && \
	echo "📢 Sending PR notification to Slack..." && \
	bash "$(FLUTTER_SCRIPTS_PATH)/slack_pr_notification.sh" $(version) "$${PR_URL}" && \
	echo "🎉 Flutter release notes updated and PR notification sent!"

notify-version: ## Send version notification to Slack (version only, no build number)
	@echo "$(GREEN)📢 Sending version notification to Slack...$(NC)"
	@if [ -z "$$SLACK_BOTH_API_TOKEN" ]; then \
		echo "$(YELLOW)⚠️  WARNING: SLACK_BOTH_API_TOKEN not set, skipping notification$(NC)"; \
	else \
		VERSION_NAME=$$(grep "^version:" ../pubspec.yaml | head -1 | sed -n 's/.*version: *\([^+]*\).*/\1/p'); \
		GIT_BRANCH=$$(git -C .. rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"); \
		MESSAGE="Example App version $$VERSION_NAME"; \
		curl -s -X POST https://slack.com/api/chat.postMessage \
			-H 'Authorization: Bearer '"$$SLACK_BOTH_API_TOKEN" \
			-H 'Content-type: application/json' \
			--data '{ \
				"channel": "core-mobile-versions", \
				"text": "'"$$MESSAGE"'", \
				"attachments": [ \
					{ \
						"title": "Version Details", \
						"fields": [ \
							{ \
								"title": "Version Number", \
								"value": "'"$$VERSION_NAME"'", \
								"short": true \
							}, \
							{ \
								"title": "Git Branch", \
								"value": "'"$$GIT_BRANCH"'", \
								"short": true \
							} \
						], \
						"color": "#36a64f" \
					} \
				] \
			}' || echo "$(YELLOW)⚠️  Failed to send notification$(NC)"; \
	fi
	@echo "$(GREEN)✅ Notification sent!$(NC)"
