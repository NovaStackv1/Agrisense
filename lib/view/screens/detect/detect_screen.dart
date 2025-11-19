import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/detection_viewmodel.dart';
import 'widgets/image_picker_section.dart';
import 'widgets/analyze_button.dart';
import 'widgets/detection_result_card.dart';
import 'widgets/error_message.dart';
import 'widgets/history_dialog.dart';


class DetectScreen extends StatelessWidget {
  const DetectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<DetectionViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Image picker section
                ImagePickerSection(viewModel: viewModel),

                const SizedBox(height: 16),

                // Analyze button
                if (viewModel.selectedImage != null && !viewModel.hasResult)
                  AnalyzeButton(viewModel: viewModel),

                // Detection results
                if (viewModel.hasResult)
                  DetectionResultCard(viewModel: viewModel),

                // Error message
                if (viewModel.errorMessage != null)
                  ErrorMessage(viewModel: viewModel),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Disease Detection'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => showHistoryDialog(context),
          tooltip: 'Detection History',
        ),
      ],
    );
  }
}