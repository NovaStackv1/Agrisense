import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;
  StreamSubscription<User?>? _authSubscription;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isNewUser = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isNewUser => _isNewUser;

  LoginViewModel(this._authService) {
    // Listen to auth state changes
    _authSubscription = _authService.authStateChanges.listen((user) {
      // Notify listeners when auth state changes
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    _isNewUser = false;
    notifyListeners();

    try {
      final UserCredential? userCredential = await _authService.signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        // Check if this is a new user
        _isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        
        // Success - auth state listener will handle navigation
        _isLoading = false;
        notifyListeners();
      } else {
        // User cancelled the sign-in
        _isLoading = false;
        _errorMessage = 'Sign-in was cancelled';
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getUserFriendlyErrorMessage(e);
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Convert Firebase exceptions to user-friendly messages
  String _getUserFriendlyErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'The sign-in credentials are invalid.';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled. Please contact support.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'popup-closed-by-user':
        return 'Sign-in was cancelled.';
      case 'popup-blocked':
        return 'Popup was blocked. Please allow popups for this site.';
      case 'internal-error':
        return 'An internal error occurred. Please try again.';
      default:
        return 'Sign-in failed. Please try again.';
    }
  }

  // Clear error message
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Reset all state
  void resetState() {
    _isLoading = false;
    _errorMessage = null;
    _isNewUser = false;
    // Don't call notifyListeners() here to avoid rebuilding after dispose
  }

  // Check if user is already logged in
  bool get isUserLoggedIn => _authService.isLoggedIn;

  // Get current user
  User? get currentUser => _authService.currentUser;

  // Listen to auth state changes
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Check if we should navigate to home (user is logged in and not loading)
  bool get shouldNavigateToHome => isUserLoggedIn && !_isLoading;
}