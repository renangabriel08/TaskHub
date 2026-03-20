# 🔍 Guia Rápido de Referência - Backend

## 1️⃣ Adicionar Novo Controller

Crie um arquivo em `src/controllers/[nome].controller.js`:

```javascript
const DatabaseService = require('../services/database.service');

class [NomeController] {
  static async getAll(req, res) {
    try {
      const data = await DatabaseService.query('SELECT * FROM [tabela]');
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  static async getById(req, res) {
    try {
      const { id } = req.params;
      const data = await DatabaseService.queryOne('SELECT * FROM [tabela] WHERE id = ?', [id]);
      if (!data) return res.status(404).json({ success: false, error: 'Não encontrado' });
      res.json({ success: true, data });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  static async create(req, res) {
    try {
      const id = await DatabaseService.insert('[tabela]', req.body);
      res.status(201).json({ success: true, data: { id } });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  static async update(req, res) {
    try {
      const { id } = req.params;
      const affectedRows = await DatabaseService.update('[tabela]', req.body, 'id = ?', [id]);
      if (affectedRows === 0) return res.status(404).json({ success: false, error: 'Não encontrado' });
      res.json({ success: true, data: { updated: true } });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  }

  static async delete(req, res) {
    try {
      const { id } = req.params;
      const affectedRows = await DatabaseService.delete('[tabela]', 'id = ?', [id]);
      if (affectedRows === 0) return res.status(404).json({ success: false, error: 'Não encontrado' });
      res.json({ success: true, data: { deleted: true } });
    } catch (error) {
      res.status(500).json({ success: false, error: error.message });
    }
  }
}

module.exports = [NomeController];
```

## 2️⃣ Adicionar Novas Rotas

Crie um arquivo em `src/routes/[nome].routes.js`:

```javascript
const express = require('express');
const router = express.Router();
const [NomeController] = require('../controllers/[nome].controller');

router.get('/', [NomeController].getAll);
router.get('/:id', [NomeController].getById);
router.post('/', [NomeController].create);
router.put('/:id', [NomeController].update);
router.delete('/:id', [NomeController].delete);

module.exports = router;
```

## 3️⃣ Registrar Rotas no Express

No `src/index.js`, adicione:

```javascript
// Importar rotas
const usersRoutes = require('./routes/users.routes');

// Registrar rotas
app.use('/api/users', usersRoutes);
```

## 4️⃣ Usar DatabaseService

```javascript
// Query simples
const users = await DatabaseService.query(
  'SELECT * FROM users WHERE is_active = ?', 
  [true]
);

// Um registro
const user = await DatabaseService.queryOne(
  'SELECT * FROM users WHERE email = ?',
  [email]
);

// Inserir
const userId = await DatabaseService.insert('users', {
  email: 'user@example.com',
  password: 'hash',
  first_name: 'João'
});

// Atualizar
await DatabaseService.update(
  'users',
  { first_name: 'João Silva' },
  'id = ?',
  [1]
);

// Deletar (soft delete)
await DatabaseService.delete(
  'users',
  'id = ?',
  [1]
);
```

## 5️⃣ Padrão de Resposta

**Sucesso:**
```json
{
  "success": true,
  "data": { ... }
}
```

**Erro:**
```json
{
  "success": false,
  "error": "Mensagem de erro"
}
```

## 6️⃣ Tabelas Disponíveis

- `users` - Usuários
- `categories` - Categorias/Projetos
- `tasks` - Tarefas
- `task_comments` - Comentários
- `task_attachments` - Anexos
- `user_sessions` - Sessões

## 7️⃣ Soft Deletes

Sempre incluir `WHERE deleted_at IS NULL` nas queries:

```javascript
const users = await DatabaseService.query(
  'SELECT * FROM users WHERE deleted_at IS NULL'
);
```

## 8️⃣ Variáveis de Ambiente

Acessar via:

```javascript
const { config } = require('./config');

console.log(config.PORT);
console.log(config.NODE_ENV);
console.log(config.database.host);
```

## 9️⃣ Tratamento de Erros

```javascript
try {
  // código
} catch (error) {
  console.error('Erro:', error.message);
  res.status(500).json({ success: false, error: error.message });
}
```

## 🔟 Validações Comuns

```javascript
// Obrigatório
if (!email) {
  return res.status(400).json({ success: false, error: 'Email é obrigatório' });
}

// Tipo
if (typeof id !== 'number') {
  return res.status(400).json({ success: false, error: 'ID deve ser um número' });
}

// Existência
const user = await DatabaseService.queryOne('SELECT id FROM users WHERE id = ?', [id]);
if (!user) {
  return res.status(404).json({ success: false, error: 'Usuário não encontrado' });
}
```

---

**Dica:** Use os exemplos em `user.controller.example.js` e `users.routes.example.js` como referência ao criar novos controllers e rotas.
