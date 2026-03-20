/**
 * Configurações da aplicação
 * Centraliza todas as constantes e configurações
 */

require('dotenv').config();

const config = {
    // Servidor
    PORT: process.env.PORT || 3000,
    NODE_ENV: process.env.NODE_ENV || 'development',
    API_BASE_URL: process.env.API_BASE_URL || 'http://localhost:3000',

    // Banco de Dados
    database: {
        host: process.env.DB_HOST || 'localhost',
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASSWORD || 'root',
        database: process.env.DB_NAME || 'taskhub_db',
        port: process.env.DB_PORT || 3306,
        waitForConnections: true,
        connectionLimit: 10,
        queueLimit: 0,
    },

    // JWT (para quando implementar autenticação)
    jwt: {
        secret: process.env.JWT_SECRET || 'your-secret-key',
        expiresIn: process.env.JWT_EXPIRES_IN || '24h',
    },

    // CORS
    cors: {
        origin: process.env.CORS_ORIGIN || 'http://localhost:*',
        credentials: true,
    },

    // Paginação padrão
    pagination: {
        defaultLimit: 10,
        maxLimit: 100,
    },
};

module.exports = config;
