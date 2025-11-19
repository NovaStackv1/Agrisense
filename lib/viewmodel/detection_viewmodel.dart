import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/services/mock_detection_service.dart';

class DetectionViewModel extends ChangeNotifier {
  final MockDetectionService _service;
  final ImagePicker _imagePicker = ImagePicker();

  // State variables
  bool _isAnalyzing = false;
  String? _errorMessage;
  File? _selectedImage;
  DetectionResult? _detectionResult;
  final List<DetectionResult> _history = [];

  // Getters
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;
  DetectionResult? get detectionResult => _detectionResult;
  bool get hasResult => _detectionResult != null;
  List<DetectionResult> get history => List.unmodifiable(_history);

  DetectionViewModel(this._service);

  // Before picking image
  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await [Permission.camera, Permission.photos].request();
    } else if (Platform.isIOS) {
      await [Permission.camera, Permission.photos].request();
    }
  }

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    await _requestPermissions();
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        _detectionResult = null;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to capture image';
      notifyListeners();
    }
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        _detectionResult = null;
        _errorMessage = null;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to select image';
      notifyListeners();
    }
  }

  /// Analyze selected image
  Future<void> analyzeImage() async {
    if (_selectedImage == null) {
      _errorMessage = 'Please select an image first';
      notifyListeners();
      return;
    }

    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call detection service (mock for now, API later)
      final result = await _service.detectDisease(_selectedImage!);

      _detectionResult = result;
      _history.insert(0, result);

      // Keep only last 20 detections
      if (_history.length > 20) {
        _history.removeLast();
      }

      _isAnalyzing = false;
      notifyListeners();
    } catch (e) {
      _isAnalyzing = false;
      _errorMessage = 'Analysis failed. Please try again.';
      notifyListeners();
    }
  }

  /// Clear current selection
  void clearSelection() {
    _selectedImage = null;
    _detectionResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear detection history
  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  /// Get confidence as percentage string
  String getConfidencePercentage() {
    if (_detectionResult == null) return '0%';
    return '${(_detectionResult!.confidence * 100).toStringAsFixed(1)}%';
  }

  /// Get color based on severity
  Color getSeverityColor() {
    if (_detectionResult == null) return Colors.grey;

    switch (_detectionResult!.diseaseInfo.severity) {
      case DiseaseSeverity.none:
        return Colors.green;
      case DiseaseSeverity.low:
        return Colors.yellow.shade700;
      case DiseaseSeverity.moderate:
        return Colors.orange;
      case DiseaseSeverity.severe:
        return Colors.red;
    }
  }

  /// Get severity icon
  IconData getSeverityIcon() {
    if (_detectionResult == null) return Icons.help_outline;

    switch (_detectionResult!.diseaseInfo.severity) {
      case DiseaseSeverity.none:
        return Icons.check_circle;
      case DiseaseSeverity.low:
        return Icons.warning_amber;
      case DiseaseSeverity.moderate:
        return Icons.error_outline;
      case DiseaseSeverity.severe:
        return Icons.dangerous;
    }
  }

  /// Format date for display
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
