const DatabaseService = require('./database.service');
const AuthService = require('./auth.service');

class RegistrationService {
    /**
     * Registrar um novo Cidadão (Citizen)
     */
    static async registerCitizen(data) {
        const { email, password, first_name, last_name, citizen_data } = data;

        // Validações básicas
        if (!email || !password) {
            throw new Error('Email e senha são obrigatórios');
        }

        if (password.length < 6) {
            throw new Error('Senha deve ter no mínimo 6 caracteres');
        }

        if (!citizen_data || !citizen_data.document_type || !citizen_data.document_number) {
            throw new Error('Dados do cidadão incompletos');
        }

        // Verificar se email já existe
        const existingUser = await DatabaseService.queryOne(
            'SELECT id FROM users WHERE email = ? AND deleted_at IS NULL',
            [email]
        );

        if (existingUser) {
            throw new Error('Email já cadastrado');
        }

        // Verificar se documento já existe
        const existingDocument = await DatabaseService.queryOne(
            'SELECT id FROM citizens WHERE document_number = ?',
            [citizen_data.document_number]
        );

        if (existingDocument) {
            throw new Error('Documento já cadastrado');
        }

        // Hash da senha
        const hashedPassword = await AuthService.hashPassword(password);

        // Inserir usuário
        const userId = await DatabaseService.insert('users', {
            email,
            password: hashedPassword,
            user_type: 'citizen',
            first_name: first_name || null,
            last_name: last_name || null,
            phone: citizen_data.phone || null,
            is_active: true,
        });

        // Inserir dados do cidadão
        await DatabaseService.insert('citizens', {
            user_id: userId,
            document_type: citizen_data.document_type,
            document_number: citizen_data.document_number,
            document_issuer_state: citizen_data.document_issuer_state || null,
            birth_date: citizen_data.birth_date || null,
            gender: citizen_data.gender || null,
            marital_status: citizen_data.marital_status || null,
            mother_name: citizen_data.mother_name || null,
            address_street: citizen_data.address_street || null,
            address_number: citizen_data.address_number || null,
            address_complement: citizen_data.address_complement || null,
            address_neighborhood: citizen_data.address_neighborhood || null,
            address_city: citizen_data.address_city || null,
            address_state: citizen_data.address_state || null,
            address_zip_code: citizen_data.address_zip_code || null,
            address_country: citizen_data.address_country || 'Brasil',
        });

        return userId;
    }

    /**
     * Registrar um novo Profissional Autônomo (Professional)
     */
    static async registerProfessional(data) {
        const { email, password, first_name, last_name, professional_data } = data;

        // Validações básicas
        if (!email || !password) {
            throw new Error('Email e senha são obrigatórios');
        }

        if (password.length < 6) {
            throw new Error('Senha deve ter no mínimo 6 caracteres');
        }

        if (!professional_data || !professional_data.document_type || !professional_data.document_number || !professional_data.service_type) {
            throw new Error('Dados do profissional incompletos');
        }

        // Verificar se email já existe
        const existingUser = await DatabaseService.queryOne(
            'SELECT id FROM users WHERE email = ? AND deleted_at IS NULL',
            [email]
        );

        if (existingUser) {
            throw new Error('Email já cadastrado');
        }

        // Verificar se documento já existe
        const existingDocument = await DatabaseService.queryOne(
            'SELECT id FROM professionals WHERE document_number = ?',
            [professional_data.document_number]
        );

        if (existingDocument) {
            throw new Error('Documento já cadastrado');
        }

        // Hash da senha
        const hashedPassword = await AuthService.hashPassword(password);

        // Inserir usuário
        const userId = await DatabaseService.insert('users', {
            email,
            password: hashedPassword,
            user_type: 'professional',
            first_name: first_name || null,
            last_name: last_name || null,
            phone: professional_data.phone || null,
            is_active: true,
        });

        // Inserir dados do profissional
        await DatabaseService.insert('professionals', {
            user_id: userId,
            document_type: professional_data.document_type,
            document_number: professional_data.document_number,
            document_issuer_state: professional_data.document_issuer_state || null,
            professional_registry: professional_data.professional_registry || null,
            service_type: professional_data.service_type,
            specialties: professional_data.specialties || null,
            description: professional_data.description || null,
            years_experience: professional_data.years_experience || 0,
            portfolio_url: professional_data.portfolio_url || null,
            portfolio_items: professional_data.portfolio_items ? JSON.stringify(professional_data.portfolio_items) : null,
            education: professional_data.education ? JSON.stringify(professional_data.education) : null,
            certifications: professional_data.certifications ? JSON.stringify(professional_data.certifications) : null,
            hourly_rate: professional_data.hourly_rate || null,
            availability_status: 'available',
            working_hours: professional_data.working_hours ? JSON.stringify(professional_data.working_hours) : null,
            address_street: professional_data.address_street || null,
            address_number: professional_data.address_number || null,
            address_complement: professional_data.address_complement || null,
            address_neighborhood: professional_data.address_neighborhood || null,
            address_city: professional_data.address_city || null,
            address_state: professional_data.address_state || null,
            address_zip_code: professional_data.address_zip_code || null,
            address_country: professional_data.address_country || 'Brasil',
        });

        return userId;
    }

