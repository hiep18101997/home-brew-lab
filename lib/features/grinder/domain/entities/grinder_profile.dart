import 'package:equatable/equatable.dart';

class GrinderSettings extends Equatable {
  final String grindSize;
  final double dose;
  final double yield_;
  final String brewTime;
  final String notes;

  const GrinderSettings({
    required this.grindSize,
    required this.dose,
    required this.yield_,
    required this.brewTime,
    this.notes = '',
  });

  @override
  List<Object?> get props => [grindSize, dose, yield_, brewTime, notes];
}

class GrinderProfile extends Equatable {
  final String brand;
  final String model;
  final String country;
  final Map<String, GrinderSettings> settings;

  const GrinderProfile({
    required this.brand,
    required this.model,
    required this.country,
    required this.settings,
  });

  String get displayName => '$brand $model';

  @override
  List<Object?> get props => [brand, model, country, settings];
}

enum GrinderBrand {
  oneZpresso('1Zpresso', 'Taiwan'),
  comandante('Commandante', 'Germany'),
  baratza('Baratza', 'USA'),
  hario('Hario', 'Japan'),
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
