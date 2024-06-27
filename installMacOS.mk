.PHONY: all install_homebrew install_node install_php_composer copy_php_ini copy_database

all: install_homebrew install_node install_php_composer copy_php_ini copy_database

install_homebrew:
	@echo "Checking for Homebrew..."
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Homebrew not found, installing..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	@echo "Homebrew is installed"

install_node:
	@echo "Installing Node.js LTS 20"
	brew install node@20

install_php_composer:
	@echo "Installing PHP 8.3"
	brew install php@8.3
	@echo "Linking PHP"
	brew link --force --overwrite php@8.3
	@echo "Installing Composer..."
	brew install composer

copy_database:
	@echo "Copying database.sqlite to the database directory..."
	cp ./database.sqlite ./database/

	@echo "PHP and Composer have been installed and configured. Database file has been copied."

