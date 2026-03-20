const express = require('express');
const router = express.Router();
const RegistrationController = require('../controllers/registration.controller');
const authMiddleware = require('../middleware/auth.middleware');

/**
 * POST /api/registration/citizen
 * Registrar novo Cidadão
 * Body: {
 *   email,
 *   password,
 *   first_name?,
 *   last_name?,
 *   citizen_data: {
 *     document_type,
 *     document_number,
 *     document_issuer_state?,
 *     birth_date?,
 *     gender?,
 *     marital_status?,
 *     mother_name?,
 *     phone?,
 *     address_street?,
 *     address_number?,
 *     address_complement?,
 *     address_neighborhood?,
 *     address_city?,
 *     address_state?,
 *     address_zip_code?
 *   }
 * }
 */
router.post('/citizen', RegistrationController.registerCitizen);

/**
 * POST /api/registration/professional
 * Registrar novo Profissional Autônomo
 * Body: {
 *   email,
 *   password,
 *   first_name?,
 *   last_name?,
 *   professional_data: {
 *     document_type,
 *     document_number,
 *     document_issuer_state?,
 *     professional_registry?,
 *     service_type,
 *     specialties?,
 *     description?,
 *     years_experience?,
 *     portfolio_url?,
 *     portfolio_items?: [],
 *     education?: [],
 *     certifications?: [],
 *     hourly_rate?,
 *     working_hours?: {},
 *     phone?,
 *     address_street?,
 *     address_number?,
 *     address_complement?,
 *     address_neighborhood?,
 *     address_city?,
 *     address_state?,
 *     address_zip_code?
 *   }
 * }
 */
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
