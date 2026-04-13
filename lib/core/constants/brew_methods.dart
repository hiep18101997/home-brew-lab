/// Brew method enum with display names and categories
enum BrewMethod {
  v60('V60', 'Pour-over'),
  chemex('Chemex', 'Pour-over'),
  espresso('Espresso', 'Espresso'),
  aeropress('AeroPress', 'AeroPress'),
  frenchPress('French Press', 'French Press'),
  phin('Phin', 'Phin');

  final String displayName;
  final String category;

  const BrewMethod(this.displayName, this.category);

  bool get isPourOver => category == 'Pour-over';
}

/// Brew method configuration
class BrewMethodConfig {
  final BrewMethod method;
  final double defaultRatio; // g coffee per liter water (display only)
  final int defaultWaterTemp; // celsius
  final Duration? recommendedBrewTime;
  final List<double>? grindSizeRange; // 1-10 scale

  const BrewMethodConfig({
    required this.method,
    required this.defaultRatio,
    required this.defaultWaterTemp,
    this.recommendedBrewTime,
    this.grindSizeRange,
  });

  static const Map<BrewMethod, BrewMethodConfig> configs = {
    BrewMethod.v60: BrewMethodConfig(
      method: BrewMethod.v60,
      defaultRatio: 60.0,
      defaultWaterTemp: 96,
      recommendedBrewTime: Duration(minutes: 3, seconds: 30),
      grindSizeRange: [4.0, 6.0],
    ),
    BrewMethod.chemex: BrewMethodConfig(
      method: BrewMethod.chemex,
      defaultRatio: 65.0,
      defaultWaterTemp: 96,
      recommendedBrewTime: Duration(minutes: 4, seconds: 30),
      grindSizeRange: [5.0, 7.0],
    ),
    BrewMethod.espresso: BrewMethodConfig(
      method: BrewMethod.espresso,
      defaultRatio: 200.0,
      defaultWaterTemp: 93,
      grindSizeRange: [1.0, 3.0],
    ),
    BrewMethod.aeropress: BrewMethodConfig(
      method: BrewMethod.aeropress,
      defaultRatio: 55.0,
      defaultWaterTemp: 85,
      recommendedBrewTime: Duration(minutes: 2),
      grindSizeRange: [3.0, 5.0],
    ),
    BrewMethod.frenchPress: BrewMethodConfig(
      method: BrewMethod.frenchPress,
      defaultRatio: 70.0,
      defaultWaterTemp: 96,
      recommendedBrewTime: Duration(minutes: 4),
      grindSizeRange: [7.0, 9.0],
    ),
    BrewMethod.phin: BrewMethodConfig(
      method: BrewMethod.phin,
      defaultRatio: 50.0,
      defaultWaterTemp: 96,
      grindSizeRange: [6.0, 8.0],
    ),
  };

  static BrewMethodConfig getConfig(BrewMethod method) {
    return configs[method]!;
  }
}