clean: ## Clean project
	@echo "Cleaning the project..."
	@flutter clean
	@flutter pub get
	@flutter pub run flutter_native_splash:create
	@flutter pub run flutter_launcher_icons:main

build: ## Trigger one time code generation
	@echo "Generating code..."
	@flutter pub run build_runner build --delete-conflicting-outputs

watch: ## Watch files and trigger code generation on change
	@echo "Generating code on the fly..."
	@flutter pub run build_runner watch --delete-conflicting-outputs