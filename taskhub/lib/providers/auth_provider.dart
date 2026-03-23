import 'package:flutter/foundation.dart';
import 'package:taskhub/services/auth_service.dart';
import 'package:taskhub/services/registration_service.dart';
import 'package:taskhub/models/models.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _refreshToken;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get token => _token;
  String? get refreshToken => _refreshToken;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _user != null;

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      if (response.success && response.user != null) {
        _token = response.accessToken;
        _refreshToken = response.refreshToken;
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.error ?? 'Erro ao fazer login';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (response.success && response.user != null) {
        _token = response.accessToken;
        _refreshToken = response.refreshToken;
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.error ?? 'Erro ao registrar';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    if (_refreshToken != null) {
      await AuthService.logout(_refreshToken!);
    }

    _token = null;
    _refreshToken = null;
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Refresh Token
  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) return false;

    try {
      final response = await AuthService.refreshToken(_refreshToken!);

      if (response.success) {
        _token = response.accessToken;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.error ?? 'Erro ao renovar token';
        await logout();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro: ${e.toString()}';
      await logout();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Restore session
  Future<bool> restoreSession(String token, String refreshToken) async {
    _token = token;
    _refreshToken = refreshToken;

    try {
      final response = await AuthService.getProfile();
      if (response.success && response.user != null) {
        _user = response.user;
        notifyListeners();
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
      return false;
    }
  }

  // Register Citizen
  Future<bool> registerCitizen({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required Citizen citizenData,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await RegistrationService.registerCitizen(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        citizenData: citizenData,
      );

      if (response.success && response.user != null) {
        _token = response.accessToken;
        _refreshToken = response.refreshToken;
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.error ?? 'Erro ao registrar cidadão';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register Professional
  Future<bool> registerProfessional({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required Professional professionalData,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await RegistrationService.registerProfessional(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        professionalData: professionalData,
      );

      if (response.success && response.user != null) {
        _token = response.accessToken;
        _refreshToken = response.refreshToken;
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.error ?? 'Erro ao registrar profissional';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register Company
  Future<bool> registerCompany({
    required String email,
    required String password,
    required Company companyData,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await RegistrationService.registerCompany(
        email: email,
        password: password,
        companyData: companyData,
      );

      if (response.success && response.user != null) {
        _token = response.accessToken;
        _refreshToken = response.refreshToken;
        _user = response.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.error ?? 'Erro ao registrar empresa';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Set authenticated user (for post-registration)
  void setAuthenticatedUser(
    String accessToken,
    String refreshToken,
    User user,
  ) {
    _token = accessToken;
    _refreshToken = refreshToken;
    _user = user;
    _errorMessage = null;
    notifyListeners();
  }
}
