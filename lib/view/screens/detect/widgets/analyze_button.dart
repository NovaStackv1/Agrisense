import 'package:flutter/material.dart';

import '../../../../viewmodel/detection_viewmodel.dart';
class AnalyzeButton extends StatelessWidget {
  final DetectionViewModel viewModel;

  const AnalyzeButton({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: viewModel.isAnalyzing ? null : viewModel.analyzeImage,
              icon: _buildIcon(),
              label: Text(_getButtonText()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (viewModel.isAnalyzing) ...[
            const SizedBox(height: 12),
            Text(
              'Analyzing plant health...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (viewModel.isAnalyzing) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return const Icon(Icons.biotech);
  }

  String _getButtonText() {
    return viewModel.isAnalyzing ? 'Analyzing...' : 'Analyze Plant Disease';
  }
}