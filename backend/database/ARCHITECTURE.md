# TaskHub Database Architecture

## Overview
Banco de dados relacional MySQL para a aplicação TaskHub - um gerenciador de tarefas completo com suporte a categorização, comentários, anexos e controle de sessões.

## Diagrama de Relacionamentos

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  users ←─────────────┐                                                 │
│    │                 │                                                 │
│    ├──→ categories   │                                                 │
│    │                 │                                                 │
│    ├──→ tasks ───────┤──→ task_comments ─→ users                     │
│    │      │          │                                                 │
│    │      └──→ task_attachments ─→ users                             │
│    │                                                                   │
│    └──→ user_sessions                                                 │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Tabelas Detalhadas

### 1. `users` - Usuários da Aplicação
**Descrição**: Armazena informações dos usuários cadastrados no sistema.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `email` | VARCHAR(255) | NOT NULL, UNIQUE | Email único do usuário |
| `password` | VARCHAR(255) | NOT NULL | Senha criptografada (bcrypt) |
| `first_name` | VARCHAR(100) | | Primeiro nome |
| `last_name` | VARCHAR(100) | | Sobrenome |
| `avatar_url` | VARCHAR(500) | | URL da foto de perfil |
| `phone` | VARCHAR(20) | | Telefone de contato |
| `is_active` | BOOLEAN | DEFAULT TRUE | Status ativo/inativo |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Data de criação |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Data de atualização |
| `deleted_at` | TIMESTAMP | NULL | Data de exclusão (soft delete) |

**Índices**:
- `idx_email` (email) - Para busca rápida por email
- `idx_is_active` (is_active) - Para filtrar usuários ativos

---

