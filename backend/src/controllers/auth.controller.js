const DatabaseService = require('../services/database.service');
const AuthService = require('../services/auth.service');

class AuthController {
    /**
     * Registrar novo usuário
     */
    static async register(req, res) {
        try {
            const { email, password, first_name, last_name } = req.body;

            // Validações
            if (!email || !password) {
                return res.status(400).json({
                    success: false,
                    error: 'Email e senha são obrigatórios',
                });
            }

            if (password.length < 6) {
                return res.status(400).json({
                    success: false,
                    error: 'Senha deve ter no mínimo 6 caracteres',
                });
            }

            // Verificar se email já existe
            const existingUser = await DatabaseService.queryOne(
                'SELECT id FROM users WHERE email = ? AND deleted_at IS NULL',
                [email]
            );

            if (existingUser) {
                return res.status(409).json({
                    success: false,
                    error: 'Email já cadastrado',
                });
            }

            // Hash da senha
            const hashedPassword = await AuthService.hashPassword(password);

            // Inserir usuário
            const userId = await DatabaseService.insert('users', {
                email,
                password: hashedPassword,
                first_name: first_name || null,
                last_name: last_name || null,
                is_active: true,
            });

            // Buscar usuário criado
            const user = await DatabaseService.queryOne(
                'SELECT id, email, first_name, last_name FROM users WHERE id = ?',
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
                message: 'Usuário registrado com sucesso',
                data: {
                    user,
                    accessToken,
                    refreshToken,
                },
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Login de usuário
     */
    static async login(req, res) {
        try {
            const { email, cpf, password } = req.body;
            const normalizedCpf = String(cpf || '').replace(/\D/g, '');

            // Validações
            if ((!email && !normalizedCpf) || !password) {
                return res.status(400).json({
                    success: false,
                    error: 'Informe email ou cpf, e senha',
                });
            }

            // Buscar usuário
            const user = await DatabaseService.queryOne(
                `SELECT DISTINCT u.id, u.email, u.password, u.first_name, u.last_name, u.is_active
                 FROM users u
                 LEFT JOIN citizens c ON c.user_id = u.id
                 LEFT JOIN professionals p ON p.user_id = u.id
                 WHERE u.deleted_at IS NULL
                   AND (
                        u.email = ?
                        OR (c.document_type = 'cpf' AND REPLACE(REPLACE(REPLACE(REPLACE(c.document_number, '.', ''), '-', ''), '/', ''), ' ', '') = ?)
                        OR (p.document_type = 'cpf' AND REPLACE(REPLACE(REPLACE(REPLACE(p.document_number, '.', ''), '-', ''), '/', ''), ' ', '') = ?)
                   )`,
                [email || null, normalizedCpf || null, normalizedCpf || null]
            );

            if (!user) {
                return res.status(401).json({
                    success: false,
                    error: 'Credenciais inválidas',
                });
            }

            // Verificar se está ativo
            if (!user.is_active) {
                return res.status(403).json({
                    success: false,
                    error: 'Usuário inativo',
                });
            }

            // Comparar senha
            const passwordMatch = await AuthService.comparePassword(password, user.password);

            if (!passwordMatch) {
                return res.status(401).json({
                    success: false,
                    error: 'Credenciais inválidas',
                });
            }

            // Remover password do retorno
            delete user.password;

            // Gerar tokens
            const { accessToken, refreshToken } = AuthService.generateTokens(user);

            // Salvar refresh token na sessão
            await DatabaseService.insert('user_sessions', {
                user_id: user.id,
                token: refreshToken,
                ip_address: req.ip || null,
                user_agent: req.get('user-agent') || null,
                expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
            });

            res.json({
                success: true,
                message: 'Login realizado com sucesso',
                data: {
                    user,
                    accessToken,
                    refreshToken,
                },
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Refresh token
     */
    static async refreshToken(req, res) {
        try {
            const { refreshToken } = req.body;

            if (!refreshToken) {
                return res.status(400).json({
                    success: false,
                    error: 'Refresh token é obrigatório',
                });
            }

            // Verificar token
            const decoded = AuthService.verifyToken(refreshToken);

            // Verificar se existe na sessão
            const session = await DatabaseService.queryOne(
                'SELECT id FROM user_sessions WHERE token = ? AND expires_at > NOW() AND deleted_at IS NULL',
                [refreshToken]
            );

            if (!session) {
                return res.status(401).json({
                    success: false,
                    error: 'Refresh token inválido ou expirado',
                });
            }

            // Buscar usuário
            const user = await DatabaseService.queryOne(
                'SELECT id, email, first_name, last_name FROM users WHERE id = ? AND deleted_at IS NULL',
                [decoded.id]
            );

            if (!user) {
                return res.status(404).json({
                    success: false,
                    error: 'Usuário não encontrado',
                });
            }

            // Gerar novo access token
            const newAccessToken = AuthService.generateAccessToken(user);

            res.json({
                success: true,
                message: 'Token renovado com sucesso',
                data: {
                    accessToken: newAccessToken,
                },
            });
        } catch (error) {
            res.status(401).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Logout
     */
    static async logout(req, res) {
        try {
            const { refreshToken } = req.body;

            if (!refreshToken) {
                return res.status(400).json({
                    success: false,
                    error: 'Refresh token é obrigatório',
                });
            }

            // Deletar sessão
            await DatabaseService.delete(
                'user_sessions',
                'token = ? AND deleted_at IS NULL',
                [refreshToken]
            );

            res.json({
                success: true,
                message: 'Logout realizado com sucesso',
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Obter perfil do usuário autenticado
     */
    static async getProfile(req, res) {
        try {
            const userId = req.user.id;

            const user = await DatabaseService.queryOne(
                'SELECT id, email, first_name, last_name, avatar_url, phone, is_active FROM users WHERE id = ? AND deleted_at IS NULL',
                [userId]
            );

            if (!user) {
                return res.status(404).json({
                    success: false,
                    error: 'Usuário não encontrado',
                });
            }

            res.json({
                success: true,
                data: user,
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Atualizar perfil do usuário
     */
    static async updateProfile(req, res) {
        try {
            const userId = req.user.id;
            const { first_name, last_name, phone, avatar_url } = req.body;

            const affectedRows = await DatabaseService.update(
                'users',
                { first_name, last_name, phone, avatar_url },
                'id = ? AND deleted_at IS NULL',
                [userId]
            );

            if (affectedRows === 0) {
                return res.status(404).json({
                    success: false,
                    error: 'Usuário não encontrado',
                });
            }

            res.json({
                success: true,
                message: 'Perfil atualizado com sucesso',
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: error.message,
            });
        }
    }

    /**
     * Alterar senha
     */
    static async changePassword(req, res) {
        try {
            const userId = req.user.id;
            const { currentPassword, newPassword } = req.body;

            // Validações
            if (!currentPassword || !newPassword) {
                return res.status(400).json({
                    success: false,
                    error: 'Senha atual e nova senha são obrigatórias',
                });
            }

            if (newPassword.length < 6) {
                return res.status(400).json({
                    success: false,
                    error: 'Nova senha deve ter no mínimo 6 caracteres',
                });
            }

            // Buscar usuário
            const user = await DatabaseService.queryOne(
                'SELECT password FROM users WHERE id = ? AND deleted_at IS NULL',
                [userId]
            );

            if (!user) {
                return res.status(404).json({
                    success: false,
                    error: 'Usuário não encontrado',
                });
            }

            // Verificar senha atual
            const passwordMatch = await AuthService.comparePassword(currentPassword, user.password);

            if (!passwordMatch) {
                return res.status(401).json({
                    success: false,
                    error: 'Senha atual inválida',
                });
            }

            // Hash da nova senha
            const hashedPassword = await AuthService.hashPassword(newPassword);

            // Atualizar senha
            await DatabaseService.update(
                'users',
                { password: hashedPassword },
                'id = ?',
                [userId]
            );

            res.json({
                success: true,
                message: 'Senha alterada com sucesso',
            });
        } catch (error) {
            res.status(500).json({
                success: false,
                error: error.message,
            });
        }
    }
}

module.exports = AuthController;
