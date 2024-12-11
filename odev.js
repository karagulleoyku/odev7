const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: process.env.DB_HOST,      
    user: process.env.DB_USER,       
    password: process.env.DB_PASSWORD, 
    database: process.env.DB_NAME    
  });

db.connect(err => {
    if (err) {
        console.error('MySQL connection error:', err);
    } else {
        console.log('Connected to MySQL');
    }
});

app.post('/students', (req, res) => {
    const { ad, soyad, bolumId } = req.body;
    const query = 'INSERT INTO Ogrenci (ad, soyad, bolumId) VALUES (?, ?, ?)';
    db.query(query, [ad, soyad, bolumId], (err, result) => {
        if (err) throw err;
        res.send({ message: 'Öğrenci eklendi', id: result.insertId });
    });
});

app.get('/students', (req, res) => {
    const query = 'SELECT * FROM Ogrenci';
    db.query(query, (err, results) => {
        if (err) throw err;
        res.send(results);
    });
});

app.get('/students/:id', (req, res) => {
    const { id } = req.params;
    const query = 'SELECT * FROM Ogrenci WHERE ogrenciID = ?';
    db.query(query, [id], (err, results) => {
        if (err) throw err;
        res.send(results[0]);
    });
});

app.put('/students/:id', (req, res) => {
    const { id } = req.params;
    const { ad, soyad, bolumId } = req.body;
    const query = 'UPDATE Ogrenci SET ad = ?, soyad = ?, bolumId = ? WHERE ogrenciID = ?';
    db.query(query, [ad, soyad, bolumId, id], (err) => {
        if (err) throw err;
        res.send({ message: 'Öğrenci güncellendi' });
    });
});


app.delete('/students/:id', (req, res) => {
    const { id } = req.params;
    const query = 'DELETE FROM Ogrenci WHERE ogrenciID = ?';
    db.query(query, [id], (err) => {
        if (err) throw err;
        res.send({ message: 'Öğrenci silindi' });
    });
});


app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});