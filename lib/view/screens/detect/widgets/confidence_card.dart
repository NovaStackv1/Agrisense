import 'package:flutter/material.dart';

import '../../../../viewmodel/detection_viewmodel.dart';
class ConfidenceCard extends StatelessWidget {
  final DetectionViewModel viewModel;

  const ConfidenceCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = viewModel.getSeverityColor();

    return Card(
      color: severityColor.withValues(alpha: 0.04),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: severityColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.analytics,
                color: severityColor,
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            // Confidence text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confidence Level',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.getConfidencePercentage(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: severityColor,
                    ),
                  ),
                ],
              ),
            ),

            // Severity icon
            Icon(
              viewModel.getSeverityIcon(),
              color: severityColor,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}