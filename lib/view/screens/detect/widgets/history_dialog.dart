import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodel/detection_viewmodel.dart';

void showHistoryDialog(BuildContext context) {
  final viewModel = context.read<DetectionViewModel>();
  final history = viewModel.history;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Detection History'),
      content: history.isEmpty
          ? const EmptyHistoryView()
          : HistoryListView(
              history: history,
              viewModel: viewModel,
            ),
      actions: [
        if (history.isNotEmpty)
          TextButton(
            onPressed: () {
              viewModel.clearHistory();
              Navigator.pop(context);
            },
            child: const Text('Clear History'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

/// Empty history view
class EmptyHistoryView extends StatelessWidget {
  const EmptyHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history,
            size: 60,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No detection history yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/// History list view
class HistoryListView extends StatelessWidget {
  final List history;
  final DetectionViewModel viewModel;

  const HistoryListView({
    super.key,
    required this.history,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: history.length,
        itemBuilder: (context, index) {
          final result = history[index];
          return HistoryListItem(
            result: result,
            viewModel: viewModel,
          );
        },
      ),
    );
  }
}

/// History list item
class HistoryListItem extends StatelessWidget {
  final dynamic result;
  final DetectionViewModel viewModel;

  const HistoryListItem({
    super.key,
    required this.result,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          result.imageFile,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        result.diseaseInfo.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${(result.confidence * 100).toStringAsFixed(1)}% • ${viewModel.formatDate(result.detectedAt)}',
      ),
      trailing: Icon(
        _getSeverityIcon(result.diseaseInfo.severity),
        color: _getSeverityColor(result.diseaseInfo.severity),
      ),
    );
  }

  IconData _getSeverityIcon(severity) {
    switch (severity.toString()) {
      case 'DiseaseSeverity.none':
        return Icons.check_circle;
      case 'DiseaseSeverity.low':
        return Icons.warning_amber;
      case 'DiseaseSeverity.moderate':
        return Icons.error_outline;
      case 'DiseaseSeverity.severe':
        return Icons.dangerous;
      default:
        return Icons.help_outline;
    }
  }

  Color _getSeverityColor(severity) {
    switch (severity.toString()) {
      case 'DiseaseSeverity.none':
        return Colors.green;
      case 'DiseaseSeverity.low':
        return Colors.yellow.shade700;
      case 'DiseaseSeverity.moderate':
        return Colors.orange;
      case 'DiseaseSeverity.severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}