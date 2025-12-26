import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Market Insights Card
            _buildMarketInsightsCard(theme, isDark),
            const SizedBox(height: 16),

            // Weather Insights Card
            _buildWeatherInsightsCard(theme, isDark),
            const SizedBox(height: 20),

            // Quick Stats
            Text('Quick Stats', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            _buildStatsGrid(theme),
            const SizedBox(height: 20),

            // Recent Detections
            Text('Recent Detections', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            _buildDetectionList(theme, isDark),
            const SizedBox(height: 20),

            // Recommendations
            Text('AI Recommendations', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            _buildRecommendationsCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketInsightsCard(ThemeData theme, bool isDark) {
    final marketPrimary = AppTheme.marketPrimary(isDark);
    final marketSecondary = AppTheme.marketSecondary(isDark);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            marketPrimary,
            marketSecondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: marketPrimary.withOpacity(isDark ? 0.4 : 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Market Insights 📈',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildMarketItem('🍅 Tomatoes', '+12%', Colors.greenAccent),
                const SizedBox(height: 8),
                _buildMarketItem('🌽 Corn', '+5%', Colors.greenAccent),
                const SizedBox(height: 8),
                _buildMarketItem('🥔 Potatoes', '-3%', Colors.redAccent.shade100),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.white.withOpacity(0.9), size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Best time to sell tomatoes this week!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketItem(String crop, String change, Color changeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          crop,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: changeColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            change,
            style: TextStyle(
              color: changeColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInsightsCard(ThemeData theme, bool isDark) {
    final weatherPrimary = AppTheme.weatherPrimary(isDark);
    final weatherSecondary = AppTheme.weatherSecondary(isDark);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            weatherPrimary,
            weatherSecondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: weatherPrimary.withOpacity(isDark ? 0.4 : 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Weather Insights ☀️',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildWeatherInfoBox('🌡️', '28°C', 'Temperature'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherInfoBox('💧', '65%', 'Humidity'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWeatherInfoBox('🌧️', '20%', 'Rain Chance'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('🌱', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Perfect conditions for planting today!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoBox(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard(
          theme,
          'Healthy Plants',
          '24',
          Icons.eco,
          Colors.green,
        ),
        _buildStatCard(
          theme,
          'Disease Cases',
          '3',
          Icons.bug_report,
          Colors.orange,
        ),
        _buildStatCard(
          theme,
          'Detection Accuracy',
          '92%',
          Icons.verified,
          Colors.blue,
        ),
        _buildStatCard(
          theme,
          'Weekly Scans',
          '15',
          Icons.photo_camera,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      ThemeData theme,
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionList(ThemeData theme, bool isDark) {
    final List<Map<String, String>> detections = [
      {
        'crop': 'Tomato',
        'disease': 'Early Blight',
        'confidence': '89%',
        'date': '2 hours ago',
        'status': 'warning'
      },
      {
        'crop': 'Corn',
        'disease': 'Healthy',
        'confidence': '95%',
        'date': '1 day ago',
        'status': 'healthy'
      },
      {
        'crop': 'Potato',
        'disease': 'Late Blight',
        'confidence': '78%',
        'date': '2 days ago',
        'status': 'critical'
      },
    ];

    return Column(
      children: detections.map((detection) {
        Color statusColor = Colors.green;
        IconData statusIcon = Icons.check_circle;

        if (detection['status'] == 'warning') {
          statusColor = Colors.orange;
          statusIcon = Icons.warning;
        } else if (detection['status'] == 'critical') {
          statusColor = Colors.red;
          statusIcon = Icons.error;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(statusIcon, color: statusColor, size: 20),
            ),
            title: Text(
              detection['crop']!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(detection['disease']!),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  detection['confidence']!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                Text(
                  detection['date']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendationsCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Smart Recommendations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem(
              'Apply organic fungicide to affected tomato plants',
              Icons.medical_services,
            ),
            _buildRecommendationItem(
              'Increase spacing between potato plants for better air flow',
              Icons.agriculture,
            ),
            _buildRecommendationItem(
              'Monitor soil moisture levels - consider irrigation adjustment',
              Icons.water_drop,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}