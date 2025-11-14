import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    // Initialize app and navigate
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndNavigate();
    });
  }

  Future<void> _initializeAndNavigate() async {
    final viewModel = Provider.of<SplashViewModel>(context, listen: false);
    final route = await viewModel.initializeApp();
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      theme.colorScheme.surface,
                      theme.colorScheme.surface,
                    ]
                  : [
                      theme.colorScheme.primary.withValues(alpha:0.1),
                      theme.colorScheme.surface,
                    ],
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  
                  // Agriculture Icon/Logo
                  _buildLogo(theme, size),
                  
                  SizedBox(height: size.height * 0.04),
                  
                  // App Name
                  Text(
                    'Agrisense AI',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: size.width * 0.08,
                    ),
                  ),
                  
                  SizedBox(height: size.height * 0.015),
                  
                  // Tagline
                  Text(
                    'Empowering Smart Farming',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Loading Indicator
                  _buildLoadingIndicator(theme),
                  
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme, Size size) {
    final logoSize = size.width * 0.4;
    
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (value * 0.2),
                child: Container(
                  width: logoSize * 0.9,
                  height: logoSize * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
          // Agriculture icons
          Icon(
            Icons.eco,
            size: logoSize * 0.5,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}