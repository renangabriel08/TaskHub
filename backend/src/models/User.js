class User {
    constructor({
        id,
        email,
        password,
        user_type,
        first_name,
        last_name,
        avatar_url,
        phone,
        is_active,
        created_at,
        updated_at,
    }) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.user_type = user_type; // 'citizen', 'professional', 'company'
        this.first_name = first_name;
        this.last_name = last_name;
        this.avatar_url = avatar_url;
        this.phone = phone;
        this.is_active = is_active;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    /**
     * Get full name
     */
    getFullName() {
        return `${this.first_name || ''} ${this.last_name || ''}`.trim();
    }

    /**
     * Convert to JSON for response
     */
    toJSON() {
        const { password, ...user } = this;
        return user;
    }

    /**
     * Get user type label
     */
    getTypeLabel() {
        const types = {
            citizen: 'Cidadão',
            professional: 'Profissional Autônomo',
            company: 'Empresa Prestadora',
        };
        return types[this.user_type] || this.user_type;
    }
}

module.exports = User;
