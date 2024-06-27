.PHONY: all check_admin install_homebrew install_node install_php_composer copy_php_ini copy_database

all: check_admin install_homebrew install_node install_php_composer copy_php_ini copy_database

check_admin:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "This script must be run as root. Please run with sudo."; \
		exit 1; \
	fi

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
	@echo "Installing PHP-XML"
	pecl install xml
	@echo "Install PGSQL & SQLite & MySQL drivers"
	pecl install pdo_sqlite
	pecl install pdo_mysql
	pecl install pdo_pgsql
	pecl install mongodb

copy_php_ini:
	@echo "Copying php.ini to the PHP directory..."
	SCRIPT_DIRECTORY=$$(pwd)
	PHP_INI_SOURCE_PATH="$$SCRIPT_DIRECTORY/php.ini"
	PHP_INI_PATH="/usr/local/etc/php/8.3/php.ini"
	sudo cp $$PHP_INI_SOURCE_PATH $$PHP_INI_PATH

copy_database:
	@echo "Copying database.sqlite to the database directory..."
	cp ./database.sqlite ./database/

	@echo "PHP and Composer have been installed and configured. Database file has been copied."

