const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/auth.controller');
const authMiddleware = require('../middleware/auth.middleware');

/**
 * POST /api/auth/register
 * Registrar novo usuário
 * Body: { email, password, first_name?, last_name? }
 */
router.post('/register', AuthController.register);

/**
 * POST /api/auth/login
 * Login de usuário
 * Body: { email, password }
 */
router.post('/login', AuthController.login);

/**
 * POST /api/auth/refresh
 * Renovar access token
 * Body: { refreshToken }
 */
router.post('/refresh', AuthController.refreshToken);

/**
 * POST /api/auth/logout
 * Fazer logout (deletar sessão)
 * Body: { refreshToken }
 */
router.post('/logout', AuthController.logout);

/**
 * GET /api/auth/profile
 * Obter perfil do usuário autenticado
 * Headers: Authorization: Bearer <accessToken>
 */
router.get('/profile', authMiddleware, AuthController.getProfile);

/**
 * PUT /api/auth/profile
 * Atualizar perfil do usuário
 * Headers: Authorization: Bearer <accessToken>
 * Body: { first_name?, last_name?, phone?, avatar_url? }
 */
router.put('/profile', authMiddleware, AuthController.updateProfile);

/**
 * POST /api/auth/change-password
 * Alterar senha do usuário
 * Headers: Authorization: Bearer <accessToken>
 * Body: { currentPassword, newPassword }
 */
router.post('/change-password', authMiddleware, AuthController.changePassword);

module.exports = router;
