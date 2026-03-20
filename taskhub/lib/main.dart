import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'providers/providers.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/home_screen.dart';
import 'screens/registration/register_type_selection_screen.dart';
import 'screens/registration/register_client_screen.dart';
import 'screens/registration/register_professional_screen.dart';
import 'screens/registration/register_company_screen.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide system UI (status bar and navigation bar)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // Initialize services
  final localStorageService = LocalStorageService();
  await localStorageService.init();

  runApp(
    MultiProvider(
      providers: [
        // App State
        ChangeNotifierProvider(create: (_) => AppProvider()),

        // Auth State
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Services
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => localStorageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const _AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterTypeSelectionScreen(),
        '/register/client': (context) => const RegisterClientScreen(),
        '/register/professional': (context) =>
            const RegisterProfessionalScreen(),
        '/register/company': (context) => const RegisterCompanyScreen(),
      },
    );
  }
}

class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