    /**
     * Registrar uma nova Empresa (Company)
     */
    static async registerCompany(data) {
        const { email, password, company_data } = data;

        // Validações básicas
        if (!email || !password) {
            throw new Error('Email e senha são obrigatórios');
        }

        if (password.length < 6) {
            throw new Error('Senha deve ter no mínimo 6 caracteres');
        }

        if (!company_data || !company_data.company_name || !company_data.cnpj || !company_data.service_type) {
            throw new Error('Dados da empresa incompletos');
        }

        // Verificar se email já existe
        const existingUser = await DatabaseService.queryOne(
            'SELECT id FROM users WHERE email = ? AND deleted_at IS NULL',
            [email]
        );

        if (existingUser) {
            throw new Error('Email já cadastrado');
        }

        // Verificar se CNPJ já existe
        const existingCNPJ = await DatabaseService.queryOne(
            'SELECT id FROM companies WHERE cnpj = ?',
            [company_data.cnpj]
        );

        if (existingCNPJ) {
            throw new Error('CNPJ já cadastrado');
        }

        // Hash da senha
        const hashedPassword = await AuthService.hashPassword(password);

        // Inserir usuário
        const userId = await DatabaseService.insert('users', {
            email,
            password: hashedPassword,
            user_type: 'company',
            first_name: company_data.company_name || null,
            last_name: null,
            phone: company_data.phone || null,
            is_active: true,
        });

        // Inserir dados da empresa
        await DatabaseService.insert('companies', {
            user_id: userId,
            company_name: company_data.company_name,
            legal_name: company_data.legal_name || null,
            cnpj: company_data.cnpj,
            registration_number: company_data.registration_number || null,
            service_type: company_data.service_type,
            specialties: company_data.specialties || null,
            description: company_data.description || null,
            employee_count: company_data.employee_count || null,
            portfolio_url: company_data.portfolio_url || null,
            portfolio_items: company_data.portfolio_items ? JSON.stringify(company_data.portfolio_items) : null,
            certifications: company_data.certifications ? JSON.stringify(company_data.certifications) : null,
            website_url: company_data.website_url || null,
            work_started_year: company_data.work_started_year || null,
            address_street: company_data.address_street || null,
            address_number: company_data.address_number || null,
            address_complement: company_data.address_complement || null,
            address_neighborhood: company_data.address_neighborhood || null,
            address_city: company_data.address_city || null,
            address_state: company_data.address_state || null,
            address_zip_code: company_data.address_zip_code || null,
            address_country: company_data.address_country || 'Brasil',
            business_hours: company_data.business_hours ? JSON.stringify(company_data.business_hours) : null,
        });

        return userId;
    }

    /**
     * Obter perfil completo do usuário
     */
    static async getUserProfile(userId) {
        const user = await DatabaseService.queryOne(
            'SELECT * FROM users WHERE id = ? AND deleted_at IS NULL',
            [userId]
        );

        if (!user) {
            throw new Error('Usuário não encontrado');
        }

        let profile = null;

        if (user.user_type === 'citizen') {
            profile = await DatabaseService.queryOne(
                'SELECT * FROM citizens WHERE user_id = ?',
                [userId]
            );
        } else if (user.user_type === 'professional') {
            profile = await DatabaseService.queryOne(
                'SELECT * FROM professionals WHERE user_id = ?',
                [userId]
            );
        } else if (user.user_type === 'company') {
            profile = await DatabaseService.queryOne(
                'SELECT * FROM companies WHERE user_id = ?',
                [userId]
            );
        }

        return { user, profile };
    }
}

module.exports = RegistrationService;
