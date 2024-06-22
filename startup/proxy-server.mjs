import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import { spawn } from 'child_process';
import path from 'path';
import process from 'process';
import { fileURLToPath } from 'url';
import fs from 'fs';

const app = express();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function findProjectRoot(currentDir, targetFolderName) {
    const root = path.parse(currentDir).root;
    while (currentDir !== root) {
        let possiblePath = path.join(currentDir, targetFolderName);
        if (fs.existsSync(possiblePath)) {
            return currentDir; 
        }
        currentDir = path.dirname(currentDir);
    }
    return null; 
}

const projectRoot = findProjectRoot(__dirname, 'ReactViteLaravel');
const PHPProjectPath = path.join(projectRoot, 'ReactViteLaravel');
console.log(`RUN PHP project at path: ${PHPProjectPath}`);

let PHPProcess;

const userHome = process.env.USERPROFILE;
const phpExePath = path.join(userHome, 'scoop', 'apps', 'php', 'current', 'php.exe');

const runPHPApp = () => {
    if (PHPProcess) {
        console.log('Stopping existing PHP application...');
        PHPProcess.kill(); 
        PHPProcess = null;
    }
    console.log('Starting PHP application...');
    console.log('Using PHP at:', phpExePath);
    console.log('Executing command:', phpExePath, ['artisan', 'serve']);

    PHPProcess = spawn(phpExePath, ['artisan', 'serve'], {
        stdio: 'inherit',
        shell: true,
        cwd: PHPProjectPath // Set the current working directory
    });

    PHPProcess.on('error', (err) => {
        console.error('Failed to start PHP application:', err);
    });

    PHPProcess.on('close', (code) => {
        console.log(`PHP process exited with code ${code}`);
    });
};

runPHPApp();

app.use((req, res, next) => {
    console.log(`Request received: ${req.method} ${req.url}`);
    next();
});

app.use('/api/', createProxyMiddleware({
    target: 'http://localhost:8000/',
    changeOrigin: true,
    ws: true
}));

app.use('/', createProxyMiddleware({
    target: 'http://localhost:5173/',
    changeOrigin: true,
    ws: false
}));

const PORT = 8888;
app.listen(PORT, () => {
    console.log(`Proxy server running on http://localhost:${PORT}`);
});

process.on('exit', () => {
    if (PHPProcess) {
        console.log('Stopping PHP application due to script exit...');
        PHPProcess.kill();
    }
});




