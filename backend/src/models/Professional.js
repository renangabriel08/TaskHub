class Professional {
    constructor({
        id,
        user_id,
        document_type,
        document_number,
        document_issuer_state,
        professional_registry,
        service_type,
        specialties,
        description,
        years_experience,
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
        address_country,
        rating,
        total_reviews,
        created_at,
        updated_at,
    }) {
        this.id = id;
        this.user_id = user_id;
        this.document_type = document_type;
        this.document_number = document_number;
        this.document_issuer_state = document_issuer_state;
        this.professional_registry = professional_registry;
        this.service_type = service_type;
        this.specialties = specialties;
        this.description = description;
        this.years_experience = years_experience;
        this.portfolio_url = portfolio_url;
        this.portfolio_items = typeof portfolio_items === 'string' ? JSON.parse(portfolio_items || '[]') : portfolio_items || [];
        this.education = typeof education === 'string' ? JSON.parse(education || '[]') : education || [];
        this.certifications = typeof certifications === 'string' ? JSON.parse(certifications || '[]') : certifications || [];
        this.hourly_rate = hourly_rate;
        this.availability_status = availability_status;
        this.working_hours = typeof working_hours === 'string' ? JSON.parse(working_hours || '{}') : working_hours || {};
        this.address_street = address_street;
        this.address_number = address_number;
        this.address_complement = address_complement;
        this.address_neighborhood = address_neighborhood;
        this.address_city = address_city;
        this.address_state = address_state;
        this.address_zip_code = address_zip_code;
        this.address_country = address_country;
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
     * Get availability label
     */
    getAvailabilityLabel() {
        const statuses = {
            available: 'Disponível',
            unavailable: 'Indisponível',
            on_vacation: 'Em férias',
        };
        return statuses[this.availability_status] || this.availability_status;
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
            document_type: this.document_type,
            document_number: this.document_number,
            professional_registry: this.professional_registry,
            service_type: this.service_type,
            specialties: this.specialties,
            description: this.description,
            years_experience: this.years_experience,
            portfolio_url: this.portfolio_url,
            portfolio_items: this.portfolio_items,
            education: this.education,
            certifications: this.certifications,
            hourly_rate: this.hourly_rate,
            availability_status: this.availability_status,
            working_hours: this.working_hours,
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
            rating: this.rating,
            total_reviews: this.total_reviews,
        };
    }
}

module.exports = Professional;
