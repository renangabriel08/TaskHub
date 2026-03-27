const express = require('express');
const router = express.Router();
const RegistrationController = require('../controllers/registration.controller');
const authMiddleware = require('../middleware/auth.middleware');

/**
 * POST /api/registration/client
 * POST /api/registration/citizen (legado)
 * Registrar novo Cliente
 * Body: {
 *   email,
 *   password,
 *   confirm_password,
 *   name,
 *   phone,
 *   photo?,
 *   first_name?,
 *   last_name?,
 *   citizen_data: {
 *     document_type: 'cpf',
 *     document_number, // CPF
 *     document_issuer_state?,
 *     birth_date,
 *     gender?,
 *     marital_status?,
 *     mother_name?,
 *     address_street,
 *     address_number,
 *     address_complement?,
 *     address_neighborhood,
 *     address_city,
 *     address_state,
 *     address_zip_code
 *   }
 * }
 */
router.post('/client', RegistrationController.registerClient);
router.post('/citizen', RegistrationController.registerCitizen);

/**
 * POST /api/registration/provider
 * POST /api/registration/professional (legado)
 * Registrar novo Prestador Autônomo
 * Body: {
 *   email,
 *   password,
 *   confirm_password,
 *   name,
 *   phone,
 *   photo?,
 *   first_name?,
 *   last_name?,
 *   professional_data: {
 *     document_type: 'cpf',
 *     document_number, // CPF
 *     document_issuer_state?,
 *     birth_date,
 *     professional_registry?,
 *     service_type,
 *     specialties,
 *     description,
 *     years_experience,
 *     has_high_school,
 *     has_technical_courses,
 *     has_higher_education,
 *     technical_courses?: string[],
 *     higher_education_courses?: string[],
 *     additional_courses?: string[],
 *     work_experience_description,
 *     completed_jobs_range: '0-5'|'6-20'|'21-50'|'51-100'|'100+',
 *     portfolio_url?,
 *     portfolio_items?: [],
 *     education?: [],
 *     certifications?: [],
 *     hourly_rate?,
 *     working_hours?: {},
 *     address_street,
 *     address_number,
 *     address_complement?,
 *     address_neighborhood,
 *     address_city,
 *     address_state,
 *     address_zip_code
 *   }
 * }
 */
router.post('/provider', RegistrationController.registerProvider);
router.post('/professional', RegistrationController.registerProfessional);

/**
 * POST /api/registration/company
 * Registrar nova Empresa
 * Body: {
 *   email,
 *   password,
 *   company_data: {
 *     company_name,
 *     legal_name?,
 *     cnpj,
 *     registration_number?,
 *     service_type,
 *     specialties?,
 *     description?,
 *     employee_count?,
 *     portfolio_url?,
 *     portfolio_items?: [],
 *     certifications?: [],
 *     website_url?,
 *     work_started_year?,
 *     phone?,
 *     address_street?,
 *     address_number?,
 *     address_complement?,
 *     address_neighborhood?,
 *     address_city?,
 *     address_state?,
 *     address_zip_code?,
 *     business_hours?: {}
 *   }
 * }
 */
router.post('/company', RegistrationController.registerCompany);

/**
 * GET /api/registration/profile
 * Obter perfil completo do usuário autenticado
 * Headers: Authorization: Bearer <accessToken>
 */
router.get('/profile', authMiddleware, RegistrationController.getProfile);

module.exports = router;
