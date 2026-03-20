class AppConstants {
  // App Info
  static const String appName = 'TaskHub';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'http://your-api-url.com/api';
  static const String apiVersion = 'v1';
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // Image Configuration
  static const int maxImageSize = 10485760; // 10 MB in bytes
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // Durations
  static const Duration toastDuration = Duration(seconds: 3);
  static const Duration snackBarDuration = Duration(seconds: 4);
  static const Duration loadingDuration = Duration(milliseconds: 300);
  static const Duration animationDuration = Duration(milliseconds: 400);

  // Network Status Messages
  static const String noInternetMessage = 'Sem conexão com a internet';
  static const String serverErrorMessage =
      'Erro no servidor. Tente novamente mais tarde';
  static const String timeoutMessage = 'Tempo limite de conexão excedido';
  static const String defaultErrorMessage = 'Algo deu errado. Tente novamente';

  // Success Messages
  static const String successMessage = 'Operação realizada com sucesso!';
  static const String deleteConfirmMessage = 'Tem certeza que deseja deletar?';

  // Service Types (Examples)
  static const List<String> serviceTypes = [
    'Encanamento',
    'Eletricista',
    'Carpintaria',
    'Pintura',
    'Limpeza',
    'Jardinagem',
    'Mecânica',
  ];

  // User Types
  static const String userTypeCustomer = 'customer';
  static const String userTypeProvider = 'provider';
  static const String userTypeCompany = 'company';

  // Quote Status
  static const String quoteStatusPending = 'pending';
  static const String quoteStatusAccepted = 'accepted';
  static const String quoteStatusRejected = 'rejected';
  static const String quoteStatusNegotiating = 'negotiating';

  // Order Status
  static const String orderStatusOpen = 'open';
  static const String orderStatusAccepted = 'accepted';
  static const String orderStatusInProgress = 'in_progress';
  static const String orderStatusCompleted = 'completed';
  static const String orderStatusCancelled = 'cancelled';
}
