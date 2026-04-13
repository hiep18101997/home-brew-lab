import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/brew_log.dart';
import '../../../domain/constants/brew_methods.dart';

/// State notifier for brew logs
class BrewLogsNotifier extends StateNotifier<AsyncValue<List<BrewLog>>> {
  BrewLogsNotifier() : super(const AsyncValue.loading());

  void setLogs(List<BrewLog> logs) {
    state = AsyncValue.data(logs);
  }

  void addLog(BrewLog log) {
    state.whenData((logs) {
      final updatedLogs = [log, ...logs];
      state = AsyncValue.data(updatedLogs);
    });
  }

  void removeLog(String id) {
    state.whenData((logs) {
      final updatedLogs = logs.where((l) => l.id != id).toList();
      state = AsyncValue.data(updatedLogs);
    });
  }
}

final brewLogsProvider = StateNotifierProvider<BrewLogsNotifier, AsyncValue<List<BrewLog>>>((ref) {
  return BrewLogsNotifier();
});
