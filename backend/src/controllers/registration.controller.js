const RegistrationService = require('../services/registration.service');
const AuthService = require('../services/auth.service');
const DatabaseService = require('../services/database.service');

class RegistrationController {
    /**
     * Registrar um novo Cidadão
     */
    static async registerCitizen(req, res) {
        try {
            const { email, password, first_name, last_name, citizen_data } = req.body;

            // Validações
            if (!email || !password) {
                return res.status(400).json({
                    success: false,
                    error: 'Email e senha são obrigatórios',
                });
            }

            const userId = await RegistrationService.registerCitizen({
                email,
                password,
                first_name,
                last_name,
                citizen_data,
            });

            // Buscar usuário criado
            const user = await DatabaseService.queryOne(
                'SELECT id, email, user_type, first_name, last_name FROM users WHERE id = ?',
                [userId]
            );

            // Gerar tokens
            const { accessToken, refreshToken } = AuthService.generateTokens(user);

            // Salvar refresh token na sessão
            await DatabaseService.insert('user_sessions', {
                user_id: userId,
                token: refreshToken,
                ip_address: req.ip || null,
                user_agent: req.get('user-agent') || null,
                expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
            });

            res.status(201).json({
                success: true,
                message: 'Cidadão registrado com sucesso',
                data: {
                    user,
                    accessToken,
                    refreshToken,
                },
            });
        } catch (error) {
            const statusCode = error.message.includes('já')
                ? 409
                : error.message.includes('incompletos')
                    ? 400
                    : 500;

            res.status(statusCode).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Registrar um novo Profissional Autônomo
     */
    static async registerProfessional(req, res) {
        try {
            const { email, password, first_name, last_name, professional_data } = req.body;

            // Validações
            if (!email || !password) {
                return res.status(400).json({
                    success: false,
                    error: 'Email e senha são obrigatórios',
                });
            }

            const userId = await RegistrationService.registerProfessional({
                email,
                password,
                first_name,
                last_name,
                professional_data,
            });

            // Buscar usuário criado
            const user = await DatabaseService.queryOne(
                'SELECT id, email, user_type, first_name, last_name FROM users WHERE id = ?',
                [userId]
            );

            // Gerar tokens
            const { accessToken, refreshToken } = AuthService.generateTokens(user);

            // Salvar refresh token na sessão
            await DatabaseService.insert('user_sessions', {
                user_id: userId,
                token: refreshToken,
                ip_address: req.ip || null,
                user_agent: req.get('user-agent') || null,
                expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
            });

            res.status(201).json({
                success: true,
                message: 'Profissional registrado com sucesso',
                data: {
                    user,
                    accessToken,
                    refreshToken,
                },
            });
        } catch (error) {
            const statusCode = error.message.includes('já')
                ? 409
                : error.message.includes('incompletos')
                    ? 400
                    : 500;

            res.status(statusCode).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Registrar uma nova Empresa
     */
    static async registerCompany(req, res) {
        try {
            const { email, password, company_data } = req.body;

            // Validações
            if (!email || !password) {
                return res.status(400).json({
                    success: false,
                    error: 'Email e senha são obrigatórios',
                });
            }

            const userId = await RegistrationService.registerCompany({
                email,
                password,
                company_data,
            });

            // Buscar usuário criado
            const user = await DatabaseService.queryOne(
                'SELECT id, email, user_type, first_name, last_name FROM users WHERE id = ?',
                [userId]
            );

            // Gerar tokens
            const { accessToken, refreshToken } = AuthService.generateTokens(user);

            // Salvar refresh token na sessão
            await DatabaseService.insert('user_sessions', {
                user_id: userId,
                token: refreshToken,
                ip_address: req.ip || null,
                user_agent: req.get('user-agent') || null,
                expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
            });

            res.status(201).json({
                success: true,
                message: 'Empresa registrada com sucesso',
                data: {
                    user,
                    accessToken,
                    refreshToken,
                },
            });
        } catch (error) {
            const statusCode = error.message.includes('já')
                ? 409
                : error.message.includes('incompletos')
                    ? 400
                    : 500;

            res.status(statusCode).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Obter perfil do usuário
     */
    static async getProfile(req, res) {
        try {
            const userId = req.user.id;

            const { user, profile } = await RegistrationService.getUserProfile(userId);

            res.json({
                success: true,
                data: {
                    user,
                    profile,
                },
            });
        } catch (error) {
            res.status(404).json({
                success: false,
                error: error.message,
            });
        }
    }
}

module.exports = RegistrationController;
