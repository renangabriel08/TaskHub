class Company {
    constructor({
        id,
        user_id,
        company_name,
        legal_name,
        cnpj,
        registration_number,
        service_type,
        specialties,
        description,
        employee_count,
        portfolio_url,
        portfolio_items,
        certifications,
        website_url,
        work_started_year,
        address_street,
        address_number,
        address_complement,
        address_neighborhood,
        address_city,
        address_state,
        address_zip_code,
        address_country,
        business_hours,
        rating,
        total_reviews,
        created_at,
        updated_at,
    }) {
        this.id = id;
        this.user_id = user_id;
        this.company_name = company_name;
        this.legal_name = legal_name;
        this.cnpj = cnpj;
        this.registration_number = registration_number;
        this.service_type = service_type;
        this.specialties = specialties;
        this.description = description;
        this.employee_count = employee_count;
        this.portfolio_url = portfolio_url;
        this.portfolio_items = typeof portfolio_items === 'string' ? JSON.parse(portfolio_items || '[]') : portfolio_items || [];
        this.certifications = typeof certifications === 'string' ? JSON.parse(certifications || '[]') : certifications || [];
        this.website_url = website_url;
        this.work_started_year = work_started_year;
        this.address_street = address_street;
        this.address_number = address_number;
        this.address_complement = address_complement;
        this.address_neighborhood = address_neighborhood;
        this.address_city = address_city;
        this.address_state = address_state;
        this.address_zip_code = address_zip_code;
        this.address_country = address_country;
        this.business_hours = typeof business_hours === 'string' ? JSON.parse(business_hours || '{}') : business_hours || {};
        this.rating = rating;
        this.total_reviews = total_reviews;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    /**
     * Get full address
     */
    getFullAddress() {
        const parts = [
            this.address_street,
            this.address_number,
            this.address_complement,
            this.address_neighborhood,
            this.address_city,
            `${this.address_state} ${this.address_zip_code}`,
            this.address_country,
        ].filter(Boolean);
        return parts.join(', ');
    }

    /**
     * Get years in business
     */
    getYearsInBusiness() {
        if (!this.work_started_year) return 0;
        return new Date().getFullYear() - this.work_started_year;
    }

    /**
     * Get rating display
     */
    getRatingDisplay() {
        if (!this.rating) return 'Sem avaliações';
        return `${this.rating.toFixed(1)} ⭐ (${this.total_reviews} avaliações)`;
    }

    /**
     * Convert to JSON for response
     */
    toJSON() {
        return {
            id: this.id,
            user_id: this.user_id,
            company_name: this.company_name,
            legal_name: this.legal_name,
            cnpj: this.cnpj,
            registration_number: this.registration_number,
            service_type: this.service_type,
            specialties: this.specialties,
            description: this.description,
            employee_count: this.employee_count,
            portfolio_url: this.portfolio_url,
            portfolio_items: this.portfolio_items,
            certifications: this.certifications,
            website_url: this.website_url,
            work_started_year: this.work_started_year,
            years_in_business: this.getYearsInBusiness(),
            address: {
                street: this.address_street,
                number: this.address_number,
                complement: this.address_complement,
                neighborhood: this.address_neighborhood,
                city: this.address_city,
                state: this.address_state,
                zip_code: this.address_zip_code,
                country: this.address_country,
            },
            business_hours: this.business_hours,
            rating: this.rating,
            total_reviews: this.total_reviews,
        };
    }
}

module.exports = Company;
