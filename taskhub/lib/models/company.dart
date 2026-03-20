import 'package:taskhub/models/citizen.dart';
import 'package:taskhub/models/professional.dart';

class Company {
  final int? id;
  final int userId;
  final String companyName;
  final String? legalName;
  final String cnpj;
  final String? registrationNumber;
  final String serviceType;
  final String? specialties;
  final String? description;
  final int? employeeCount;
  final String? portfolioUrl;
  final List<String>? portfolioItems;
  final List<Certification>? certifications;
  final String? websiteUrl;
  final int? workStartedYear;
  final Address? address;
  final Map<String, dynamic>? businessHours;
  final double? rating;
  final int? totalReviews;

  Company({
    this.id,
    required this.userId,
    required this.companyName,
    this.legalName,
    required this.cnpj,
    this.registrationNumber,
    required this.serviceType,
    this.specialties,
    this.description,
    this.employeeCount,
    this.portfolioUrl,
    this.portfolioItems,
    this.certifications,
    this.websiteUrl,
    this.workStartedYear,
    this.address,
    this.businessHours,
    this.rating,
    this.totalReviews,
  });

  int get yearsInBusiness {
    if (workStartedYear == null) return 0;
    return DateTime.now().year - workStartedYear!;
  }

  String get ratingDisplay {
    if (rating == null || rating == 0) return 'Sem avaliações';
    return '${rating!.toStringAsFixed(1)} ⭐ ($totalReviews avaliações)';
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    List<Certification>? certificationsList;
    if (json['certifications'] != null) {
      certificationsList = (json['certifications'] as List)
          .map((c) => Certification.fromJson(c))
          .toList();
    }

    return Company(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      legalName: json['legal_name'],
      cnpj: json['cnpj'] ?? '',
      registrationNumber: json['registration_number'],
      serviceType: json['service_type'] ?? '',
      specialties: json['specialties'],
      description: json['description'],
      employeeCount: json['employee_count'],
      portfolioUrl: json['portfolio_url'],
      portfolioItems: json['portfolio_items'] != null
          ? List<String>.from(json['portfolio_items'])
          : null,
      certifications: certificationsList,
      websiteUrl: json['website_url'],
      workStartedYear: json['work_started_year'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      businessHours: json['business_hours'],
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      totalReviews: json['total_reviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'company_name': companyName,
      'legal_name': legalName,
      'cnpj': cnpj,
      'registration_number': registrationNumber,
      'service_type': serviceType,
      'specialties': specialties,
      'description': description,
      'employee_count': employeeCount,
      'portfolio_url': portfolioUrl,
      'portfolio_items': portfolioItems,
      'certifications': certifications?.map((c) => c.toJson()).toList(),
      'website_url': websiteUrl,
      'work_started_year': workStartedYear,
      'address': address?.toJson(),
      'business_hours': businessHours,
    };
  }
}
