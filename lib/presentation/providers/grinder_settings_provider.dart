import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/grinder_profile.dart';
import '../../core/constants/brew_methods.dart';
import '../../data/grinder_settings_repository.dart';

class GrinderSettingsState {
  final GrinderBrand? selectedBrand;
  final String? selectedModel;
  final BrewMethod selectedMethod;
  final GrinderSettings? currentSettings;

  const GrinderSettingsState({
    this.selectedBrand,
    this.selectedModel,
    this.selectedMethod = BrewMethod.v60,
    this.currentSettings,
  });

  GrinderSettingsState copyWith({
    GrinderBrand? selectedBrand,
    String? selectedModel,
    BrewMethod? selectedMethod,
    GrinderSettings? currentSettings,
  }) {
    return GrinderSettingsState(
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      currentSettings: currentSettings ?? this.currentSettings,
    );
  }
}

class GrinderSettingsNotifier extends StateNotifier<GrinderSettingsState> {
  GrinderSettingsNotifier() : super(const GrinderSettingsState());

  void selectBrand(GrinderBrand brand) {
    final models = GrinderSettingsRepository.getByBrand(brand);
    final firstModel = models.isNotEmpty ? models.first.model : null;
    final settings = firstModel != null
        ? GrinderSettingsRepository.getSettings(brand, firstModel, state.selectedMethod)
        : null;

    state = state.copyWith(
      selectedBrand: brand,
      selectedModel: firstModel,
      currentSettings: settings,
    );
  }

  void selectModel(String model) {
    if (state.selectedBrand == null) return;
    final settings = GrinderSettingsRepository.getSettings(
      state.selectedBrand!,
      model,
      state.selectedMethod,
    );
    state = state.copyWith(
      selectedModel: model,
      currentSettings: settings,
    );
  }

  void selectMethod(BrewMethod method) {
    GrinderSettings? settings;
    if (state.selectedBrand != null && state.selectedModel != null) {
      settings = GrinderSettingsRepository.getSettings(
        state.selectedBrand!,
        state.selectedModel!,
        method,
      );
    }
    state = state.copyWith(
      selectedMethod: method,
      currentSettings: settings,
    );
  }

  List<GrinderProfile> getModelsForBrand(GrinderBrand brand) {
    return GrinderSettingsRepository.getByBrand(brand);
  }

  List<GrinderBrand> getAllBrands() {
    return GrinderBrand.values;
  }

  List<GrinderSettings> getAllSettingsForSelection() {
    if (state.selectedBrand == null || state.selectedModel == null) {
      return [];
    }
    final profiles = GrinderSettingsRepository.getByBrand(state.selectedBrand!);
    final profile = profiles.where((p) => p.model == state.selectedModel).firstOrNull;
    if (profile == null) return [];
    return profile.settings.values.toList();
  }
}

final grinderSettingsProvider =
    StateNotifierProvider<GrinderSettingsNotifier, GrinderSettingsState>((ref) {
  return GrinderSettingsNotifier();
});
