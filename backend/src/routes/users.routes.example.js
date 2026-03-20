/**
 * Exemplo de Rotas
 * Padrão a ser seguido para os demais routers
 */

const express = require('express');
const router = express.Router();
const UserController = require('../controllers/user.controller.example');

/**
 * GET /api/users
 * Listar todos os usuários
 */
router.get('/', UserController.getAll);

/**
 * GET /api/users/:id
 * Obter um usuário específico
 */
router.get('/:id', UserController.getById);

/**
 * POST /api/users
 * Criar um novo usuário
 */
router.post('/', UserController.create);

/**
 * PUT /api/users/:id
 * Atualizar um usuário
 */
router.put('/:id', UserController.update);

/**
 * DELETE /api/users/:id
 * Deletar um usuário (soft delete)
 */
router.delete('/:id', UserController.delete);

module.exports = router;
