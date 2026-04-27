import 'package:equatable/equatable.dart';
import '../../domain/entities/grinder_profile.dart';

abstract class GrinderState extends Equatable {
  const GrinderState();

  @override
  List<Object?> get props => [];
}

class GrinderInitial extends GrinderState {}

class GrinderLoading extends GrinderState {}

class GrinderBrandsLoaded extends GrinderState {
  final List<GrinderBrand> brands;
  final GrinderBrand? selectedBrand;
  final List<GrinderProfile> grindersForBrand;
  final GrinderProfile? selectedProfile;
  final String? selectedBrewMethod;
  final GrinderSettings? currentSettings;

  const GrinderBrandsLoaded({
    required this.brands,
    this.selectedBrand,
    this.grindersForBrand = const [],
    this.selectedProfile,
    this.selectedBrewMethod,
    this.currentSettings,
  });

  GrinderBrandsLoaded copyWith({
    List<GrinderBrand>? brands,
    GrinderBrand? selectedBrand,
    List<GrinderProfile>? grindersForBrand,
    GrinderProfile? selectedProfile,
    String? selectedBrewMethod,
    GrinderSettings? currentSettings,
  }) {
    return GrinderBrandsLoaded(
      brands: brands ?? this.brands,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      grindersForBrand: grindersForBrand ?? this.grindersForBrand,
      selectedProfile: selectedProfile ?? this.selectedProfile,
      selectedBrewMethod: selectedBrewMethod ?? this.selectedBrewMethod,
      currentSettings: currentSettings ?? this.currentSettings,
    );
  }

  @override
  List<Object?> get props => [
        brands,
        selectedBrand,
        grindersForBrand,
        selectedProfile,
        selectedBrewMethod,
        currentSettings,
      ];
}

class GrinderError extends GrinderState {
  final String message;
  const GrinderError(this.message);

  @override
  List<Object?> get props => [message];
}
