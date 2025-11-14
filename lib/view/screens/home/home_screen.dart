import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agrisense'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              _handleMenuSelection(context, value, authService);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'settings',

                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      size: 20,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'account',
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    SizedBox(width: 8),
                    Text('Account'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 20,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    SizedBox(width: 8),
                    Text('Help & Support'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    SizedBox(width: 8),
                    Text('About'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back! 👋',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (user?.displayName != null && user!.displayName!.isNotEmpty)
                        ? user.displayName!.split(' ').first
                        : 'Farmer',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Feature cards
            Text('Features', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  context,
                  'Disease Detection',
                  Icons.bug_report,
                  'Identify crop diseases',
                  theme,
                ),
                _buildFeatureCard(
                  context,
                  'Expense Tracker',
                  Icons.attach_money,
                  'Track farm expenses',
                  theme,
                ),
                _buildFeatureCard(
                  context,
                  'Weather Insights',
                  Icons.wb_sunny,
                  'Check weather forecast',
                  theme,
                ),
                _buildFeatureCard(
                  context,
                  'Market Prices',
                  Icons.trending_up,
                  'View market trends',
                  theme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuSelection(
    BuildContext context,
    String value,
    AuthService authService,
  ) {
    switch (value) {
      case 'settings':
        // Navigate to settings screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Settings - Coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'account':
        // Navigate to account screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account - Coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'help':
        // Navigate to help screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Help & Support - Coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'about':
        // Navigate to about screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('About - Coming soon!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'logout':
        _showLogoutDialog(context, authService);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await authService.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    ThemeData theme,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title - Coming soon!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 9),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
