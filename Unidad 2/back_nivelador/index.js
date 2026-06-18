const express = require('express');
const { exec } = require('child_process'); // Nos permite ejecutar comandos de la terminal de la PC
const app = express();
const PUERTO = 3000;

app.use(express.json());

// Ruta para abrir YouTube (Eje X)
app.post('/abrir-youtube', (req, res) => {
    console.log('📱 Teléfono inclinado en X: Abriendo YouTube...');
    // En Windows se usa 'start', en Mac 'open', en Linux 'xdg-open'
    exec('start chrome https://youtube.com'); 
    res.status(200).send({ estado: 'ok' });
});

// Ruta para abrir Google Chrome (Eje Y)
app.post('/abrir-chrome', (req, res) => {
    console.log('📱 Teléfono inclinado en Y: Abriendo Chrome...');
    exec('start chrome');
    res.status(200).send({ estado: 'ok' });
});

// Ruta para abrir Word (Eje Z)
app.post('/abrir-word', (req, res) => {
    console.log('📱 Teléfono inclinado en Z: Abriendo Word...');
    exec('start winword'); // Abre Word directamente si está instalado en Windows
    res.status(200).send({ estado: 'ok' });
});

app.listen(PUERTO, '0.0.0.0', () => {
    console.log(`🚀 Servidor escuchando en http://localhost:${PUERTO}`);
    console.log(`💡 Nota: Revisa la IP de tu PC usando 'ipconfig' en la terminal.`);
});