build_apk: ## Cleans the environment and build
	@echo "╠ Cleaning the project..."
	@rm -rf pubspec.lock
	@flutter clean
	@flutter pub get
	@echo "╠ build apk the project..."
	@flutter build apk --release --dart-define-from-file=envs/env_dev.json