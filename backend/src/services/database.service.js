const pool = require('../config/database');

/**
 * Classe base para operações de banco de dados
 * Fornece métodos auxiliares para queries comuns
 */
class DatabaseService {
    /**
     * Executar uma query simples
     * @param {string} sql - Query SQL
     * @param {array} params - Parâmetros da query
     * @returns {Promise<Array>}
     */
    static async query(sql, params = []) {
        try {
            const [rows] = await pool.query(sql, params);
            return rows;
        } catch (error) {
            console.error('Erro na query:', sql, error);
            throw error;
        }
    }

    /**
     * Executar uma query e retornar apenas um resultado
     * @param {string} sql - Query SQL
     * @param {array} params - Parâmetros da query
     * @returns {Promise<Object>}
     */
    static async queryOne(sql, params = []) {
        const rows = await this.query(sql, params);
        return rows.length > 0 ? rows[0] : null;
    }

    /**
     * Inserir um registro
     * @param {string} table - Nome da tabela
     * @param {object} data - Dados a inserir
     * @returns {Promise<number>} ID do registro inserido
     */
    static async insert(table, data) {
        const columns = Object.keys(data);
        const values = Object.values(data);
        const placeholders = columns.map(() => '?').join(', ');

        const sql = `INSERT INTO ${table} (${columns.join(', ')}) VALUES (${placeholders})`;
        const [result] = await pool.query(sql, values);
        return result.insertId;
    }

    /**
     * Atualizar um registro
     * @param {string} table - Nome da tabela
     * @param {object} data - Dados a atualizar
     * @param {string} where - Condição WHERE
     * @param {array} params - Parâmetros da condição
     * @returns {Promise<number>} Número de registros afetados
     */
    static async update(table, data, where, params = []) {
        const updates = Object.keys(data).map(key => `${key} = ?`).join(', ');
        const values = [...Object.values(data), ...params];

        const sql = `UPDATE ${table} SET ${updates} WHERE ${where}`;
        const [result] = await pool.query(sql, values);
        return result.affectedRows;
    }

    /**
     * Deletar um registro (soft delete)
     * @param {string} table - Nome da tabela
     * @param {string} where - Condição WHERE
     * @param {array} params - Parâmetros da condição
     * @returns {Promise<number>} Número de registros afetados
     */
    static async delete(table, where, params = []) {
        const sql = `UPDATE ${table} SET deleted_at = NOW() WHERE ${where}`;
        const [result] = await pool.query(sql, params);
        return result.affectedRows;
    }

    /**
     * Obter conexão do pool para operações complexas
     * @returns {Promise<Connection>}
     */
    static async getConnection() {
        return await pool.getConnection();
    }
}

module.exports = DatabaseService;
