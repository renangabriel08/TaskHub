-- ============================================================================
-- TaskHub Database Seed Script
-- Dados de exemplo para testes
-- ============================================================================

USE taskhub_db;

-- ============================================================================
-- Inserir usuarios de teste
-- ============================================================================
INSERT INTO users (email, password, first_name, last_name, avatar_url, phone, is_active) VALUES
('joao@example.com', '$2a$10$YIvxeNvW2ZKvxRhVHJjLZezrAJVuJWJy2PsZqKJm7YxQGPqhSGIYq', 'João', 'Silva', NULL, '11999999999', TRUE),
('maria@example.com', '$2a$10$YIvxeNvW2ZKvxRhVHJjLZezrAJVuJWJy2PsZqKJm7YxQGPqhSGIYq', 'Maria', 'Santos', NULL, '11988888888', TRUE),
('pedro@example.com', '$2a$10$YIvxeNvW2ZKvxRhVHJjLZezrAJVuJWJy2PsZqKJm7YxQGPqhSGIYq', 'Pedro', 'Oliveira', NULL, '11977777777', TRUE);

-- ============================================================================
-- Inserir categorias padrao
-- ============================================================================
INSERT INTO categories (user_id, name, description, color, icon, is_default) VALUES
-- Categorias para João
(1, 'Trabalho', 'Tarefas relacionadas ao trabalho', '#FF6B6B', 'briefcase', TRUE),
(1, 'Pessoal', 'Tarefas pessoais', '#4ECDC4', 'user', FALSE),
(1, 'Compras', 'Lista de compras', '#95E1D3', 'shopping-cart', FALSE),
(1, 'Saúde', 'Tarefas de saúde e exercício', '#FFD93D', 'heart', FALSE),

-- Categorias para Maria
(2, 'Trabalho', 'Tarefas do trabalho', '#FF6B6B', 'briefcase', TRUE),
(2, 'Estudos', 'Tarefas acadêmicas', '#6C5CE7', 'book', FALSE),
(2, 'Projetos', 'Projetos pessoais', '#A29BFE', 'layers', FALSE),

-- Categorias para Pedro
(3, 'Desenvolvimento', 'Tarefas de desenvolvimento', '#00B894', 'code', TRUE),
(3, 'Urgente', 'Tarefas urgentes', '#FF7675', 'alert-circle', FALSE);

-- ============================================================================
-- Inserir tarefas de exemplo
-- ============================================================================
INSERT INTO tasks (user_id, category_id, title, description, status, priority, due_date) VALUES
-- Tarefas de João
(1, 1, 'Finalizar projeto da apresentação', 'Completar slides e preparar demonstração', 'in_progress', 'high', DATE_ADD(CURDATE(), INTERVAL 3 DAY)),
(1, 1, 'Revisar documentação do código', 'Revisar e atualizar toda documentação', 'todo', 'medium', DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
(1, 2, 'Ir ao médico', 'Consulta de rotina agendada para quinta', 'todo', 'high', DATE_ADD(CURDATE(), INTERVAL 2 DAY)),
(1, 3, 'Comprar mantimentos', 'Leite, pão, ovos e frutas', 'todo', 'low', DATE_ADD(CURDATE(), INTERVAL 1 DAY)),
(1, 2, 'Chamar técnico de internet', 'A conexão caiu ontem', 'completed', 'urgent', CURDATE()),

-- Tarefas de Maria
(2, 5, 'Implementar novo módulo de autenticação', 'Adicionar suporte a OAuth2', 'in_progress', 'high', DATE_ADD(CURDATE(), INTERVAL 7 DAY)),
(2, 6, 'Estudar React Hooks', 'Completar curso de Hooks avançados', 'todo', 'medium', DATE_ADD(CURDATE(), INTERVAL 10 DAY)),
(2, 7, 'Design do aplicativo mobile', 'Finalizar mockups no Figma', 'todo', 'medium', DATE_ADD(CURDATE(), INTERVAL 4 DAY)),
(2, 6, 'Entregar trabalho final', 'Trabalho sobre arquitetura de sistemas', 'todo', 'high', DATE_ADD(CURDATE(), INTERVAL 2 DAY)),

-- Tarefas de Pedro
(3, 8, 'Corrigir bug no sistema de login', 'Token não está sendo refreshado corretamente', 'in_progress', 'urgent', CURDATE()),
(3, 8, 'Implementar cache em Redis', 'Melhorar performance das queries', 'todo', 'high', DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
(3, 9, 'Atualizar dependências do projeto', 'Verificar e atualizar npm packages', 'todo', 'medium', DATE_ADD(CURDATE(), INTERVAL 8 DAY));

-- ============================================================================
-- Inserir comentarios nas tarefas
-- ============================================================================
INSERT INTO task_comments (task_id, user_id, comment) VALUES
(1, 1, 'Já preparei 80% dos slides'),
(2, 1, 'Quer que eu também revise? - Maria'),
(6, 2, 'Encontrei uma boa biblioteca de OAuth2 em npm'),
(10, 3, 'O problema está no middleware de autenticação');

-- ============================================================================
-- Inserir anexos em tarefas
-- ============================================================================
INSERT INTO task_attachments (task_id, file_name, file_path, file_size, file_type, uploaded_by) VALUES
(1, 'apresentacao.pptx', '/uploads/tasks/1/apresentacao.pptx', 2048576, 'application/pptx', 1),
(6, 'oauth2_docs.pdf', '/uploads/tasks/6/oauth2_docs.pdf', 1048576, 'application/pdf', 2),
(7, 'mockups.figma', '/uploads/tasks/7/mockups.figma', 5242880, 'application/octet-stream', 2);

-- ============================================================================
-- Status final
-- ============================================================================
-- Todos os dados de seed foram inseridos com sucesso!
