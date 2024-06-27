.PHONY: all check_admin install_node add_php_repo install_php_composer copy_php_ini copy_database

all: check_admin install_node add_php_repo install_php_composer copy_php_ini copy_database

check_admin:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "This script must be run as root. Please run with sudo."; \
		exit 1; \
	fi

install_node:
	@echo "Installing Node.js LTS 20"
	curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
	sudo apt-get install -y nodejs


add_php_repo:
	@echo "Adding repository for PHP 8"
	sudo apt-get update
	sudo apt-get install -y software-properties-common
	sudo add-apt-repository ppa:ondrej/php -y
	sudo apt-get update

install_php_composer:
	@echo "Installing PHP 8"
	sudo apt-get install -y php
	@echo "Installing Composer..."
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer
	php -r "unlink('composer-setup.php');"
	@echo "Installing PHP-XML"
	sudo apt-get install -y php-xml
	@echo "Install PGSQL & SQLite & MySQL drivers"
	sudo apt-get install -y php-sqlite3
	sudo apt-get install -y php-mysql
	sudo apt-get install -y php-pgsql

copy_php_ini:
	@echo "Copying php.ini to the PHP directories..."
	SCRIPT_DIRECTORY=$$(pwd)
	PHP_INI_SOURCE_PATH="$$SCRIPT_DIRECTORY/php.ini"
	PHP_INI_PATHS=$$(find /etc/php -name php.ini)
	for path in $$PHP_INI_PATHS; do \
		sudo cp $$PHP_INI_SOURCE_PATH $$path; \
	done

copy_database:
	@echo "Copying database.sqlite to the database directory..."
	cp ./database.sqlite ./database/


	@echo "PHP and Composer have been installed and configured. Database file has been copied."

