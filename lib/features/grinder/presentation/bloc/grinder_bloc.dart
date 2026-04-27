import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/grinder_profile.dart';
import '../../domain/usecases/get_all_grinders.dart';
import '../../domain/usecases/get_grinders_by_brand.dart';
import '../../domain/usecases/get_grinder_settings.dart';
import 'grinder_event.dart';
import 'grinder_state.dart';

class GrinderBloc extends Bloc<GrinderEvent, GrinderState> {
  final GetAllGrinders getAllGrinders;
  final GetGrindersByBrand getGrindersByBrand;
  final GetGrinderSettings getGrinderSettings;

  GrinderBloc({
    required this.getAllGrinders,
    required this.getGrindersByBrand,
    required this.getGrinderSettings,
  }) : super(GrinderInitial()) {
    on<GrinderBrandsRequested>(_onGrinderBrandsRequested);
    on<GrinderBrandSelected>(_onGrinderBrandSelected);
    on<GrinderModelSelected>(_onGrinderModelSelected);
    on<GrinderBrewMethodSelected>(_onGrinderBrewMethodSelected);
  }

  Future<void> _onGrinderBrandsRequested(
    GrinderBrandsRequested event,
    Emitter<GrinderState> emit,
  ) async {
    emit(GrinderLoading());
    try {
      final brands = GrinderBrand.values;
      emit(GrinderBrandsLoaded(brands: brands));
    } catch (e) {
      emit(GrinderError(e.toString()));
    }
  }

  Future<void> _onGrinderBrandSelected(
    GrinderBrandSelected event,
    Emitter<GrinderState> emit,
  ) async {
    final currentState = state;
    if (currentState is GrinderBrandsLoaded) {
      emit(GrinderLoading());
      try {
        final grinders = await getGrindersByBrand(event.brand);
        emit(GrinderBrandsLoaded(
          brands: currentState.brands,
          selectedBrand: event.brand,
          grindersForBrand: grinders,
        ));
      } catch (e) {
        emit(GrinderError(e.toString()));
      }
    }
  }

  Future<void> _onGrinderModelSelected(
    GrinderModelSelected event,
    Emitter<GrinderState> emit,
  ) async {
    final currentState = state;
    if (currentState is GrinderBrandsLoaded &&
        currentState.selectedBrand != null) {
      final settings = event.profile.settings;
      final firstMethod =
          settings.isNotEmpty ? settings.keys.first : null;
      final currentSettings =
          firstMethod != null ? settings[firstMethod] : null;

      emit(currentState.copyWith(
        selectedProfile: event.profile,
        selectedBrewMethod: firstMethod,
        currentSettings: currentSettings,
      ));
    }
  }

  Future<void> _onGrinderBrewMethodSelected(
    GrinderBrewMethodSelected event,
    Emitter<GrinderState> emit,
  ) async {
    final currentState = state;
    if (currentState is GrinderBrandsLoaded &&
        currentState.selectedBrand != null &&
        currentState.selectedProfile != null) {
      final settings = currentState.selectedProfile!.settings[event.brewMethod];
      emit(currentState.copyWith(
        selectedBrewMethod: event.brewMethod,
        currentSettings: settings,
      ));
    }
  }
}
