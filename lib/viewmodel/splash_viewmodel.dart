import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';

class SplashViewModel extends ChangeNotifier {
  final AuthService _authService;
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  SplashViewModel(this._authService);

  Future<String> initializeApp() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (_authService.isLoggedIn) {
        _isLoading = false;
        notifyListeners();
        return '/navigation'; 
      } else {
        _isLoading = false;
        notifyListeners();
        return '/login'; 
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return '/login';
    }
  }

  
}