const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { config } = require('../config');

class AuthService {
    /**
     * Hash de senha com bcrypt
     */
    static async hashPassword(password) {
        const salt = await bcrypt.genSalt(10);
        return await bcrypt.hash(password, salt);
    }

    /**
     * Comparar senha com hash
     */
    static async comparePassword(password, hash) {
        return await bcrypt.compare(password, hash);
    }

    /**
     * Gerar access token JWT
     */
    static generateAccessToken(user) {
        return jwt.sign(
            {
                id: user.id,
                email: user.email,
                first_name: user.first_name,
                last_name: user.last_name,
            },
            config.jwt.secret,
            { expiresIn: config.jwt.expiresIn }
        );
    }

    /**
     * Gerar refresh token JWT (válido por 7 dias)
     */
    static generateRefreshToken(user) {
        return jwt.sign(
            { id: user.id },
            config.jwt.secret,
            { expiresIn: '7d' }
        );
    }

    /**
     * Verificar e decodificar token
     */
    static verifyToken(token) {
        try {
            return jwt.verify(token, config.jwt.secret);
        } catch (error) {
            throw new Error('Token inválido ou expirado');
        }
    }

    /**
     * Gerar tokens (access + refresh)
     */
    static generateTokens(user) {
        const accessToken = this.generateAccessToken(user);
        const refreshToken = this.generateRefreshToken(user);
        return { accessToken, refreshToken };
    }
}

module.exports = AuthService;
