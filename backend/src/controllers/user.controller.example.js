/**
 * Exemplo de Controller
 * Padrão a ser seguido para os demais controllers
 */

const DatabaseService = require('../services/database.service');

class UserController {
    /**
     * Listar todos os usuários
     */
    static async getAll(req, res) {
        try {
            const users = await DatabaseService.query(
                'SELECT id, email, first_name, last_name, phone, created_at FROM users WHERE deleted_at IS NULL'
            );
            res.json({ success: true, data: users });
        } catch (error) {
            res.status(500).json({ success: false, error: error.message });
        }
    }

    /**
     * Obter um usuário específico
     */
    static async getById(req, res) {
        try {
            const { id } = req.params;
            const user = await DatabaseService.queryOne(
                'SELECT id, email, first_name, last_name, phone, avatar_url, created_at FROM users WHERE id = ? AND deleted_at IS NULL',
                [id]
            );

            if (!user) {
                return res.status(404).json({ success: false, error: 'Usuário não encontrado' });
            }

            res.json({ success: true, data: user });
        } catch (error) {
            res.status(500).json({ success: false, error: error.message });
        }
    }

    /**
     * Criar um novo usuário
     */
    static async create(req, res) {
        try {
            const { email, password, first_name, last_name, phone } = req.body;

            // Validações básicas
            if (!email || !password) {
                return res.status(400).json({ success: false, error: 'Email e senha são obrigatórios' });
            }

            const userId = await DatabaseService.insert('users', {
                email,
                password,
                first_name: first_name || null,
                last_name: last_name || null,
                phone: phone || null,
            });

            res.status(201).json({ success: true, data: { id: userId } });
        } catch (error) {
            res.status(500).json({ success: false, error: error.message });
        }
    }

    /**
     * Atualizar um usuário
     */
    static async update(req, res) {
        try {
            const { id } = req.params;
            const { first_name, last_name, phone, avatar_url } = req.body;

            const affectedRows = await DatabaseService.update(
                'users',
                { first_name, last_name, phone, avatar_url },
                'id = ? AND deleted_at IS NULL',
                [id]
            );

            if (affectedRows === 0) {
                return res.status(404).json({ success: false, error: 'Usuário não encontrado' });
            }

            res.json({ success: true, data: { id, updated: true } });
        } catch (error) {
            res.status(500).json({ success: false, error: error.message });
        }
    }

    /**
     * Deletar um usuário (soft delete)
     */
    static async delete(req, res) {
        try {
            const { id } = req.params;

            const affectedRows = await DatabaseService.delete('users', 'id = ? AND deleted_at IS NULL', [id]);

            if (affectedRows === 0) {
                return res.status(404).json({ success: false, error: 'Usuário não encontrado' });
            }

            res.json({ success: true, data: { id, deleted: true } });
        } catch (error) {
            res.status(500).json({ success: false, error: error.message });
        }
    }
}

module.exports = UserController;
