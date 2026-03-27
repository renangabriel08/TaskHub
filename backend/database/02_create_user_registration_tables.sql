-- ============================================================================
-- 02_create_user_registration_tables.sql
-- Estrutura de tabelas para gerenciamento de cadastro de usuários
-- Execute após 01_create_database.sql
-- ============================================================================

USE taskhub_db;

-- ============================================================================
-- TABLE: users
-- ============================================================================
CREATE TABLE IF NOT EXISTS users (
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
  INDEX idx_users_email (email),
  INDEX idx_users_type (user_type),
  INDEX idx_users_active (is_active)
);

-- ============================================================================
-- TABLE: user_addresses
-- ============================================================================
CREATE TABLE IF NOT EXISTS user_addresses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  label VARCHAR(100) DEFAULT 'Principal',
  zip_code VARCHAR(10) NOT NULL,
  state VARCHAR(2) NOT NULL,
  city VARCHAR(100) NOT NULL,
  neighborhood VARCHAR(100) NOT NULL,
  street VARCHAR(255) NOT NULL,
  number VARCHAR(20) NOT NULL,
  complement VARCHAR(255),
  country VARCHAR(100) DEFAULT 'Brasil',
  is_primary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  CONSTRAINT fk_user_addresses_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_addresses_user (user_id),
  INDEX idx_user_addresses_primary (user_id, is_primary)
);

-- ============================================================================
-- TABLE: citizens
-- ============================================================================
CREATE TABLE IF NOT EXISTS citizens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  document_type ENUM('cpf', 'rg', 'passport') NOT NULL,
  document_number VARCHAR(50) NOT NULL UNIQUE,
  document_issuer_state VARCHAR(2),
  birth_date DATE,
  gender VARCHAR(20),
  marital_status VARCHAR(50),
  mother_name VARCHAR(150),
  address_street VARCHAR(255),
  address_number VARCHAR(20),
  address_complement VARCHAR(255),
  address_neighborhood VARCHAR(100),
  address_city VARCHAR(100),
  address_state VARCHAR(2),
  address_zip_code VARCHAR(10),
  address_country VARCHAR(100) DEFAULT 'Brasil',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_citizens_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_citizens_user (user_id),
  INDEX idx_citizens_document (document_type, document_number)
);

-- ============================================================================
-- TABLE: professionals
-- ============================================================================
CREATE TABLE IF NOT EXISTS professionals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL UNIQUE,
  document_type ENUM('cpf', 'rg', 'passport') NOT NULL,
  document_number VARCHAR(50) NOT NULL UNIQUE,
  document_issuer_state VARCHAR(2),
  birth_date DATE,
  professional_registry VARCHAR(100),
  service_type VARCHAR(255) NOT NULL,
  specialties VARCHAR(500),
  description TEXT,
  years_experience INT DEFAULT 0,
  has_high_school BOOLEAN DEFAULT FALSE,
  has_technical_courses BOOLEAN DEFAULT FALSE,
  has_higher_education BOOLEAN DEFAULT FALSE,
  technical_courses JSON,
  higher_education_courses JSON,
  additional_courses JSON,
  work_experience_description TEXT,
  completed_jobs_range ENUM('0-5', '6-20', '21-50', '51-100', '100+') DEFAULT '0-5',
  portfolio_url VARCHAR(500),
  portfolio_items JSON,
  education JSON,
  certifications JSON,
  hourly_rate DECIMAL(10, 2),
  availability_status ENUM('available', 'unavailable', 'on_vacation') DEFAULT 'available',
  working_hours JSON,
  address_street VARCHAR(255),
  address_number VARCHAR(20),
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
  CONSTRAINT fk_professionals_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_professionals_user (user_id),
  INDEX idx_professionals_document (document_type, document_number),
  INDEX idx_professionals_service_type (service_type),
  INDEX idx_professionals_availability (availability_status)
);

-- ============================================================================
-- TABLE: professional_service_types
-- Normalização para múltiplos tipos de serviço por prestador
-- ============================================================================
CREATE TABLE IF NOT EXISTS professional_service_types (
  id INT AUTO_INCREMENT PRIMARY KEY,
  professional_id INT NOT NULL,
  service_type_name VARCHAR(150) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_professional_service_types_professional
    FOREIGN KEY (professional_id) REFERENCES professionals(id) ON DELETE CASCADE,
  UNIQUE KEY uk_professional_service_type (professional_id, service_type_name),
  INDEX idx_professional_service_types_name (service_type_name)
);

-- ============================================================================
-- TABLE: professional_education_items
-- Normalização de formação/cursos por prestador
-- ============================================================================
CREATE TABLE IF NOT EXISTS professional_education_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  professional_id INT NOT NULL,
  education_type ENUM('high_school', 'technical', 'higher', 'additional') NOT NULL,
  course_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_professional_education_items_professional
    FOREIGN KEY (professional_id) REFERENCES professionals(id) ON DELETE CASCADE,
  INDEX idx_professional_education_items_professional (professional_id),
  INDEX idx_professional_education_items_type (education_type)
);

-- ============================================================================
-- TABLE: companies
-- Mantida para compatibilidade
-- ============================================================================
CREATE TABLE IF NOT EXISTS companies (
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
  portfolio_items JSON,
  certifications JSON,
  website_url VARCHAR(500),
  work_started_year YEAR,
  address_street VARCHAR(255),
  address_number VARCHAR(20),
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
  CONSTRAINT fk_companies_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_companies_cnpj (cnpj),
  INDEX idx_companies_service_type (service_type)
);

-- ============================================================================
-- TABLE: user_sessions
-- ============================================================================
CREATE TABLE IF NOT EXISTS user_sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  token VARCHAR(500) NOT NULL UNIQUE,
  ip_address VARCHAR(45),
  user_agent VARCHAR(500),
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  CONSTRAINT fk_user_sessions_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_sessions_user (user_id),
  INDEX idx_user_sessions_expires_at (expires_at)
);

-- ============================================================================
-- TABLE: terms_acceptances
-- Guarda aceite de termos para rastreabilidade jurídica
-- ============================================================================
CREATE TABLE IF NOT EXISTS terms_acceptances (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  terms_type VARCHAR(50) NOT NULL DEFAULT 'platform',
  terms_version VARCHAR(20) NOT NULL,
  accepted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),
  user_agent VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_terms_acceptances_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_terms_acceptances_user (user_id),
  INDEX idx_terms_acceptances_version (terms_version)
);
