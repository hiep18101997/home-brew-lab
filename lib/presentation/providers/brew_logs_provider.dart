import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/brew_log.dart';
import '../../domain/repositories/brew_repository.dart';
import '../../core/constants/brew_methods.dart';

class FilePersistentBrewRepository implements BrewRepository {
  String? _filePath;
  List<BrewLog> _logs = [];
  bool _initialized = false;

  Future<void> _init() async {
    if (_filePath == null) {
      final dir = await getApplicationDocumentsDirectory();
      _filePath = dir.path + '/brew_logs_data.json';
    }
  }

  Future<void> _ensureInitialized() async {
    await _init();
    if (_initialized) return;
    final file = File(_filePath!);
    if (file.existsSync()) {
      try {
        final data = jsonDecode(file.readAsStringSync());
        _logs = (data['logs'] as List).map((e) => _logFromJson(e)).toList();
      } catch (_) { _logs = []; }
    }
    _initialized = true;
    if (_logs.isEmpty) await _loadSampleData();
  }

  Future<void> _loadSampleData() async {
    final now = DateTime.now();
    _logs = [
      BrewLog(id: 'log-1', beanId: 'bean-1', method: BrewMethod.v60, dose: 15, yield_: 250, grindSize: 5, waterTemperature: 96, brewTime: Duration(minutes: 3, seconds: 30), rating: 5, notes: 'Perfect extraction', createdAt: now.subtract(Duration(days: 1))),
      BrewLog(id: 'log-2', beanId: 'bean-2', method: BrewMethod.chemex, dose: 20, yield_: 300, grindSize: 6, waterTemperature: 94, brewTime: Duration(minutes: 4), rating: 4, notes: 'Smooth and balanced', createdAt: now.subtract(Duration(days: 2))),
      BrewLog(id: 'log-3', beanId: 'bean-3', method: BrewMethod.phin, dose: 25, yield_: 150, grindSize: 3, waterTemperature: 92, brewTime: Duration(minutes: 5), rating: 4, notes: 'Strong Vietnamese style', createdAt: now.subtract(Duration(days: 3))),
    ];
    await _saveToFile();
  }

  Future<void> _saveToFile() async {
    await _init();
    final file = File(_filePath!);
    final data = {'logs': _logs.map((l) => _logToJson(l)).toList()};
    await file.writeAsString(jsonEncode(data));
  }

  Map<String, dynamic> _logToJson(BrewLog l) => {'id': l.id, 'beanId': l.beanId, 'method': l.method.index, 'dose': l.dose, 'yield_': l.yield_, 'grindSize': l.grindSize, 'waterTemperature': l.waterTemperature, 'brewTime': l.brewTime.inSeconds, 'rating': l.rating, 'flavorTags': l.flavorTags, 'notes': l.notes, 'tds': l.tds, 'extractionYield': l.extractionYield, 'createdAt': l.createdAt.toIso8601String()};

  BrewLog _logFromJson(Map<String, dynamic> json) => BrewLog(id: json['id'], beanId: json['beanId'], method: BrewMethod.values[json['method']], dose: json['dose'].toDouble(), yield_: json['yield_'].toDouble(), grindSize: json['grindSize'], waterTemperature: json['waterTemperature'], brewTime: Duration(seconds: json['brewTime']), rating: json['rating'], flavorTags: List<String>.from(json['flavorTags'] ?? []), notes: json['notes'], tds: json['tds']?.toDouble(), extractionYield: json['extractionYield']?.toDouble(), createdAt: DateTime.parse(json['createdAt']));

  @override Future<List<BrewLog>> getAllBrewLogs() async { await _ensureInitialized(); return List.from(_logs)..sort((a, b) => b.createdAt.compareTo(a.createdAt)); }
  @override Future<List<BrewLog>> getBrewLogsByBeanId(String id) async { await _ensureInitialized(); return _logs.where((l) => l.beanId == id).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt)); }
  @override Future<List<BrewLog>> getBrewLogsByMethod(BrewMethod m) async { await _ensureInitialized(); return _logs.where((l) => l.method == m).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt)); }
  @override Future<BrewLog?> getBrewLogById(String id) async { await _ensureInitialized(); try { return _logs.firstWhere((l) => l.id == id); } catch (_) { return null; } }
  @override Future<BrewLog> createBrewLog(BrewLog l) async { await _ensureInitialized(); _logs.add(l); await _saveToFile(); return l; }
  @override Future<BrewLog> updateBrewLog(BrewLog l) async { await _ensureInitialized(); final i = _logs.indexWhere((x) => x.id == l.id); if (i >= 0) { _logs[i] = l; await _saveToFile(); } return l; }
  @override Future<void> deleteBrewLog(String id) async { await _ensureInitialized(); _logs.removeWhere((l) => l.id == id); await _saveToFile(); }
}

final brewRepositoryProvider = Provider<BrewRepository>((ref) => FilePersistentBrewRepository());

class BrewLogsNotifier extends StateNotifier<AsyncValue<List<BrewLog>>> {
  final BrewRepository _repository;
  BrewLogsNotifier(this._repository) : super(const AsyncValue.loading()) { loadBrewLogs(); }
  Future<void> loadBrewLogs() async { state = const AsyncValue.loading(); try { state = AsyncValue.data(await _repository.getAllBrewLogs()); } catch (e, st) { state = AsyncValue.error(e, st); } }
  Future<void> addBrewLog(BrewLog l) async { try { await _repository.createBrewLog(l); await loadBrewLogs(); } catch (e, st) { state = AsyncValue.error(e, st); } }
  Future<void> deleteBrewLog(String id) async { try { await _repository.deleteBrewLog(id); await loadBrewLogs(); } catch (e, st) { state = AsyncValue.error(e, st); } }
}

final brewLogsProvider = StateNotifierProvider<BrewLogsNotifier, AsyncValue<List<BrewLog>>>((ref) => BrewLogsNotifier(ref.watch(brewRepositoryProvider)));
final brewLogsFilterProvider = StateProvider<BrewMethod?>((ref) => null);
