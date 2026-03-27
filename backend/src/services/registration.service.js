const DatabaseService = require('./database.service');
const AuthService = require('./auth.service');

class RegistrationService {
    static normalizeDigits(value) {
        return String(value || '').replace(/\D/g, '');
    }

    static normalizeDocumentNumber(documentType, documentNumber) {
        const type = String(documentType || '').toLowerCase();
        if (type === 'cpf') {
            return this.normalizeDigits(documentNumber);
        }
        return String(documentNumber || '').trim();
    }

    static parseBirthDate(value) {
        if (!value) {
            return null;
        }

        const raw = String(value).trim();
        const brFormat = raw.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);

        if (brFormat) {
            return `${brFormat[3]}-${brFormat[2]}-${brFormat[1]}`;
        }

        return raw;
    }

    static splitName({ name, first_name, last_name, firstName, lastName }) {
        const first = first_name || firstName;
        const last = last_name || lastName;

        if (first || last) {
            return {
                first_name: first || null,
                last_name: last || null,
            };
        }

        const fullName = String(name || '').trim();
        if (!fullName) {
            return { first_name: null, last_name: null };
        }

        const parts = fullName.split(/\s+/);
        return {
            first_name: parts.shift() || null,
            last_name: parts.length > 0 ? parts.join(' ') : null,
        };
    }

    static parseStringList(value) {
        if (!value) {
            return [];
        }

        if (Array.isArray(value)) {
            return value
                .map((item) => String(item || '').trim())
                .filter((item) => item.length > 0);
        }

        const parsed = String(value)
            .split(',')
            .map((item) => item.trim())
            .filter((item) => item.length > 0);

        return parsed;
    }

    static normalizeEmail(value) {
        return String(value || '').trim().toLowerCase();
    }

    static extractServiceTypes(professionalData = {}) {
        const candidates =
            professionalData.service_types ||
            professionalData.serviceTypes ||
            professionalData.selected_categories ||
            professionalData.selectedCategories ||
            professionalData.tipo_servicos ||
            professionalData.service_type ||
            professionalData.serviceType ||
            professionalData.tipo_servico;

        return this.parseStringList(candidates);
    }

    static buildEducationItems({ hasHighSchool, technicalCourses, higherEducationCourses, additionalCourses }) {
        const items = [];

        if (hasHighSchool) {
            items.push({ education_type: 'high_school', course_name: 'Ensino Médio Completo' });
        }

        technicalCourses.forEach((course) => {
            items.push({ education_type: 'technical', course_name: course });
        });

        higherEducationCourses.forEach((course) => {
            items.push({ education_type: 'higher', course_name: course });
        });

        additionalCourses.forEach((course) => {
            items.push({ education_type: 'additional', course_name: course });
        });

        return items;
    }

    static buildAddress(data) {
        return {
            address_zip_code: data.address_zip_code || data.addressZipCode || data.cep || null,
            address_state: data.address_state || data.addressState || data.estado || null,
            address_city: data.address_city || data.addressCity || data.cidade || null,
            address_neighborhood: data.address_neighborhood || data.addressNeighborhood || data.bairro || data.abirro || null,
            address_street: data.address_street || data.addressStreet || data.rua || null,
            address_number: data.address_number || data.addressNumber || data.numero || data.nomero || null,
            address_complement: data.address_complement || data.addressComplement || data.complemento || null,
            address_country: data.address_country || data.addressCountry || 'Brasil',
        };
    }

    static validateAddressRequired(address) {
        if (!address.address_zip_code || !address.address_state || !address.address_city || !address.address_neighborhood || !address.address_street || !address.address_number) {
            throw new Error('Dados de endereço incompletos');
        }
    }

    static async insertPrimaryAddress(userId, address, label = 'Principal') {
        await DatabaseService.insert('user_addresses', {
            user_id: userId,
            label,
            zip_code: address.address_zip_code,
            state: address.address_state,
            city: address.address_city,
            neighborhood: address.address_neighborhood,
            street: address.address_street,
            number: address.address_number,
            complement: address.address_complement,
            country: address.address_country || 'Brasil',
            is_primary: true,
        });
    }

    /**
     * Registrar um novo Cidadão (Citizen)
     */
    static async registerCitizen(data) {
        const citizen_data = data.citizen_data || data.client_data || data.citizenData || {};
        const email = this.normalizeEmail(data.email);
        const password = String(data.password || '');
        const confirmPassword = data.confirm_password || data.confirmPassword;
        const phone = String(citizen_data.phone || data.phone || '').trim();
        const avatarUrl = data.avatar_url || data.avatarUrl || data.photo_url || data.photo || null;
        const { first_name, last_name } = this.splitName(data);

        const documentType = String(
            citizen_data.document_type || citizen_data.documentType || 'cpf'
        ).toLowerCase();
        const documentNumber = this.normalizeDocumentNumber(
            documentType,
            citizen_data.document_number || citizen_data.documentNumber || data.cpf
        );
        const birthDate = this.parseBirthDate(
            citizen_data.birth_date || citizen_data.birthDate || data.birth_date || data.birthDate || data.data_nascimento
        );
        const address = this.buildAddress({ ...data, ...citizen_data });

        // Validações básicas
        if (!email || !password) {
            throw new Error('Email e senha são obrigatórios');
        }

        if (!first_name) {
            throw new Error('Nome é obrigatório');
        }

        if (confirmPassword !== undefined && password !== confirmPassword) {
            throw new Error('Senha e confirmação de senha não conferem');
        }

        if (password.length < 6) {
            throw new Error('Senha deve ter no mínimo 6 caracteres');
        }

        if (!documentNumber || !birthDate || !phone) {
            throw new Error('Dados do cidadão incompletos');
        }

        this.validateAddressRequired(address);

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
            `SELECT id
             FROM citizens
             WHERE document_type = ?
               AND REPLACE(REPLACE(REPLACE(REPLACE(document_number, '.', ''), '-', ''), '/', ''), ' ', '') = ?
             LIMIT 1`,
            [documentType, documentNumber]
        );

        if (existingDocument) {
            throw new Error('Documento já cadastrado');
        }

        const existingProfessionalDocument = await DatabaseService.queryOne(
            `SELECT id
             FROM professionals
             WHERE document_type = ?
               AND REPLACE(REPLACE(REPLACE(REPLACE(document_number, '.', ''), '-', ''), '/', ''), ' ', '') = ?
             LIMIT 1`,
            [documentType, documentNumber]
        );

        if (existingProfessionalDocument) {
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
            avatar_url: avatarUrl,
            phone,
            is_active: true,
        });

        // Inserir dados do cidadão
        await DatabaseService.insert('citizens', {
            user_id: userId,
            document_type: documentType,
            document_number: documentNumber,
            document_issuer_state: citizen_data.document_issuer_state || citizen_data.documentIssuerState || null,
            birth_date: birthDate,
            gender: citizen_data.gender || null,
            marital_status: citizen_data.marital_status || null,
            mother_name: citizen_data.mother_name || null,
            address_street: address.address_street,
            address_number: address.address_number,
            address_complement: address.address_complement,
            address_neighborhood: address.address_neighborhood,
            address_city: address.address_city,
            address_state: address.address_state,
            address_zip_code: address.address_zip_code,
            address_country: address.address_country,
        });

        await this.insertPrimaryAddress(userId, address, 'Residencial');

        return userId;
    }

    /**
     * Registrar um novo Profissional Autônomo (Professional)
     */
    static async registerProfessional(data) {
        const professional_data = data.professional_data || data.provider_data || data.professionalData || {};
        const email = this.normalizeEmail(data.email);
        const password = String(data.password || '');
        const confirmPassword = data.confirm_password || data.confirmPassword;
        const phone = String(professional_data.phone || data.phone || '').trim();
        const avatarUrl = data.avatar_url || data.avatarUrl || data.photo_url || data.photo || null;
        const { first_name, last_name } = this.splitName(data);

        const documentType = String(
            professional_data.document_type || professional_data.documentType || 'cpf'
        ).toLowerCase();
        const documentNumber = this.normalizeDocumentNumber(
            documentType,
            professional_data.document_number || professional_data.documentNumber || data.cpf
        );
        const birthDate = this.parseBirthDate(
            professional_data.birth_date || professional_data.birthDate || data.birth_date || data.birthDate || data.data_nascimento
        );
        const address = this.buildAddress({ ...data, ...professional_data });

        const technicalCourses = this.parseStringList(
            professional_data.technical_courses || professional_data.technicalCourses || professional_data.cursos_tecnicos
        );
        const higherEducationCourses = this.parseStringList(
            professional_data.higher_education_courses || professional_data.higherEducationCourses || professional_data.ensinos_superiores
        );
        const additionalCourses = this.parseStringList(
            professional_data.additional_courses || professional_data.additionalCourses || professional_data.cursos_adicionais
        );

        const hasHighSchool = Boolean(
            professional_data.has_high_school !== undefined
                ? professional_data.has_high_school
                : professional_data.hasHighSchool || professional_data.tem_ensino_medio
        );
        const hasTechnicalCourses = Boolean(
            professional_data.has_technical_courses !== undefined
                ? professional_data.has_technical_courses
                : professional_data.hasTechnicalCourses || professional_data.tem_curso_tecnico || technicalCourses.length > 0
        );
        const hasHigherEducation = Boolean(
            professional_data.has_higher_education !== undefined
                ? professional_data.has_higher_education
                : professional_data.hasHigherEducation || professional_data.tem_ensino_superior || higherEducationCourses.length > 0
        );

        const completedJobsRange =
            professional_data.completed_jobs_range ||
            professional_data.completedJobsRange ||
            professional_data.quantidade_trabalhos_realizado ||
            '0-5';

        const workExperienceDescription =
            professional_data.work_experience_description ||
            professional_data.workExperienceDescription ||
            professional_data.descricao_experiencia ||
            '';

        const serviceType =
            professional_data.service_type ||
            professional_data.serviceType ||
            professional_data.tipo_servico;

        const serviceTypes = this.extractServiceTypes(professional_data);
        const normalizedServiceTypes = serviceTypes.length > 0
            ? serviceTypes
            : this.parseStringList(serviceType);

        const specialties =
            professional_data.specialties ||
            professional_data.especialidades ||
            professional_data.especioalidades;

        const description =
            professional_data.description ||
            professional_data.descricao ||
            professional_data.descicao;

        const yearsExperience = Number(
            professional_data.years_experience ||
            professional_data.yearsExperience ||
            professional_data.anos_experiencia ||
            0
        );

        // Validações básicas
        if (!email || !password) {
            throw new Error('Email e senha são obrigatórios');
        }

        if (!first_name) {
            throw new Error('Nome é obrigatório');
        }

        if (confirmPassword !== undefined && password !== confirmPassword) {
            throw new Error('Senha e confirmação de senha não conferem');
        }

        if (password.length < 6) {
            throw new Error('Senha deve ter no mínimo 6 caracteres');
        }

        if (!documentNumber || !birthDate || !phone || normalizedServiceTypes.length === 0 || !description || Number.isNaN(yearsExperience) || !workExperienceDescription) {
            throw new Error('Dados do profissional incompletos');
        }

        this.validateAddressRequired(address);

        if (!['0-5', '6-20', '21-50', '51-100', '100+'].includes(completedJobsRange)) {
            throw new Error('Faixa de trabalhos realizados inválida');
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
            `SELECT id
             FROM professionals
             WHERE document_type = ?
               AND REPLACE(REPLACE(REPLACE(REPLACE(document_number, '.', ''), '-', ''), '/', ''), ' ', '') = ?
             LIMIT 1`,
            [documentType, documentNumber]
        );

        if (existingDocument) {
            throw new Error('Documento já cadastrado');
        }

        const existingCitizenDocument = await DatabaseService.queryOne(
            `SELECT id
             FROM citizens
             WHERE document_type = ?
               AND REPLACE(REPLACE(REPLACE(REPLACE(document_number, '.', ''), '-', ''), '/', ''), ' ', '') = ?
             LIMIT 1`,
            [documentType, documentNumber]
        );

        if (existingCitizenDocument) {
            throw new Error('Documento já cadastrado');
        }

        const hashedPassword = await AuthService.hashPassword(password);
        const legacyEducation = [];
        const normalizedEducationItems = this.buildEducationItems({
            hasHighSchool,
            technicalCourses,
            higherEducationCourses,
            additionalCourses,
        });

        normalizedEducationItems.forEach((item) => {
            if (item.education_type === 'high_school') {
                legacyEducation.push({ degree: 'Ensino Médio', fieldOfStudy: null });
            } else if (item.education_type === 'technical') {
                legacyEducation.push({ degree: 'Curso Técnico', fieldOfStudy: item.course_name });
            } else if (item.education_type === 'higher') {
                legacyEducation.push({ degree: 'Ensino Superior', fieldOfStudy: item.course_name });
            } else {
                legacyEducation.push({ degree: 'Curso Adicional', fieldOfStudy: item.course_name });
            }
        });

        const connection = await DatabaseService.getConnection();

        try {
            await connection.beginTransaction();

            const [userResult] = await connection.query(
                `INSERT INTO users (email, password, user_type, first_name, last_name, avatar_url, phone, is_active)
                 VALUES (?, ?, 'professional', ?, ?, ?, ?, TRUE)`,
                [email, hashedPassword, first_name || null, last_name || null, avatarUrl, phone]
            );

            const userId = userResult.insertId;

            const [professionalResult] = await connection.query(
                `INSERT INTO professionals (
                    user_id,
                    document_type,
                    document_number,
                    document_issuer_state,
                    professional_registry,
                    birth_date,
                    service_type,
                    specialties,
                    description,
                    years_experience,
                    has_high_school,
                    has_technical_courses,
                    has_higher_education,
                    technical_courses,
                    higher_education_courses,
                    additional_courses,
                    work_experience_description,
                    completed_jobs_range,
                    portfolio_url,
                    portfolio_items,
                    education,
                    certifications,
                    hourly_rate,
                    availability_status,
                    working_hours,
                    address_street,
                    address_number,
                    address_complement,
                    address_neighborhood,
                    address_city,
                    address_state,
                    address_zip_code,
                    address_country
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'available', ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [
                    userId,
                    documentType,
                    documentNumber,
                    professional_data.document_issuer_state || professional_data.documentIssuerState || null,
                    professional_data.professional_registry || professional_data.professionalRegistry || null,
                    birthDate,
                    normalizedServiceTypes[0],
                    specialties || null,
                    description,
                    yearsExperience,
                    hasHighSchool,
                    hasTechnicalCourses,
                    hasHigherEducation,
                    JSON.stringify(technicalCourses),
                    JSON.stringify(higherEducationCourses),
                    JSON.stringify(additionalCourses),
                    workExperienceDescription,
                    completedJobsRange,
                    professional_data.portfolio_url || null,
                    professional_data.portfolio_items ? JSON.stringify(professional_data.portfolio_items) : null,
                    legacyEducation.length > 0 ? JSON.stringify(legacyEducation) : null,
                    professional_data.certifications ? JSON.stringify(professional_data.certifications) : null,
                    professional_data.hourly_rate || null,
                    professional_data.working_hours ? JSON.stringify(professional_data.working_hours) : null,
                    address.address_street,
                    address.address_number,
                    address.address_complement,
                    address.address_neighborhood,
                    address.address_city,
                    address.address_state,
                    address.address_zip_code,
                    address.address_country,
                ]
            );

            const professionalId = professionalResult.insertId;

            for (const serviceTypeName of normalizedServiceTypes) {
                await connection.query(
                    `INSERT INTO professional_service_types (professional_id, service_type_name)
                     VALUES (?, ?)
                     ON DUPLICATE KEY UPDATE service_type_name = VALUES(service_type_name)`,
                    [professionalId, serviceTypeName]
                );
            }

            for (const item of normalizedEducationItems) {
                await connection.query(
                    `INSERT INTO professional_education_items (professional_id, education_type, course_name)
                     VALUES (?, ?, ?)`,
                    [professionalId, item.education_type, item.course_name]
                );
            }

            await connection.query(
                `INSERT INTO user_addresses (user_id, label, zip_code, state, city, neighborhood, street, number, complement, country, is_primary)
                 VALUES (?, 'Principal', ?, ?, ?, ?, ?, ?, ?, ?, TRUE)`,
                [
                    userId,
                    address.address_zip_code,
                    address.address_state,
                    address.address_city,
                    address.address_neighborhood,
                    address.address_street,
                    address.address_number,
                    address.address_complement,
                    address.address_country || 'Brasil',
                ]
            );

            const acceptedTerms =
                data.accepted_terms === true ||
                data.acceptedTerms === true ||
                professional_data.accepted_terms === true ||
                professional_data.acceptedTerms === true;

            if (acceptedTerms) {
                await connection.query(
                    `INSERT INTO terms_acceptances (user_id, terms_type, terms_version, accepted_at, ip_address, user_agent)
                     VALUES (?, 'platform', ?, NOW(), NULL, NULL)`,
                    [userId, String(data.terms_version || data.termsVersion || 'v1')]
                );
            }

            await connection.commit();
            return userId;
        } catch (error) {
            await connection.rollback();
            throw error;
        } finally {
            connection.release();
        }
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

        const companyAddress = this.buildAddress(company_data);
        if (companyAddress.address_zip_code && companyAddress.address_street && companyAddress.address_number) {
            await this.insertPrimaryAddress(userId, companyAddress, 'Comercial');
        }

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

            if (profile) {
                const serviceTypes = await DatabaseService.query(
                    `SELECT id, service_type_name
                     FROM professional_service_types
                     WHERE professional_id = ?
                     ORDER BY id ASC`,
                    [profile.id]
                );

                const educationItems = await DatabaseService.query(
                    `SELECT id, education_type, course_name
                     FROM professional_education_items
                     WHERE professional_id = ?
                     ORDER BY id ASC`,
                    [profile.id]
                );

                profile.service_types = serviceTypes.map((item) => item.service_type_name);
                profile.education_items = educationItems;
            }
        } else if (user.user_type === 'company') {
            profile = await DatabaseService.queryOne(
                'SELECT * FROM companies WHERE user_id = ?',
                [userId]
            );
        }

        const addresses = await DatabaseService.query(
            'SELECT id, label, zip_code, state, city, neighborhood, street, number, complement, country, is_primary FROM user_addresses WHERE user_id = ? AND deleted_at IS NULL ORDER BY is_primary DESC, id ASC',
            [userId]
        );

        return { user, profile, addresses };
    }
}

module.exports = RegistrationService;
