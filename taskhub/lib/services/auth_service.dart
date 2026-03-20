import 'dart:convert';
import 'package:taskhub/services/api_client.dart';
import 'package:taskhub/models/user.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final User? user;
  final String? accessToken;
  final String? refreshToken;
  final String? error;

  AuthResponse({
    required this.success,
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.error,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      user: json['data'] != null && json['data']['user'] != null
          ? User.fromJson(json['data']['user'])
          : null,
      accessToken: json['data'] != null ? json['data']['accessToken'] : null,
      refreshToken: json['data'] != null ? json['data']['refreshToken'] : null,
      error: json['error'],
    );
  }
}

class AuthService {
  static Future<AuthResponse> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await ApiClient.post('/auth/register', {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      });

      final data = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(data);

      if (authResponse.success && authResponse.accessToken != null) {
        ApiClient.setTokens(
          authResponse.accessToken!,
          authResponse.refreshToken ?? '',
        );
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        success: false,
        error: 'Erro ao conectar ao servidor: $e',
      );
    }
  }

  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body);
      final authResponse = AuthResponse.fromJson(data);

      if (authResponse.success && authResponse.accessToken != null) {
        ApiClient.setTokens(
          authResponse.accessToken!,
          authResponse.refreshToken ?? '',
        );
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        success: false,
        error: 'Erro ao conectar ao servidor: $e',
      );
    }
  }

  static Future<AuthResponse> logout(String refreshToken) async {
    try {
      final response = await ApiClient.post('/auth/logout', {
        'refreshToken': refreshToken,
      });

      ApiClient.clearTokens();

      final data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } catch (e) {
      ApiClient.clearTokens();
      return AuthResponse(success: false, error: 'Erro ao fazer logout: $e');
    }
  }

  static Future<AuthResponse> refreshToken(String token) async {
    try {
      final response = await ApiClient.post('/auth/refresh', {
        'refreshToken': token,
      });

      final data = jsonDecode(response.body);

      if (data['success'] && data['data'] != null) {
        ApiClient.setTokens(data['data']['accessToken'], token);
      }

      return AuthResponse.fromJson(data);
    } catch (e) {
      return AuthResponse(success: false, error: 'Erro ao renovar token: $e');
    }
  }

  static Future<AuthResponse> getProfile() async {
    try {
      final response = await ApiClient.get('/auth/profile');
      final data = jsonDecode(response.body);

      if (response.statusCode == 401) {
        ApiClient.clearTokens();
      }

      return AuthResponse.fromJson(data);
    } catch (e) {
      return AuthResponse(success: false, error: 'Erro ao obter perfil: $e');
    }
  }
}
