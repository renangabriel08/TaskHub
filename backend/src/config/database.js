const mysql = require('mysql2/promise');
const config = require('./config');

// Pool de conexões para melhor performance
const pool = mysql.createPool(config.database);
// Testar conexão ao iniciar
pool.getConnection()
    .then(conn => {
        console.log('✅ Conectado ao banco de dados MySQL');
        conn.release();
    })
    .catch(err => {
        console.error('❌ Erro ao conectar ao banco de dados:', err.message);
        process.exit(1);
    });

module.exports = pool;
