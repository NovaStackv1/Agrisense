import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Core
import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';

// ViewModels
import 'viewmodel/splash_viewmodel.dart';
import 'viewmodel/login_viewmodel.dart';

// Views
import 'view/screens/splash/splash_screen.dart';
import 'view/screens/login/login_screen.dart';
import 'view/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        
        // ViewModels
        ChangeNotifierProvider<SplashViewModel>(
          create: (context) => SplashViewModel(
            context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(
            context.read<AuthService>(),
          ),
        ),
      ],
      child: Consumer<SplashViewModel>(
        builder: (context, splashViewModel, child) {
          return MaterialApp(
            title: 'Agrisense AI',
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system, // Follows system theme
            
            // Routes
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
            },
            
            // Unknown route handler
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

