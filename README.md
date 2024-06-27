# React + Vite + PHP 8 + Laravel

## Screenshots

![](screenshots/1.png)
![](screenshots/2.png)

## PROXY SERVER INCLUDED
```
http://localhost:8888 -> VITE + REACT
http://localhost:8888/api -> PHP 8.3 + Laravel BACKEND
```

## UPDATE 2024.06.27
* Installation is now supports debian based Linux(Ubuntu, Debian..)!
* Install Make - If you don't have it
```
1. sudo apt-get install make
2. sudo make -f installLinuxDebian.mk
```
* After you done with the installation script close Powershell and open it again.

* <b>Install vendor packages</b>
```
composer install
```
* <b>Rename .env.template to .env and run the following</b>
```
php artisan key:generate
```
* <b>cd to /Startup Folder and Install NodeJS dependencies</b>
```
npm install
```

## Installation
## Installation script works only on Windows 

* Use the installation script, install.ps1 (you will need to run as administrator) (it will install PHP + Composer + Configure php.ini)
```
powershell -ExecutionPolicy ByPass -File .\install.ps1
```
* After you done with the installation script close Powershell and open it again.

* <b>Install vendor packages</b>
```
composer install
```
* <b>Rename .env.template to .env and run the following</b>
```
php artisan key:generate
```
* <b>cd to /Startup Folder and Install NodeJS dependencies</b>
```
npm install
```


## RUN
To run the app CD to /Startup Folder
- It will run React + Vite
- Laravel also going to be run alongside React + Vite
```
npm run dev
```
## Development

* Frontend development (React) in the startup/src directory
* Backend development (Laravel) in the root directory


This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh
