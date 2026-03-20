# TaskHub Backend

Backend API server para a aplicação TaskHub construído em Node.js com Express e MySQL.

## 🚀 Quick Start

```bash
# Instalar dependências
npm install

# Configurar banco de dados
mysql -u root -p < database/create.sql

# Popular com dados de teste
mysql -u root -p taskhub_db < database/seed.sql

# Iniciar servidor (desenvolvimento)
npm run dev
```

## 📋 Pré-requisitos

- Node.js v14+
- MySQL v8.0+
- npm ou yarn

## 🔧 Configuração

### 1. Variáveis de Ambiente

Copie `.env.example` para `.env`:

```bash
cp .env.example .env
```

Configure as variáveis conforme necessário:

```env
PORT=3000
NODE_ENV=development
API_BASE_URL=http://localhost:3000

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=root
DB_NAME=taskhub_db
DB_PORT=3306

JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRES_IN=24h
```

### 2. Banco de Dados

```bash
# Criar banco de dados e tabelas
mysql -u root -p < database/create.sql

# Popular com dados de teste
mysql -u root -p taskhub_db < database/seed.sql
```

## 📁 Estrutura do Projeto

```
backend/
├── src/
│   ├── config/
│   │   ├── config.js            # Configurações centralizadas
│   │   ├── database.js          # Conexão MySQL
│   │   └── index.js             # Exports de config
│   ├── controllers/             # Lógica dos endpoints
│   ├── models/                  # Modelos de dados
│   ├── routes/                  # Definição de rotas
│   ├── services/
│   │   └── database.service.js  # Serviço de banco de dados
│   ├── middleware/              # Middlewares customizadas
│   ├── utils/                   # Funções utilitárias
│   └── index.js                 # Aplicação principal
├── database/
│   ├── create.sql               # Script de criação
│   ├── seed.sql                 # Script de população
│   └── ARCHITECTURE.md          # Documentação do banco
├── package.json
├── .env.example
├── .gitignore
├── README.md
└── SETUP.md
```

## 📚 Scripts Disponíveis

```bash
# Iniciar em modo desenvolvimento (com hot reload)
npm run dev

# Iniciar em modo produção
npm start

# Executar testes
npm test
```

## 🔌 API Endpoints

### Health Check

```bash
GET /api/health
```

Resposta:
```json
{
  "status": "OK",
  "message": "Backend is running",
  "database": "Connected",
  "environment": "development"
}
```

## 🗄️ Banco de Dados

Para mais informações sobre a estrutura do banco, tabelas e relacionamentos, veja:
- [Database Architecture](./database/ARCHITECTURE.md) - Documentação completa
- [Setup Guide](./SETUP.md) - Guia de instalação

### Tabelas Principais

- **users** - Usuários da aplicação
- **categories** - Categorias/Projetos
- **tasks** - Tarefas dos usuários
- **task_comments** - Comentários em tarefas
- **task_attachments** - Anexos de tarefas
- **user_sessions** - Sessões de autenticação

## 💾 DatabaseService

Classe utilitária para operações comuns no banco:

```javascript
const DatabaseService = require('../services/database.service');

// Executar query
const results = await DatabaseService.query('SELECT * FROM users');

// Buscar um registro
const user = await DatabaseService.queryOne('SELECT * FROM users WHERE id = ?', [1]);

// Inserir
const id = await DatabaseService.insert('users', { email: 'user@example.com' });

// Atualizar
await DatabaseService.update('users', { name: 'John' }, 'id = ?', [1]);

// Deletar (soft delete)
await DatabaseService.delete('users', 'id = ?', [1]);
```

## 📝 Exemplos de Controllers e Routes

Veja os arquivos de exemplo para padrão de desenvolvimento:

- [User Controller Example](./src/controllers/user.controller.example.js)
- [Users Routes Example](./src/routes/users.routes.example.js)

## 🐛 Troubleshooting

### Erro de Conexão com Banco

```
❌ Erro ao conectar ao banco de dados: ER_ACCESS_DENIED_FOR_USER
```

**Solução:**
- Verifique usuário e senha em `.env`
- Certifique-se de que MySQL está rodando
- Verifique host e porta

### Banco não encontrado

```
ER_BAD_DB_ERROR: Unknown database 'taskhub_db'
```

**Solução:**
- Execute o script de criação: `mysql -u root -p < database/create.sql`
- Confirme o nome do banco em `.env`

## 🔐 Segurança

- ✅ Use variáveis de ambiente para dados sensíveis
- ✅ Valide sempre os inputs
- ✅ Use prepared statements (já implementado no DatabaseService)
- ✅ Implemente autenticação JWT
- ✅ Configure CORS adequadamente para produção

## 📦 Dependências

- **express**: Framework web
- **mysql2**: Driver MySQL com suporte a promises
- **cors**: Middleware de CORS
- **body-parser**: Parser de JSON
- **dotenv**: Gerenciamento de variáveis de ambiente
- **nodemon**: Auto-reload em desenvolvimento

## 🚀 Deploy

Antes de fazer deploy:

1. Configure as variáveis de ambiente para produção
2. Use senhas fortes para o banco de dados
3. Habilite apenas as rotas necessárias
4. Implemente rate limiting
5. Configure logs apropriados
6. Use HTTPS em produção

## 📝 Licença

ISC

## 🤝 Próximas Etapas

- [x] Criar estrutura base do backend
- [x] Configurar conexão MySQL
- [x] Criar DatabaseService
- [ ] Implementar autenticação JWT
- [ ] Criar controllers para CRUD
- [ ] Implementar validações
- [ ] Adicionar testes
- [ ] Documentação Swagger/OpenAPI
- [ ] Configurar CI/CD

