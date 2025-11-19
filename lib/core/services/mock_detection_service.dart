import 'dart:io';
import 'dart:math';

/// This service returns fake data to test the UI without a backend
/// Replace with real API calls later
class MockDetectionService {
  // Simulate API delay
  static const Duration _apiDelay = Duration(seconds: 2);

  /// Simulate disease detection
  /// In production, this will make an API call
  Future<DetectionResult> detectDisease(File imageFile) async {
    // Simulate network delay
    await Future.delayed(_apiDelay);

    // Randomly select a disease for demo
    final diseases = _mockDiseases.values.toList();
    final randomDisease = diseases[Random().nextInt(diseases.length)];

    // Random confidence between 75% and 95%
    final confidence = 0.75 + (Random().nextDouble() * 0.20);

    return DetectionResult(
      diseaseInfo: randomDisease,
      confidence: confidence,
      detectedAt: DateTime.now(),
      imageFile: imageFile,
    );
  }

  /// Get all crop recommendations
  /// In production, this will fetch from API
  Future<List<CropRecommendation>> getAllCropRecommendations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCrops.values.toList();
  }

  /// Get single crop recommendation
  Future<CropRecommendation?> getCropRecommendation(String cropName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCrops[cropName.toLowerCase()];
  }

  /// Check if service is available
  Future<bool> checkServiceHealth() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true; // Always healthy in mock mode
  }

  // Mock disease database
  static final Map<String, DiseaseInfo> _mockDiseases = {
    'healthy': DiseaseInfo(
      name: 'Healthy Plant',
      description: 'Your plant appears to be healthy with no signs of disease!',
      causes: [
        'Proper care and nutrition',
        'Good soil health',
        'Adequate water and sunlight',
      ],
      treatments: [
        'Continue current care routine',
        'Monitor regularly for any changes',
        'Maintain proper watering schedule',
      ],
      medicines: [],
      preventiveMeasures: [
        'Keep consistent watering',
        'Ensure proper sunlight exposure',
        'Use quality soil and fertilizer',
        'Practice good garden hygiene',
      ],
      severity: DiseaseSeverity.none,
    ),
    'early_blight': DiseaseInfo(
      name: 'Early Blight',
      description:
          'Fungal disease causing dark spots with concentric rings on leaves. Common in tomatoes and potatoes.',
      causes: [
        'Warm, humid weather conditions',
        'Overhead watering splashing soil on leaves',
        'Dense plant spacing with poor air circulation',
        'Infected plant debris in soil',
      ],
      treatments: [
        'Remove infected leaves immediately and destroy them',
        'Apply fungicide every 7-14 days',
        'Add mulch around plants to prevent soil splash',
        'Water at soil level, avoid wetting leaves',
        'Improve air circulation by proper spacing',
      ],
      medicines: [
        Medicine(
          name: 'Chlorothalonil',
          brand: 'Daconil Fungicide',
          dosage: '1-2 tablespoons per gallon of water',
          applicationMethod: 'Spray every 7-14 days, cover all leaf surfaces',
        ),
        Medicine(
          name: 'Mancozeb',
          brand: 'Dithane M-45',
          dosage: '2 tablespoons per gallon of water',
          applicationMethod: 'Apply as preventive measure every 10 days',
        ),
      ],
      preventiveMeasures: [
        'Space plants 60-90cm apart for air flow',
        'Use drip irrigation or water at base only',
        'Rotate crops annually to different areas',
        'Remove all plant debris after harvest',
        'Apply mulch to prevent soil splash',
      ],
      severity: DiseaseSeverity.moderate,
    ),
    'late_blight': DiseaseInfo(
      name: 'Late Blight',
      description:
          'Aggressive fungal disease causing rapid plant deterioration. Can destroy entire crops within days if left untreated.',
      causes: [
        'Cool, wet weather (15-20°C with high humidity)',
        'Extended periods of leaf wetness',
        'Poor drainage and air circulation',
        'Airborne spores spreading from nearby infected plants',
      ],
      treatments: [
        'Apply fungicide immediately upon detection',
        'Remove and destroy severely infected plants',
        'Improve drainage around plants',
        'Increase spacing to improve air circulation',
        'Avoid overhead watering completely',
      ],
      medicines: [
        Medicine(
          name: 'Metalaxyl + Mancozeb',
          brand: 'Ridomil Gold MZ',
          dosage: '2g per liter of water',
          applicationMethod:
              'Spray every 7-10 days, start before disease appears',
        ),
        Medicine(
          name: 'Cymoxanil + Mancozeb',
          brand: 'Curzate M8',
          dosage: '1-2g per liter of water',
          applicationMethod:
              'Apply at first sign of disease, repeat every 7 days',
        ),
      ],
      preventiveMeasures: [
        'Monitor weather forecasts for favorable conditions',
        'Use resistant varieties when available',
        'Maintain 90cm spacing between plants',
        'Water early in the day so leaves dry quickly',
        'Remove volunteer plants that may harbor disease',
      ],
      severity: DiseaseSeverity.severe,
    ),
    'leaf_spot': DiseaseInfo(
      name: 'Leaf Spot Disease',
      description:
          'Fungal or bacterial infection causing circular spots on leaves. Can be brown, black, or yellow depending on the pathogen.',
      causes: [
        'Excess moisture on leaves',
        'Water splash from irrigation or rain',
        'Poor air circulation around plants',
        'Infected plant material or soil',
      ],
      treatments: [
        'Remove affected leaves and destroy them',
        'Apply appropriate fungicide or bactericide',
        'Reduce leaf wetness duration',
        'Improve air circulation through pruning',
        'Avoid working with plants when wet',
      ],
      medicines: [
        Medicine(
          name: 'Copper Fungicide',
          brand: 'Bonide Copper Fungicide',
          dosage: '3 tablespoons per gallon of water',
          applicationMethod: 'Spray every 7-14 days, alternate with other products',
        ),
        Medicine(
          name: 'Neem Oil',
          brand: 'Organic Neem Oil Spray',
          dosage: '2 tablespoons per gallon of water',
          applicationMethod: 'Spray weekly as preventive, safe for organic gardening',
        ),
      ],
      preventiveMeasures: [
        'Water in the morning so leaves dry during the day',
        'Prune plants to improve airflow',
        'Apply mulch to prevent soil splash',
        'Sanitize tools between plants',
        'Practice crop rotation',
      ],
      severity: DiseaseSeverity.low,
    ),
    'powdery_mildew': DiseaseInfo(
      name: 'Powdery Mildew',
      description:
          'Fungal disease appearing as white powdery coating on leaves and stems. Thrives in warm, dry days with cool nights.',
      causes: [
        'High humidity with dry leaf surfaces',
        'Poor air circulation',
        'Low light conditions',
        'Overcrowded plants',
        'Temperature fluctuations',
      ],
      treatments: [
        'Spray affected areas with fungicide',
        'Increase air movement around plants',
        'Prune infected areas',
        'Improve sunlight exposure',
        'Apply treatments early in infection',
      ],
      medicines: [
        Medicine(
          name: 'Potassium Bicarbonate',
          brand: 'GreenCure Fungicide',
          dosage: '4 teaspoons per gallon of water',
          applicationMethod: 'Spray weekly until symptoms disappear',
        ),
        Medicine(
          name: 'Sulfur Fungicide',
          brand: 'Safer Brand Garden Fungicide',
          dosage: 'As per label instructions',
          applicationMethod: 'Dust or spray application every 7-10 days',
        ),
      ],
      preventiveMeasures: [
        'Ensure good air circulation (60-90cm spacing)',
        'Avoid overhead watering',
        'Plant in full sun locations',
        'Remove infected debris regularly',
        'Use resistant varieties when possible',
      ],
      severity: DiseaseSeverity.low,
    ),
    'bacterial_blight': DiseaseInfo(
      name: 'Bacterial Blight',
      description:
          'Bacterial infection causing water-soaked lesions that turn brown. Can spread rapidly in wet conditions.',
      causes: [
        'High humidity and warm temperatures',
        'Contaminated tools or hands',
        'Infected seeds or transplants',
        'Wind-driven rain spreading bacteria',
      ],
      treatments: [
        'Remove infected leaves immediately',
        'Apply copper-based bactericide',
        'Improve air circulation',
        'Avoid overhead watering',
        'Sanitize all tools after use',
      ],
      medicines: [
        Medicine(
          name: 'Copper Hydroxide',
          brand: 'Kocide 3000',
          dosage: '2-3 tablespoons per gallon of water',
          applicationMethod: 'Spray every 7-10 days during wet weather',
        ),
        Medicine(
          name: 'Streptomycin Sulfate',
          brand: 'Agri-Mycin 17',
          dosage: 'As per label instructions',
          applicationMethod: 'Spray on affected areas, repeat in 5-7 days',
        ),
      ],
      preventiveMeasures: [
        'Use disease-free seeds and transplants',
        'Practice 2-3 year crop rotation',
        'Sanitize gardening tools regularly',
        'Avoid working with wet plants',
        'Remove and destroy infected plant debris',
      ],
      severity: DiseaseSeverity.moderate,
    ),
  };

  // Mock crop database
  static final Map<String, CropRecommendation> _mockCrops = {
    'maize': CropRecommendation(
      name: 'Maize (Corn)',
      bestSeason: 'March-May (long rains), August-October (short rains)',
      soilType: 'Well-drained loamy soil, pH 5.5-7.0',
      spacing: 'Rows: 75cm, Plants: 25-30cm',
      waterRequirements: 'Moderate to high (500-800mm per season)',
      fertilizer: 'NPK 17:17:17 at planting, CAN for top-dressing',
      harvestTime: '3-4 months after planting',
      companionPlants: ['Beans', 'Squash', 'Cucumbers'],
      commonDiseases: ['Maize Streak Virus', 'Gray Leaf Spot', 'Rust'],
    ),
    'beans': CropRecommendation(
      name: 'Beans',
      bestSeason: 'March-May, September-November',
      soilType: 'Well-drained sandy loam, pH 6.0-7.5',
      spacing: 'Rows: 45-60cm, Plants: 10-15cm',
      waterRequirements: 'Moderate (350-500mm per season)',
      fertilizer: 'DAP at planting, minimal nitrogen needed',
      harvestTime: '2-3 months after planting',
      companionPlants: ['Maize', 'Carrots', 'Cucumbers'],
      commonDiseases: ['Angular Leaf Spot', 'Anthracnose', 'Root Rot'],
    ),
    'tomatoes': CropRecommendation(
      name: 'Tomatoes',
      bestSeason: 'Year-round with irrigation, best in dry season',
      soilType: 'Well-drained loamy soil, pH 6.0-6.8',
      spacing: 'Rows: 90cm, Plants: 45-60cm',
      waterRequirements: 'High (400-600mm per season)',
      fertilizer: 'NPK 17:17:17 + foliar feeds during growth',
      harvestTime: '3-4 months after transplanting',
      companionPlants: ['Basil', 'Marigold', 'Carrots'],
      commonDiseases: ['Early Blight', 'Late Blight', 'Bacterial Wilt'],
    ),
    'potatoes': CropRecommendation(
      name: 'Potatoes',
      bestSeason: 'March-May in highland areas',
      soilType: 'Well-drained loamy soil, pH 5.0-6.5',
      spacing: 'Rows: 75-90cm, Plants: 30cm',
      waterRequirements: 'Moderate (500-700mm per season)',
      fertilizer: 'NPK 17:17:17 at planting, CAN for top-dressing',
      harvestTime: '3-4 months after planting',
      companionPlants: ['Beans', 'Cabbage', 'Horseradish'],
      commonDiseases: ['Late Blight', 'Bacterial Wilt', 'Potato Virus Y'],
    ),
    'cabbages': CropRecommendation(
      name: 'Cabbages',
      bestSeason: 'Year-round with proper irrigation',
      soilType: 'Fertile loamy soil, pH 6.0-7.5',
      spacing: 'Rows: 60cm, Plants: 45cm',
      waterRequirements: 'High, consistent moisture needed',
      fertilizer: 'NPK 17:17:17 + calcium nitrate',
      harvestTime: '3-4 months after transplanting',
      companionPlants: ['Onions', 'Celery', 'Beets'],
      commonDiseases: ['Black Rot', 'Downy Mildew', 'Clubroot'],
    ),
  };
}

