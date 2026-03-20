const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

// Importar configurações
const { config, database: db } = require('./config');

// Importar rotas
const authRoutes = require('./routes/auth.routes');
const registrationRoutes = require('./routes/registration.routes');

const app = express();

// Middleware
app.use(cors(config.cors));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.get('/api/health', async (req, res) => {
    try {
        const conn = await db.getConnection();
        await conn.ping();
        conn.release();
        res.json({
            status: 'OK',
            message: 'Backend is running',
            database: 'Connected',
            environment: config.NODE_ENV
        });
    } catch (err) {
        res.status(500).json({
            status: 'ERROR',
            message: 'Database connection failed',
            error: err.message
        });
    }
});

// Registrar rotas
app.use('/api/auth', authRoutes);
app.use('/api/registration', registrationRoutes);

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Internal Server Error' });
});

// Start server
app.listen(config.PORT, () => {
    console.log(`✅ TaskHub Backend running on port ${config.PORT}`);
    console.log(`📝 Environment: ${config.NODE_ENV}`);
    console.log(`🗄️  Database: ${config.database.database}@${config.database.host}`);
});
