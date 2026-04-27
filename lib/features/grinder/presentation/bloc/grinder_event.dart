import 'package:equatable/equatable.dart';
import '../../domain/entities/grinder_profile.dart';

abstract class GrinderEvent extends Equatable {
  const GrinderEvent();

  @override
  List<Object?> get props => [];
}

class GrinderBrandsRequested extends GrinderEvent {}

class GrinderBrandSelected extends GrinderEvent {
  final GrinderBrand brand;
  const GrinderBrandSelected(this.brand);

  @override
  List<Object?> get props => [brand];
}

class GrinderModelSelected extends GrinderEvent {
  final GrinderProfile profile;
  const GrinderModelSelected(this.profile);

  @override
  List<Object?> get props => [profile];
}

class GrinderBrewMethodSelected extends GrinderEvent {
  final String brewMethod;
  const GrinderBrewMethodSelected(this.brewMethod);

  @override
  List<Object?> get props => [brewMethod];
}
