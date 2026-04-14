import '../../core/constants/brew_methods.dart';

class GrinderSettings {
  final String grindSize; // e.g., "8-10 clicks", "12-14", "U:8"
  final double dose;
  final double yield_;
  final String brewTime; // e.g., "2:30-3:00"
  final String notes;

  const GrinderSettings({
    required this.grindSize,
    required this.dose,
    required this.yield_,
    required this.brewTime,
    this.notes = '',
  });
}

class GrinderProfile {
  final String brand;
  final String model;
  final String country; // "Taiwan", "USA", "China"
  final Map<BrewMethod, GrinderSettings> settings;

  const GrinderProfile({
    required this.brand,
    required this.model,
    required this.country,
    required this.settings,
  });

  String get displayName => '$brand $model';
}

enum GrinderBrand {
  // Taiwan/International
  oneZpresso('1Zpresso', 'Taiwan'),
  comandante('Commandante', 'Germany'),
  baratza('Baratza', 'USA'),
  hario('Hario', 'Japan'),

  // Chinese
  timemore('Timemore', 'China'),
  helge('HELGE', 'China'),
  ssure('SSURE', 'China'),
  wizard('巫师', 'China'),
  xiaomi('Xiaomi', 'China'),
  cafelat('CAFELATTI', 'China');

  final String displayName;
  final String country;

  const GrinderBrand(this.displayName, this.country);
}