// Data Models
class DetectionResult {
  final DiseaseInfo diseaseInfo;
  final double confidence;
  final DateTime detectedAt;
  final File imageFile;

  DetectionResult({
    required this.diseaseInfo,
    required this.confidence,
    required this.detectedAt,
    required this.imageFile,
  });
}

class DiseaseInfo {
  final String name;
  final String description;
  final List<String> causes;
  final List<String> treatments;
  final List<Medicine> medicines;
  final List<String> preventiveMeasures;
  final DiseaseSeverity severity;

  DiseaseInfo({
    required this.name,
    required this.description,
    required this.causes,
    required this.treatments,
    required this.medicines,
    required this.preventiveMeasures,
    required this.severity,
  });
}

class Medicine {
  final String name;
  final String brand;
  final String dosage;
  final String applicationMethod;

  Medicine({
    required this.name,
    required this.brand,
    required this.dosage,
    required this.applicationMethod,
  });
}

enum DiseaseSeverity {
  none,
  low,
  moderate,
  severe,
}

class CropRecommendation {
  final String name;
  final String bestSeason;
  final String soilType;
  final String spacing;
  final String waterRequirements;
  final String fertilizer;
  final String harvestTime;
  final List<String> companionPlants;
  final List<String> commonDiseases;

  CropRecommendation({
    required this.name,
    required this.bestSeason,
    required this.soilType,
    required this.spacing,
    required this.waterRequirements,
    required this.fertilizer,
    required this.harvestTime,
    required this.companionPlants,
    required this.commonDiseases,
  });
}