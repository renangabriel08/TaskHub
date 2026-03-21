import 'dart:convert';
import 'package:taskhub/models/models.dart';
import 'package:taskhub/services/api_client.dart';

class RegistrationResponse {
  final bool success;
  final String? message;
  final User? user;
  final String? accessToken;
  final String? refreshToken;
  final String? error;

  RegistrationResponse({
    required this.success,
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.error,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    User? user;
    if (json['data'] != null && json['data']['user'] != null) {
      user = User.fromJson(json['data']['user']);
    }

    return RegistrationResponse(
      success: json['success'] ?? false,
      message: json['message'],
      user: user,
      accessToken: json['data'] != null ? json['data']['accessToken'] : null,
      refreshToken: json['data'] != null ? json['data']['refreshToken'] : null,
      error: json['error'],
    );
  }
}

class RegistrationService {
  /// Registrar um novo Cidadão
  static Future<RegistrationResponse> registerCitizen({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required Citizen citizenData,
  }) async {
    try {
      final response = await ApiClient.post('/registration/citizen', {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'citizen_data': {
          'document_type': citizenData.documentType,
          'document_number': citizenData.documentNumber,
          'document_issuer_state': citizenData.documentIssuerState,
          'birth_date': citizenData.birthDate?.toIso8601String(),
          'gender': citizenData.gender,
          'marital_status': citizenData.maritalStatus,
          'mother_name': citizenData.motherName,
          'phone': '',
          'address_street': citizenData.address?.street,
          'address_number': citizenData.address?.number,
          'address_complement': citizenData.address?.complement,
          'address_neighborhood': citizenData.address?.neighborhood,
          'address_city': citizenData.address?.city,
          'address_state': citizenData.address?.state,
          'address_zip_code': citizenData.address?.zipCode,
        },
      });

      final data = jsonDecode(response.body);
      final regResponse = RegistrationResponse.fromJson(data);

      if (regResponse.success && regResponse.accessToken != null) {
        ApiClient.setTokens(
          regResponse.accessToken!,
          regResponse.refreshToken ?? '',
        );
      }

      return regResponse;
    } catch (e) {
      return RegistrationResponse(
        success: false,
        error: 'Erro ao conectar ao servidor: $e',
      );
    }
  }

  /// Registrar um novo Profissional Autônomo
  static Future<RegistrationResponse> registerProfessional({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required Professional professionalData,
  }) async {
    try {
      final response = await ApiClient.post('/registration/professional', {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'professional_data': {
          'document_type': professionalData.documentType,
          'document_number': professionalData.documentNumber,
          'document_issuer_state': professionalData.documentIssuerState,
          'professional_registry': professionalData.professionalRegistry,
          'service_type': professionalData.serviceType,
          'specialties': professionalData.specialties,
          'description': professionalData.description,
          'years_experience': professionalData.yearsExperience,
          'level': professionalData.level,
          'portfolio_url': professionalData.portfolioUrl,
          'portfolio_items': professionalData.portfolioItems,
          'education': professionalData.education
              ?.map((e) => e.toJson())
              .toList(),
          'certifications': professionalData.certifications
              ?.map((c) => c.toJson())
              .toList(),
          'hourly_rate': professionalData.hourlyRate,
          'phone': '',
          'address_street': professionalData.address?.street,
          'address_number': professionalData.address?.number,
          'address_complement': professionalData.address?.complement,
          'address_neighborhood': professionalData.address?.neighborhood,
          'address_city': professionalData.address?.city,
          'address_state': professionalData.address?.state,
          'address_zip_code': professionalData.address?.zipCode,
        },
      });

      final data = jsonDecode(response.body);
      final regResponse = RegistrationResponse.fromJson(data);

      if (regResponse.success && regResponse.accessToken != null) {
        ApiClient.setTokens(
          regResponse.accessToken!,
          regResponse.refreshToken ?? '',
        );
      }

      return regResponse;
    } catch (e) {
      return RegistrationResponse(
        success: false,
        error: 'Erro ao conectar ao servidor: $e',
      );
    }
  }

  /// Registrar uma nova Empresa
  static Future<RegistrationResponse> registerCompany({
    required String email,
    required String password,
    required Company companyData,
  }) async {
    try {
      final response = await ApiClient.post('/registration/company', {
        'email': email,
        'password': password,
        'company_data': {
          'company_name': companyData.companyName,
          'legal_name': companyData.legalName,
          'cnpj': companyData.cnpj,
          'registration_number': companyData.registrationNumber,
          'service_type': companyData.serviceType,
          'specialties': companyData.specialties,
          'description': companyData.description,
          'employee_count': companyData.employeeCount,
          'portfolio_url': companyData.portfolioUrl,
          'portfolio_items': companyData.portfolioItems,
          'certifications': companyData.certifications
              ?.map((c) => c.toJson())
              .toList(),
          'website_url': companyData.websiteUrl,
          'work_started_year': companyData.workStartedYear,
          'phone': '',
          'address_street': companyData.address?.street,
          'address_number': companyData.address?.number,
          'address_complement': companyData.address?.complement,
          'address_neighborhood': companyData.address?.neighborhood,
          'address_city': companyData.address?.city,
          'address_state': companyData.address?.state,
          'address_zip_code': companyData.address?.zipCode,
        },
      });

      final data = jsonDecode(response.body);
      final regResponse = RegistrationResponse.fromJson(data);

      if (regResponse.success && regResponse.accessToken != null) {
        ApiClient.setTokens(
          regResponse.accessToken!,
          regResponse.refreshToken ?? '',
        );
      }

      return regResponse;
    } catch (e) {
      return RegistrationResponse(
        success: false,
        error: 'Erro ao conectar ao servidor: $e',
      );
    }
  }
}
