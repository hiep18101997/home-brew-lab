import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/brew_log.dart';
import '../../domain/repositories/brew_repository.dart';
import '../../domain/constants/brew_methods.dart';

/// In-memory implementation of BrewRepository for MVP
class InMemoryBrewRepository implements BrewRepository {
  final List<BrewLog> _logs = [];

  @override
  Future<List<BrewLog>> getAllBrewLogs() async {
    return List.from(_logs)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<BrewLog>> getBrewLogsByBeanId(String beanId) async {
    return _logs.where((l) => l.beanId == beanId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<BrewLog>> getBrewLogsByMethod(BrewMethod method) async {
    return _logs.where((l) => l.method == method).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<BrewLog?> getBrewLogById(String id) async {
    try {
      return _logs.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BrewLog> createBrewLog(BrewLog log) async {
    _logs.add(log);
    return log;
  }

  @override
  Future<BrewLog> updateBrewLog(BrewLog log) async {
    final index = _logs.indexWhere((l) => l.id == log.id);
    if (index >= 0) {
      _logs[index] = log;
    }
    return log;
  }

  @override
  Future<void> deleteBrewLog(String id) async {
    _logs.removeWhere((l) => l.id == id);
  }
}

/// Provider for BrewRepository
final brewRepositoryProvider = Provider<BrewRepository>((ref) {
  return InMemoryBrewRepository();
});

/// State notifier for brew logs
class BrewLogsNotifier extends StateNotifier<AsyncValue<List<BrewLog>>> {
  final BrewRepository _repository;

  BrewLogsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadBrewLogs();
  }

  Future<void> loadBrewLogs() async {
    state = const AsyncValue.loading();
    try {
      final logs = await _repository.getAllBrewLogs();
      state = AsyncValue.data(logs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBrewLog(BrewLog log) async {
    try {
      await _repository.createBrewLog(log);
      await loadBrewLogs();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteBrewLog(String id) async {
    try {
      await _repository.deleteBrewLog(id);
      await loadBrewLogs();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for brew logs state
final brewLogsProvider = StateNotifierProvider<BrewLogsNotifier, AsyncValue<List<BrewLog>>>((ref) {
  final repository = ref.watch(brewRepositoryProvider);
  return BrewLogsNotifier(repository);
});

/// Filter provider for brew logs
final brewLogsFilterProvider = StateProvider<BrewMethod?>((ref) => null);
