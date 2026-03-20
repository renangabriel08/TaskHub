class Address {
  final String? street;
  final String? number;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  Address({
    this.street,
    this.number,
    this.complement,
    this.neighborhood,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  String get fullAddress {
    final parts = [
      street,
      number,
      complement,
      neighborhood,
      city,
      if (state != null && zipCode != null) '$state $zipCode',
      country,
    ].where((p) => p != null && p.isNotEmpty).toList();
    return parts.join(', ');
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? json['address_street'],
      number: json['number'] ?? json['address_number'],
      complement: json['complement'] ?? json['address_complement'],
      neighborhood: json['neighborhood'] ?? json['address_neighborhood'],
      city: json['city'] ?? json['address_city'],
      state: json['state'] ?? json['address_state'],
      zipCode: json['zip_code'] ?? json['address_zip_code'],
      country: json['country'] ?? json['address_country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
    };
  }
}

class Citizen {
  final int? id;
  final int userId;
  final String documentType;
  final String documentNumber;
  final String? documentIssuerState;
  final DateTime? birthDate;
  final String? gender;
  final String? maritalStatus;
  final String? motherName;
  final Address? address;

  Citizen({
    this.id,
    required this.userId,
    required this.documentType,
    required this.documentNumber,
    this.documentIssuerState,
    this.birthDate,
    this.gender,
    this.maritalStatus,
    this.motherName,
    this.address,
  });

  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      documentType: json['document_type'] ?? '',
      documentNumber: json['document_number'] ?? '',
      documentIssuerState: json['document_issuer_state'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      gender: json['gender'],
      maritalStatus: json['marital_status'],
      motherName: json['mother_name'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'document_type': documentType,
      'document_number': documentNumber,
      'document_issuer_state': documentIssuerState,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'marital_status': maritalStatus,
      'mother_name': motherName,
      'address': address?.toJson(),
    };
  }
}
