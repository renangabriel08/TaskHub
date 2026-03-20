-- ============================================================================
-- TaskHub Database Creation Script
-- Database: taskhub_db
-- ============================================================================

-- Drop existing database if exists
DROP DATABASE IF EXISTS taskhub_db;

-- Create database
CREATE DATABASE taskhub_db;
USE taskhub_db;

-- ============================================================================
-- TABLE: users
-- Description: Usuarios da aplicacao
-- ============================================================================
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  user_type ENUM('citizen', 'professional', 'company') NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  avatar_url VARCHAR(500),
  phone VARCHAR(20),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  INDEX idx_email (email),
  INDEX idx_user_type (user_type),
  INDEX idx_is_active (is_active)
);

-- ============================================================================
-- TABLE: citizens
-- Description: Dados complementares de usuarios cidadaos
-- ============================================================================
CREATE TABLE citizens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  document_type ENUM('cpf', 'rg', 'passport') NOT NULL,
  document_number VARCHAR(50) NOT NULL UNIQUE,
  document_issuer_state VARCHAR(2),
  birth_date DATE,
  gender VARCHAR(10),
  marital_status VARCHAR(50),
  mother_name VARCHAR(150),
  address_street VARCHAR(255),
  address_number VARCHAR(10),
  address_complement VARCHAR(255),
  address_neighborhood VARCHAR(100),
  address_city VARCHAR(100),
  address_state VARCHAR(2),
  address_zip_code VARCHAR(10),
  address_country VARCHAR(100) DEFAULT 'Brasil',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_document_number (document_number)
);

-- ============================================================================
-- TABLE: professionals
-- Description: Dados complementares de usuarios profissionais autonomos
-- ============================================================================
CREATE TABLE professionals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  document_type ENUM('cpf', 'rg', 'passport') NOT NULL,
  document_number VARCHAR(50) NOT NULL UNIQUE,
  document_issuer_state VARCHAR(2),
  professional_registry VARCHAR(100),
  service_type VARCHAR(255) NOT NULL,
  specialties VARCHAR(500),
  description TEXT,
  years_experience INT,
  portfolio_url VARCHAR(500),
  portfolio_items TEXT,
  education JSON,
  certifications JSON,
  hourly_rate DECIMAL(10, 2),
  availability_status ENUM('available', 'unavailable', 'on_vacation') DEFAULT 'available',
  working_hours JSON,
  address_street VARCHAR(255),
  address_number VARCHAR(10),
  address_complement VARCHAR(255),
  address_neighborhood VARCHAR(100),
  address_city VARCHAR(100),
  address_state VARCHAR(2),
  address_zip_code VARCHAR(10),
  address_country VARCHAR(100) DEFAULT 'Brasil',
  rating DECIMAL(3, 2),
  total_reviews INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_service_type (service_type),
  INDEX idx_availability (availability_status),
  INDEX idx_rating (rating)
);

-- ============================================================================
-- TABLE: companies
-- Description: Dados complementares de usuarios empresas prestadoras de servico
-- ============================================================================
CREATE TABLE companies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  company_name VARCHAR(255) NOT NULL,
  legal_name VARCHAR(255),
  cnpj VARCHAR(18) NOT NULL UNIQUE,
  registration_number VARCHAR(100),
  service_type VARCHAR(255) NOT NULL,
  specialties VARCHAR(500),
  description TEXT,
  employee_count INT,
  portfolio_url VARCHAR(500),
  portfolio_items TEXT,
  certifications JSON,
  website_url VARCHAR(500),
  work_started_year YEAR,
  address_street VARCHAR(255),
  address_number VARCHAR(10),
  address_complement VARCHAR(255),
  address_neighborhood VARCHAR(100),
  address_city VARCHAR(100),
  address_state VARCHAR(2),
  address_zip_code VARCHAR(10),
  address_country VARCHAR(100) DEFAULT 'Brasil',
  business_hours JSON,
  rating DECIMAL(3, 2),
  total_reviews INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_cnpj (cnpj),
  INDEX idx_service_type (service_type)
);

-- ============================================================================
-- TABLE: categories
-- Description: Categorias/Projetos para organizar tarefas
-- ============================================================================
CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  color VARCHAR(7),
  icon VARCHAR(50),
  is_default BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  UNIQUE KEY unique_user_category (user_id, name)
);

-- ============================================================================
-- TABLE: tasks
-- Description: Tarefas do usuario
-- ============================================================================
CREATE TABLE tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  category_id INT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status ENUM('todo', 'in_progress', 'completed', 'cancelled') DEFAULT 'todo',
  priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
  due_date DATE,
  completed_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
  INDEX idx_user_id (user_id),
  INDEX idx_category_id (category_id),
  INDEX idx_status (status),
  INDEX idx_due_date (due_date),
  INDEX idx_created_at (created_at)
);

-- ============================================================================
-- TABLE: task_comments
-- Description: Comentários nas tarefas
-- ============================================================================
CREATE TABLE task_comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  task_id INT NOT NULL,
  user_id INT NOT NULL,
  comment TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_task_id (task_id),
  INDEX idx_user_id (user_id),
  INDEX idx_created_at (created_at)
);

-- ============================================================================
-- TABLE: task_attachments
-- Description: Anexos/arquivos das tarefas
-- ============================================================================
CREATE TABLE task_attachments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  task_id INT NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_size INT,
  file_type VARCHAR(50),
  uploaded_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_task_id (task_id),
  INDEX idx_uploaded_by (uploaded_by)
);

-- ============================================================================
-- TABLE: user_sessions
-- Description: Sessoes de login dos usuarios
-- ============================================================================
CREATE TABLE user_sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  token VARCHAR(500) NOT NULL UNIQUE,
  ip_address VARCHAR(45),
  user_agent VARCHAR(500),
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_token (token),
  INDEX idx_expires_at (expires_at)
);

-- ============================================================================
-- Criar indices adicionais para otimizacao
-- ============================================================================
CREATE INDEX idx_tasks_user_status ON tasks(user_id, status);
CREATE INDEX idx_tasks_user_due_date ON tasks(user_id, due_date);
