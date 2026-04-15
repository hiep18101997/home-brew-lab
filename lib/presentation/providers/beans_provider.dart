import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/bean.dart';
import '../../domain/repositories/bean_repository.dart';

class FilePersistentBeanRepository implements BeanRepository {
  String? _filePath;
  List<Bean> _beans = [];
  bool _initialized = false;

  Future<void> _init() async {
    if (_filePath == null) {
      final dir = await getApplicationDocumentsDirectory();
      _filePath = dir.path + '/beans_data.json';
    }
  }

  Future<void> _ensureInitialized() async {
    await _init();
    if (_initialized) return;
    final file = File(_filePath!);
    if (file.existsSync()) {
      try {
        final data = jsonDecode(file.readAsStringSync());
        _beans = (data['beans'] as List).map((e) => _beanFromJson(e)).toList();
      } catch (_) { _beans = []; }
    }
    _initialized = true;
    if (_beans.isEmpty) await _loadSampleData();
  }

  Future<void> _loadSampleData() async {
    final now = DateTime.now();
    _beans = [
      Bean(id: 'bean-1', name: 'Ethiopia Yirgacheffe', roaster: 'Local Roast Co.', origin: 'Ethiopia', variety: 'Heirloom', process: 'Natural', roastLevel: 'Light', roastDate: now.subtract(Duration(days: 7)), weightRemaining: 250, weightInitial: 500, notes: 'Floral, citrus, berry notes.', createdAt: now, updatedAt: now),
      Bean(id: 'bean-2', name: 'Colombia Huila', roaster: 'Mountain Peak', origin: 'Colombia', variety: 'Caturra', process: 'Washed', roastLevel: 'Medium', roastDate: now.subtract(Duration(days: 14)), weightRemaining: 380, weightInitial: 500, notes: 'Chocolate, caramel.', createdAt: now, updatedAt: now),
      Bean(id: 'bean-3', name: 'Vietnam Robusta', roaster: 'Saigon Roasters', origin: 'Vietnam', variety: 'Robusta', process: 'Natural', roastLevel: 'Dark', roastDate: now.subtract(Duration(days: 3)), weightRemaining: 450, weightInitial: 500, notes: 'Bold, earthy.', createdAt: now, updatedAt: now),
    ];
    await _saveToFile();
  }

  Future<void> _saveToFile() async {
    await _init();
    final file = File(_filePath!);
    final data = {'beans': _beans.map((b) => _beanToJson(b)).toList()};
    await file.writeAsString(jsonEncode(data));
  }

  Map<String, dynamic> _beanToJson(Bean b) => {'id': b.id, 'name': b.name, 'roaster': b.roaster, 'origin': b.origin, 'variety': b.variety, 'process': b.process, 'roastLevel': b.roastLevel, 'roastDate': b.roastDate?.toIso8601String(), 'weightRemaining': b.weightRemaining, 'weightInitial': b.weightInitial, 'notes': b.notes, 'imageUrl': b.imageUrl, 'createdAt': b.createdAt.toIso8601String(), 'updatedAt': b.updatedAt.toIso8601String()};

  Bean _beanFromJson(Map<String, dynamic> json) => Bean(id: json['id'], name: json['name'], roaster: json['roaster'], origin: json['origin'], variety: json['variety'], process: json['process'], roastLevel: json['roastLevel'], roastDate: json['roastDate'] != null ? DateTime.parse(json['roastDate']) : null, weightRemaining: json['weightRemaining'], weightInitial: json['weightInitial'], notes: json['notes'], imageUrl: json['imageUrl'], createdAt: DateTime.parse(json['createdAt']), updatedAt: DateTime.parse(json['updatedAt']));

  @override Future<List<Bean>> getAllBeans() async { await _ensureInitialized(); return List.from(_beans); }
  @override Future<Bean?> getBeanById(String id) async { await _ensureInitialized(); try { return _beans.firstWhere((b) => b.id == id); } catch (_) { return null; } }
  @override Future<Bean> createBean(Bean bean) async { await _ensureInitialized(); _beans.add(bean); await _saveToFile(); return bean; }
  @override Future<Bean> updateBean(Bean bean) async { await _ensureInitialized(); final i = _beans.indexWhere((b) => b.id == bean.id); if (i >= 0) { _beans[i] = bean; await _saveToFile(); } return bean; }
  @override Future<void> deleteBean(String id) async { await _ensureInitialized(); _beans.removeWhere((b) => b.id == id); await _saveToFile(); }
  @override Future<void> updateWeight(String id, double w) async { await _ensureInitialized(); final i = _beans.indexWhere((b) => b.id == id); if (i >= 0) { _beans[i] = _beans[i].copyWith(weightRemaining: w); await _saveToFile(); } }
}

final beanRepositoryProvider = Provider<BeanRepository>((ref) => FilePersistentBeanRepository());

class BeansNotifier extends StateNotifier<AsyncValue<List<Bean>>> {
  final BeanRepository _repository;
  BeansNotifier(this._repository) : super(const AsyncValue.loading()) { loadBeans(); }
  Future<void> loadBeans() async { state = const AsyncValue.loading(); try { state = AsyncValue.data(await _repository.getAllBeans()); } catch (e, st) { state = AsyncValue.error(e, st); } }
  Future<void> addBean(Bean b) async { try { await _repository.createBean(b); await loadBeans(); } catch (e, st) { state = AsyncValue.error(e, st); } }
  Future<void> updateBean(Bean b) async { try { await _repository.updateBean(b); await loadBeans(); } catch (e, st) { state = AsyncValue.error(e, st); } }
  Future<void> deleteBean(String id) async { try { await _repository.deleteBean(id); await loadBeans(); } catch (e, st) { state = AsyncValue.error(e, st); } }
  Future<void> updateWeight(String id, double w) async { try { await _repository.updateWeight(id, w); await loadBeans(); } catch (e, st) { state = AsyncValue.error(e, st); } }
  Future<String> saveBeanImage(Uint8List bytes, String beanId) async { final dir = Directory((await getApplicationDocumentsDirectory()).path + '/beans'); if (!dir.existsSync()) dir.createSync(recursive: true); final file = File(dir.path + '/$beanId.png'); await file.writeAsBytes(bytes); return file.path; }
}

final beansProvider = StateNotifierProvider<BeansNotifier, AsyncValue<List<Bean>>>((ref) => BeansNotifier(ref.watch(beanRepositoryProvider)));