### 2. `categories` - Categorias/Projetos
**Descrição**: Organiza tarefas em categorias relacionadas a um usuário específico.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `user_id` | INT | NOT NULL, FK → users | Usuário proprietário |
| `name` | VARCHAR(100) | NOT NULL | Nome da categoria |
| `description` | TEXT | | Descrição detalhada |
| `color` | VARCHAR(7) | | Código hexadecimal da cor (ex: #FF6B6B) |
| `icon` | VARCHAR(50) | | Nome do ícone (ex: briefcase, user) |
| `is_default` | BOOLEAN | DEFAULT FALSE | Marca categoria padrão |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Data de criação |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Data de atualização |
| `deleted_at` | TIMESTAMP | NULL | Data de exclusão (soft delete) |

**Índices**:
- `idx_user_id` (user_id) - Para buscar categorias de um usuário
- `unique_user_category` (user_id, name) - Garante unicidade de nome por usuário

**Relacionamentos**:
- Pertence a um usuário (user_id)
- Pode ter múltiplas tarefas

---

### 3. `tasks` - Tarefas
**Descrição**: Armazena as tarefas dos usuários com todas as informações relacionadas.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `user_id` | INT | NOT NULL, FK → users | Usuário proprietário |
| `category_id` | INT | FK → categories | Categoria associada |
| `title` | VARCHAR(255) | NOT NULL | Título da tarefa |
| `description` | TEXT | | Descrição detalhada |
| `status` | ENUM | DEFAULT 'todo' | Status: todo, in_progress, completed, cancelled |
| `priority` | ENUM | DEFAULT 'medium' | Prioridade: low, medium, high, urgent |
| `due_date` | DATE | | Data de vencimento |
| `completed_at` | TIMESTAMP | NULL | Data de conclusão |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Data de criação |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Data de atualização |
| `deleted_at` | TIMESTAMP | NULL | Data de exclusão (soft delete) |

**Índices**:
- `idx_user_id` (user_id) - Buscar tarefas do usuário
- `idx_category_id` (category_id) - Buscar tarefas por categoria
- `idx_status` (status) - Filtrar por status
- `idx_due_date` (due_date) - Buscar tarefas por data
- `idx_created_at` (created_at) - Ordenar por data de criação
- `idx_tasks_user_status` (user_id, status) - Combinado para performance
- `idx_tasks_user_due_date` (user_id, due_date) - Combinado para performance

**Relacionamentos**:
- Pertence a um usuário (user_id)
- Pertence a uma categoria (category_id) - opcional
- Pode ter múltiplos comentários
- Pode ter múltiplos anexos

---

### 4. `task_comments` - Comentários em Tarefas
**Descrição**: Permite que usuários deixem comentários/atualizações em tarefas.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `task_id` | INT | NOT NULL, FK → tasks | Tarefa comentada |
| `user_id` | INT | NOT NULL, FK → users | Usuário que comentou |
| `comment` | TEXT | NOT NULL | Texto do comentário |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Data de criação |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Data de atualização |
| `deleted_at` | TIMESTAMP | NULL | Data de exclusão (soft delete) |

**Índices**:
- `idx_task_id` (task_id) - Buscar comentários de uma tarefa
- `idx_user_id` (user_id) - Buscar comentários de um usuário
- `idx_created_at` (created_at) - Ordenar cronologicamente

**Relacionamentos**:
- Pertence a uma tarefa (task_id)
- Criado por um usuário (user_id)

---

### 5. `task_attachments` - Anexos de Tarefas
**Descrição**: Armazena informações sobre arquivos anexados às tarefas.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `task_id` | INT | NOT NULL, FK → tasks | Tarefa associada |
| `file_name` | VARCHAR(255) | NOT NULL | Nome original do arquivo |
| `file_path` | VARCHAR(500) | NOT NULL | Caminho de armazenamento |
| `file_size` | INT | | Tamanho em bytes |
| `file_type` | VARCHAR(50) | | Tipo MIME (ex: application/pdf) |
| `uploaded_by` | INT | NOT NULL, FK → users | Usuário que enviou |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Data de upload |
| `deleted_at` | TIMESTAMP | NULL | Data de exclusão (soft delete) |

**Índices**:
- `idx_task_id` (task_id) - Buscar anexos de uma tarefa
- `idx_uploaded_by` (uploaded_by) - Buscar uploads de um usuário

**Relacionamentos**:
- Pertence a uma tarefa (task_id)
- Enviado por um usuário (uploaded_by)

---

### 6. `user_sessions` - Sessões de Usuário
**Descrição**: Controla sessões e tokens de autenticação dos usuários.

| Campo | Tipo | Constraints | Descrição |
|-------|------|-------------|-----------|
| `id` | INT | PRIMARY KEY, AUTO_INCREMENT | Identificador único |
| `user_id` | INT | NOT NULL, FK → users | Usuário da sessão |
| `token` | VARCHAR(500) | NOT NULL, UNIQUE | Token JWT ou similar |
| `ip_address` | VARCHAR(45) | | Endereço IP do cliente |
| `user_agent` | VARCHAR(500) | | User agent do navegador/app |
| `expires_at` | TIMESTAMP | NOT NULL | Data de expiração |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Data de login |
| `deleted_at` | TIMESTAMP | NULL | Data de logout |

**Índices**:
- `idx_user_id` (user_id) - Buscar sessões de um usuário
- `idx_token` (token) - Validar token rapidamente
- `idx_expires_at` (expires_at) - Limpeza de sessões expiradas

**Relacionamentos**:
- Pertence a um usuário (user_id)

---

## Padrões Utilizados

### 1. **Soft Deletes**
Todas as tabelas possuem o campo `deleted_at` para manter histórico e evitar perda de dados:
```sql
WHERE deleted_at IS NULL  -- Usuários ativos
```

### 2. **Timestamps Automáticos**
- `created_at`: Preenchido automaticamente na inserção
- `updated_at`: Atualizado automaticamente em qualquer mudança
- Ambos em UTC

### 3. **Relacionamentos com Cascade**
- Exclusão de um usuário deleta suas categorias, tarefas e comentários
- Exclusão de uma tarefa deleta seus comentários e anexos

### 4. **Índices Otimizados**
- Índices simples em chaves estrangeiras
- Índices compostos para queries frequentes
- Índices em status, datas para filtros comuns

### 5. **Enums para Status**
Garante integridade de dados com valores pré-definidos:
- **Task Status**: todo, in_progress, completed, cancelled
- **Task Priority**: low, medium, high, urgent

---

## Queries de Exemplo

### Listar tarefas do usuário por fazer
```sql
SELECT * FROM tasks
WHERE user_id = 1 
  AND status != 'completed' 
  AND deleted_at IS NULL
ORDER BY due_date ASC;
```

### Tarefas vencidas
```sql
SELECT * FROM tasks
WHERE user_id = 1 
  AND due_date < CURDATE()
  AND status != 'completed'
  AND deleted_at IS NULL;
```

### Tarefas por categoria com contagem
```sql
SELECT c.name, COUNT(t.id) as total
FROM categories c
LEFT JOIN tasks t ON c.id = t.category_id AND t.deleted_at IS NULL
WHERE c.user_id = 1 AND c.deleted_at IS NULL
GROUP BY c.id, c.name;
```

### Últimos 5 comentários de uma tarefa
```sql
SELECT tc.*, u.first_name, u.last_name
FROM task_comments tc
JOIN users u ON tc.user_id = u.id
WHERE tc.task_id = 1 AND tc.deleted_at IS NULL
ORDER BY tc.created_at DESC
LIMIT 5;
```

---

## Informações Técnicas

- **Engine**: InnoDB (transações ACID)
- **Charset**: utf8mb4 (suporte a emojis)
- **Collation**: utf8mb4_unicode_ci
- **Tipo de Backup**: Suporta backup completo e incremental

---

## Próximas Etapas

1. Executar `create.sql` para criar estrutura
2. Executar `seed.sql` para popular dados de teste
3. Integrar queries no backend Node.js
4. Implementar validações de negócio
