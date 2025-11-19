import 'package:flutter/material.dart';
import '../../../../viewmodel/detection_viewmodel.dart';
import 'confidence_card.dart';
import 'info_card.dart';


class DetectionResultCard extends StatelessWidget {
  final DetectionViewModel viewModel;

  const DetectionResultCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final result = viewModel.detectionResult!;
    final disease = result.diseaseInfo;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Confidence level
          ConfidenceCard(viewModel: viewModel),

          const SizedBox(height: 16),

          // Disease information
          InfoCard(
            title: 'Disease Information',
            icon: Icons.info_outline,
            child: DiseaseInfoSection(
              diseaseName: disease.name,
              description: disease.description,
              severity: viewModel.getSeverityColor(),
            ),
          ),

          const SizedBox(height: 16),

          // Causes
          if (disease.causes.isNotEmpty)
            InfoCard(
              title: 'Possible Causes',
              icon: Icons.error_outline,
              child: BulletList(items: disease.causes),
            ),

          const SizedBox(height: 16),

          // Treatments
          if (disease.treatments.isNotEmpty)
            InfoCard(
              title: 'Recommended Treatments',
              icon: Icons.healing,
              child: BulletList(
                items: disease.treatments,
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
              ),
            ),

          const SizedBox(height: 16),

          // Medicines
          if (disease.medicines.isNotEmpty)
            InfoCard(
              title: 'Recommended Medicines',
              icon: Icons.medical_services,
              child: MedicineList(medicines: disease.medicines),
            ),

          const SizedBox(height: 16),

          // Prevention
          if (disease.preventiveMeasures.isNotEmpty)
            InfoCard(
              title: 'Prevention Tips',
              icon: Icons.shield_outlined,
              child: BulletList(
                items: disease.preventiveMeasures,
                icon: Icons.tips_and_updates,
                iconColor: Colors.amber,
              ),
            ),

          const SizedBox(height: 20),

          // Action buttons
          ActionButtons(viewModel: viewModel),
        ],
      ),
    );
  }
}

/// Disease info section
class DiseaseInfoSection extends StatelessWidget {
  final String diseaseName;
  final String description;
  final Color severity;

  const DiseaseInfoSection({
    super.key,
    required this.diseaseName,
    required this.description,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          diseaseName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: severity,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Bullet list widget
class BulletList extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final Color iconColor;

  const BulletList({
    super.key,
    required this.items,
    this.icon = Icons.circle,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: icon == Icons.circle ? 8 : 20,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(item)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Medicine list widget
class MedicineList extends StatelessWidget {
  final List medicines;

  const MedicineList({
    super.key,
    required this.medicines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: medicines.map((medicine) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medication,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      medicine.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDetail('Brand', medicine.brand, theme),
              _buildDetail('Dosage', medicine.dosage, theme),
              _buildDetail('Application', medicine.applicationMethod, theme),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetail(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action buttons widget
class ActionButtons extends StatelessWidget {
  final DetectionViewModel viewModel;

  const ActionButtons({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: viewModel.clearSelection,
            icon: const Icon(Icons.refresh),
            label: const Text('New Analysis'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/crop-planning');
            },
            icon: const Icon(Icons.agriculture),
            label: const Text('Plan Farm'),
          ),
        ),
      ],
    );
  }
}