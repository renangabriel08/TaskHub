class Citizen {
    constructor({
        id,
        user_id,
        document_type,
        document_number,
        document_issuer_state,
        birth_date,
        gender,
        marital_status,
        mother_name,
        address_street,
        address_number,
        address_complement,
        address_neighborhood,
        address_city,
        address_state,
        address_zip_code,
        address_country,
        created_at,
        updated_at,
    }) {
        this.id = id;
        this.user_id = user_id;
        this.document_type = document_type;
        this.document_number = document_number;
        this.document_issuer_state = document_issuer_state;
        this.birth_date = birth_date;
        this.gender = gender;
        this.marital_status = marital_status;
        this.mother_name = mother_name;
        this.address_street = address_street;
        this.address_number = address_number;
        this.address_complement = address_complement;
        this.address_neighborhood = address_neighborhood;
        this.address_city = address_city;
        this.address_state = address_state;
        this.address_zip_code = address_zip_code;
        this.address_country = address_country;
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
     * Convert to JSON for response
     */
    toJSON() {
        return {
            id: this.id,
            user_id: this.user_id,
            document_type: this.document_type,
            document_number: this.document_number,
            document_issuer_state: this.document_issuer_state,
            birth_date: this.birth_date,
            gender: this.gender,
            marital_status: this.marital_status,
            mother_name: this.mother_name,
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
        };
    }
}

module.exports = Citizen;
