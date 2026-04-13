/// Extraction Yield calculator based on TDS measurement.
class ExtractionCalculator {
  /// Calculate Extraction Yield percentage.
  ///
  /// [tdsBeverage] - TDS reading from refractometer (e.g., 1.35 for 1.35%)
  /// [beverageWeight] - Weight of final beverage in grams
  /// [dose] - Coffee dose in grams
  /// [waterWeight] - Total water used in grams
  static double calculateEY({
    required double tdsBeverage,
    required double beverageWeight,
    required double dose,
    required double waterWeight,
  }) {
    // Simplified EY formula: EY = (TDS * beverage) / dose
    // This is a simplified version for practical use
    final tdsDecimal = tdsBeverage / 100;
    return (tdsDecimal * beverageWeight) / dose * 100;
  }

  /// Get extraction category based on EY value.
  static ExtractionCategory categorize(double ey) {
    if (ey < 18.0) return ExtractionCategory.underExtracted;
    if (ey > 22.0) return ExtractionCategory.overExtracted;
    return ExtractionCategory.optimal;
  }
}

enum ExtractionCategory {
  underExtracted('Under Extracted', '18-22% is optimal'),
  optimal('Optimal', '18-22% is optimal'),
  overExtracted('Over Extracted', '18-22% is optimal');

  final String name;
  final String description;
  const ExtractionCategory(this.name, this.description);
}