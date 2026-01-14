.PHONY: help setup-firebase install-deps ios android all clean notify-completion

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

install-deps: ## Install all dependencies (Flutter, iOS pods, Fastlane gems)
	@echo "$(GREEN)📦 Installing dependencies...$(NC)"
	@echo "$(YELLOW)Installing Flutter dependencies...$(NC)"
	@cd .. && flutter pub get
	@cd .. && flutter precache --ios
	@cd .. && flutter precache --android
	@echo "$(YELLOW)Installing iOS pods...$(NC)"
	@echo "Current directory: $$(pwd)"
	@cd ../ios && pod install && cd ../scripts
	@echo "$(YELLOW)Installing Android Fastlane dependencies...$(NC)"
	@cd ../android && \
	if [ -f "Gemfile" ]; then \
		bundle install; \
	fi && cd ../scripts
	@echo "$(YELLOW)Installing iOS Fastlane dependencies...$(NC)"
	@cd ../ios && \
	if [ -f "Gemfile" ]; then \
		bundle install; \
	fi && cd ../scripts
	@echo "$(GREEN)✅ All dependencies installed!$(NC)"

ios: ## Build iOS app, upload to TestFlight and LambdaTest
	@echo "$(GREEN)🚀 Starting iOS build and deployment...$(NC)"
	@cd ../ios && fastlane ios build_and_upload
	@echo "$(GREEN)✅ iOS deployment completed!$(NC)"

android: ## Build Android app, upload to Firebase App Tester and LambdaTest
	@echo "$(GREEN)🤖 Starting Android build and deployment...$(NC)"
	@cd ../android && fastlane android build_and_upload; 
	@echo "$(GREEN)✅ Android deployment completed!$(NC)"

all: setup-firebase install-deps android ios notify-completion ## Build and deploy both iOS and Android apps
	@echo "$(GREEN)🎉 All deployments completed!$(NC)"

notify-completion: ## Notify Slack channels that both builds completed
	@echo "$(GREEN)📢 Notifying Slack channels...$(NC)"
	@if [ -z "$$SLACK_WEBHOOK_URL" ]; then \
		echo "$(YELLOW)⚠️  WARNING: SLACK_WEBHOOK_URL not set, skipping notification$(NC)"; \
	else \
		VERSION_NAME=$$(grep "^version:" ../pubspec.yaml | head -1 | sed -n 's/.*version: *\([^+]*\).*/\1/p'); \
		VERSION_CODE=$$(grep "^version:" ../pubspec.yaml | head -1 | sed -n 's/.*version: *[^+]*+\(.*\)/\1/p'); \
		GIT_BRANCH=$$(git -C .. rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown"); \
		curl -X POST "$$SLACK_WEBHOOK_URL" \
			-H 'Content-type: application/json' \
			--data '{ \
				"text": "✅ All builds completed successfully!", \
				"attachments": [ \
					{ \
						"title": "Build Summary", \
						"fields": [ \
							{ \
								"title": "Version", \
								"value": "'"$$VERSION_NAME"' ('"$$VERSION_CODE"')", \
								"short": true \
							}, \
							{ \
								"title": "Git Branch", \
								"value": "'"$$GIT_BRANCH"'", \
								"short": true \
							}, \
							{ \
								"title": "Platforms", \
								"value": "iOS ✅\nAndroid ✅", \
								"short": false \
							} \
						], \
						"color": "#36a64f" \
					} \
				] \
			}' || echo "$(YELLOW)⚠️  Failed to send notification$(NC)"; \
	fi
	@echo "$(GREEN)✅ Notification sent!$(NC)"

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

