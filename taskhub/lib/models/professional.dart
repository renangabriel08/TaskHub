import 'package:taskhub/models/citizen.dart';

class Education {
  final String? institution;
  final String? degree;
  final String? fieldOfStudy;
  final int? startYear;
  final int? endYear;
  final String? description;

  Education({
    this.institution,
    this.degree,
    this.fieldOfStudy,
    this.startYear,
    this.endYear,
    this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      institution: json['institution'],
      degree: json['degree'],
      fieldOfStudy: json['field_of_study'],
      startYear: json['start_year'],
      endYear: json['end_year'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'start_year': startYear,
      'end_year': endYear,
      'description': description,
    };
  }
}

class Certification {
  final String? name;
  final String? issuer;
  final int? issueYear;
  final String? credentialUrl;

  Certification({this.name, this.issuer, this.issueYear, this.credentialUrl});

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'],
      issuer: json['issuer'],
      issueYear: json['issue_year'],
      credentialUrl: json['credential_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuer': issuer,
      'issue_year': issueYear,
      'credential_url': credentialUrl,
    };
  }
}

class Professional {
  final int? id;
  final int userId;
  final String documentType;
  final String documentNumber;
  final String? documentIssuerState;
  final String? professionalRegistry;
  final String serviceType;
  final String? specialties;
  final String? description;
  final int yearsExperience;
  final String? portfolioUrl;
  final List<String>? portfolioItems;
  final List<Education>? education;
  final List<Certification>? certifications;
  final double? hourlyRate;
  final String availabilityStatus;
  final Map<String, dynamic>? workingHours;
  final Address? address;
  final double? rating;
  final int? totalReviews;

  Professional({
    this.id,
    required this.userId,
    required this.documentType,
    required this.documentNumber,
    this.documentIssuerState,
    this.professionalRegistry,
    required this.serviceType,
    this.specialties,
    this.description,
    this.yearsExperience = 0,
    this.portfolioUrl,
    this.portfolioItems,
    this.education,
    this.certifications,
    this.hourlyRate,
    this.availabilityStatus = 'available',
    this.workingHours,
    this.address,
    this.rating,
    this.totalReviews,
  });

  String get availabilityLabel {
    switch (availabilityStatus) {
      case 'available':
        return 'Disponível';
      case 'unavailable':
        return 'Indisponível';
      case 'on_vacation':
        return 'Em férias';
      default:
        return availabilityStatus;
    }
  }

  String get ratingDisplay {
    if (rating == null || rating == 0) return 'Sem avaliações';
    return '${rating!.toStringAsFixed(1)} ⭐ ($totalReviews avaliações)';
  }

  factory Professional.fromJson(Map<String, dynamic> json) {
    List<Education>? educationList;
    if (json['education'] != null) {
      educationList = (json['education'] as List)
          .map((e) => Education.fromJson(e))
          .toList();
    }

    List<Certification>? certificationsList;
    if (json['certifications'] != null) {
      certificationsList = (json['certifications'] as List)
          .map((c) => Certification.fromJson(c))
          .toList();
    }

    return Professional(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      documentType: json['document_type'] ?? '',
      documentNumber: json['document_number'] ?? '',
      documentIssuerState: json['document_issuer_state'],
      professionalRegistry: json['professional_registry'],
      serviceType: json['service_type'] ?? '',
      specialties: json['specialties'],
      description: json['description'],
      yearsExperience: json['years_experience'] ?? 0,
      portfolioUrl: json['portfolio_url'],
      portfolioItems: json['portfolio_items'] != null
          ? List<String>.from(json['portfolio_items'])
          : null,
      education: educationList,
      certifications: certificationsList,
      hourlyRate: json['hourly_rate'] != null
          ? double.tryParse(json['hourly_rate'].toString())
          : null,
      availabilityStatus: json['availability_status'] ?? 'available',
      workingHours: json['working_hours'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      totalReviews: json['total_reviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'document_type': documentType,
      'document_number': documentNumber,
      'document_issuer_state': documentIssuerState,
      'professional_registry': professionalRegistry,
      'service_type': serviceType,
      'specialties': specialties,
      'description': description,
      'years_experience': yearsExperience,
      'portfolio_url': portfolioUrl,
      'portfolio_items': portfolioItems,
      'education': education?.map((e) => e.toJson()).toList(),
      'certifications': certifications?.map((c) => c.toJson()).toList(),
      'hourly_rate': hourlyRate,
      'availability_status': availabilityStatus,
      'working_hours': workingHours,
      'address': address?.toJson(),
    };
  }
}
