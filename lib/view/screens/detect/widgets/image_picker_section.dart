import 'package:flutter/material.dart';

import '../../../../viewmodel/detection_viewmodel.dart';


class ImagePickerSection extends StatelessWidget {
  final DetectionViewModel viewModel;

  const ImagePickerSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Image preview
          _buildImagePreview(size, theme),

          const SizedBox(height: 20),

          // Picker buttons
          _buildPickerButtons(theme),

          // Clear button
          if (viewModel.selectedImage != null) ...[
            const SizedBox(height: 12),
            _buildClearButton(theme),
          ],
        ],
      ),
    );
  }

  Widget _buildImagePreview(Size size, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: viewModel.selectedImage != null
          ? _buildSelectedImage()
          : _buildPlaceholder(theme),
    );
  }

  Widget _buildSelectedImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.file(
        viewModel.selectedImage!,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 80,
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 16),
        Text(
          'Take a photo of the plant',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Capture clear images of affected leaves for accurate diagnosis',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPickerButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: viewModel.isAnalyzing
                ? null
                : viewModel.pickImageFromCamera,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: viewModel.isAnalyzing
                ? null
                : viewModel.pickImageFromGallery,
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClearButton(ThemeData theme) {
    return TextButton.icon(
      onPressed: viewModel.clearSelection,
      icon: const Icon(Icons.close, size: 18),
      label: const Text('Clear Image'),
    );
  }
}