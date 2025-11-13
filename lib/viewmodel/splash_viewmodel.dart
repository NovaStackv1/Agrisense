import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';

class SplashViewModel extends ChangeNotifier {
  final AuthService _authService;
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  SplashViewModel(this._authService);

  // Initialize and check authentication status
  Future<String> initializeApp() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate a splash delay for smooth UX (minimum 2 seconds)
      await Future.delayed(const Duration(seconds: 2));

      // Check if user is already logged in
      if (_authService.isLoggedIn) {
        _isLoading = false;
        notifyListeners();
        return '/home'; // Navigate to home if logged in
      } else {
        _isLoading = false;
        notifyListeners();
        return '/login'; // Navigate to login if not logged in
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return '/login'; // Default to login on error
    }
  }

  // Optional: Check for app updates or download required data
  Future<void> checkForUpdates() async {
    // Implementation for checking app updates
    // This could involve calling an API to check version
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Optional: Load cached data
  Future<void> loadCachedData() async {
    // Implementation for loading cached user data
    await Future.delayed(const Duration(milliseconds: 300));
  }
}