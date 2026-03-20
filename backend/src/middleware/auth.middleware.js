const AuthService = require('../services/auth.service');

/**
 * Middleware de autenticação
 * Valida o access token no header Authorization
 * Se válido, adiciona req.user com dados do usuário
 */
const authMiddleware = (req, res, next) => {
    try {
        const authHeader = req.get('Authorization');

        if (!authHeader) {
            return res.status(401).json({
                success: false,
                error: 'Token não fornecido',
            });
        }

        // Extrair token do header "Bearer TOKEN"
        const parts = authHeader.split(' ');
        if (parts.length !== 2 || parts[0] !== 'Bearer') {
            return res.status(401).json({
                success: false,
                error: 'Formato do token inválido',
            });
        }

        const token = parts[1];

        // Verificar token
        const decoded = AuthService.verifyToken(token);
        req.user = decoded;

        next();
    } catch (error) {
        res.status(401).json({
            success: false,
            error: error.message || 'Token inválido',
        });
    }
};

module.exports = authMiddleware;
