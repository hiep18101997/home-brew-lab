import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/brew_log.dart';
import '../../domain/repositories/brew_repository.dart';
import '../../core/constants/brew_methods.dart';

/// File-persistent implementation of BrewRepository with sample data
class FilePersistentBrewRepository implements BrewRepository {
  final String _filePath;
  List<BrewLog> _logs = [];
  bool _initialized = false;

  FilePersistentBrewRepository(this._filePath);

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    final file = File(_filePath);
    if (file.existsSync()) {
      try {
        final data = jsonDecode(file.readAsStringSync());
        _logs = (data['logs'] as List).map((e) => _logFromJson(e)).toList();
      } catch (_) {
        _logs = [];
      }
    }
    _initialized = true;
    if (_logs.isEmpty) {
      await _loadSampleData();
    }
  }

  Future<void> _loadSampleData() async {
    final now = DateTime.now();
    _logs = [
      BrewLog(id: 'log-1', beanId: 'bean-1', method: BrewMethod.v60, dose: 15, yield_: 250, grindSize: 5, waterTemperature: 96, brewTime: const Duration(minutes: 3, seconds: 30), rating: 5, notes: 'Perfect extraction, floral notes shine', createdAt: now.subtract(const Duration(days: 1))),
      BrewLog(id: 'log-2', beanId: 'bean-2', method: BrewMethod.chemex, dose: 20, yield_: 300, grindSize: 6, waterTemperature: 94, brewTime: const Duration(minutes: 4), rating: 4, notes: 'Smooth and balanced', createdAt: now.subtract(const Duration(days: 2))),
      BrewLog(id: 'log-3', beanId: 'bean-3', method: BrewMethod.phin, dose: 25, yield_: 150, grindSize: 3, waterTemperature: 92, brewTime: const Duration(minutes: 5), rating: 4, notes: 'Strong Vietnamese style', createdAt: now.subtract(const Duration(days: 3))),
      BrewLog(id: 'log-4', beanId: 'bean-1', method: BrewMethod.aeropress, dose: 18, yield_: 200, grindSize: 4, waterTemperature: 95, brewTime: const Duration(minutes: 2, seconds: 15), rating: 5, notes: 'Clean and bright', createdAt: now.subtract(const Duration(days: 4))),
      BrewLog(id: 'log-5', beanId: 'bean-4', method: BrewMethod.v60, dose: 16, yield_: 260, grindSize: 5, waterTemperature: 93, brewTime: const Duration(minutes: 3, seconds: 45), rating: 5, notes: 'Complex fruit flavors', createdAt: now.subtract(const Duration(days: 5))),
      BrewLog(id: 'log-6', beanId: 'bean-5', method: BrewMethod.espresso, dose: 18, yield_: 36, grindSize: 7, waterTemperature: 93, brewTime: const Duration(seconds: 28), rating: 4, notes: 'Good crema, chocolate notes', createdAt: now.subtract(const Duration(days: 6))),
      BrewLog(id: 'log-7', beanId: 'bean-2', method: BrewMethod.frenchPress, dose: 30, yield_: 450, grindSize: 4, waterTemperature: 95, brewTime: const Duration(minutes: 4), rating: 3, notes: 'A bit over-extracted', createdAt: now.subtract(const Duration(days: 7))),
    ];
    await _saveToFile();
  }

  Future<void> _saveToFile() async {
    final file = File(_filePath);
    final data = {'logs': _logs.map((l) => _logToJson(l)).toList()};
    await file.writeAsString(jsonEncode(data));
  }

  Map<String, dynamic> _logToJson(BrewLog log) => {
    'id': log.id, 'beanId': log.beanId, 'method': log.method.index,
    'dose': log.dose, 'yield_': log.yield_, 'grindSize': log.grindSize,
    'waterTemperature': log.waterTemperature, 'brewTime': log.brewTime.inSeconds,
    'rating': log.rating, 'flavorTags': log.flavorTags, 'notes': log.notes,
    'tds': log.tds, 'extractionYield': log.extractionYield, 'createdAt': log.createdAt.toIso8601String(),
  };

  BrewLog _logFromJson(Map<String, dynamic> json) => BrewLog(
    id: json['id'], beanId: json['beanId'], method: BrewMethod.values[json['method']],
    dose: json['dose'].toDouble(), yield_: json['yield_'].toDouble(), grindSize: json['grindSize'],
    waterTemperature: json['waterTemperature'], brewTime: Duration(seconds: json['brewTime']),
    rating: json['rating'], flavorTags: List<String>.from(json['flavorTags'] ?? []),
    notes: json['notes'], tds: json['tds']?.toDouble(), extractionYield: json['extractionYield']?.toDouble(),
    createdAt: DateTime.parse(json['createdAt']),
  );

  @override
  Future<List<BrewLog>> getAllBrewLogs() async {
    await _ensureInitialized();
    return List.from(_logs)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<BrewLog>> getBrewLogsByBeanId(String beanId) async {
    await _ensureInitialized();
    return _logs.where((l) => l.beanId == beanId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<BrewLog>> getBrewLogsByMethod(BrewMethod method) async {
    await _ensureInitialized();
    return _logs.where((l) => l.method == method).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<BrewLog?> getBrewLogById(String id) async {
    await _ensureInitialized();
    try { return _logs.firstWhere((l) => l.id == id); } catch (_) { return null; }
  }

  @override
  Future<BrewLog> createBrewLog(BrewLog log) async {
    await _ensureInitialized();
    _logs.add(log);
    await _saveToFile();
    return log;
  }

  @override
  Future<BrewLog> updateBrewLog(BrewLog log) async {
    await _ensureInitialized();
    final index = _logs.indexWhere((l) => l.id == log.id);
    if (index >= 0) { _logs[index] = log; await _saveToFile(); }
    return log;
  }

  @override
  Future<void> deleteBrewLog(String id) async {
    await _ensureInitialized();
    _logs.removeWhere((l) => l.id == id);
    await _saveToFile();
  }
}

/// Provider for BrewRepository
final brewRepositoryProvider = Provider<BrewRepository>((ref) {
  return FilePersistentBrewRepository('brew_logs_data.json');
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
