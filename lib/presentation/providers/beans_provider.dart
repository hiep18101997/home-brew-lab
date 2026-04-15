import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/bean.dart';
import '../../domain/repositories/bean_repository.dart';

/// File-persistent implementation of BeanRepository with sample data
class FilePersistentBeanRepository implements BeanRepository {
  final String _filePath;
  List<Bean> _beans = [];
  bool _initialized = false;

  FilePersistentBeanRepository(this._filePath);

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    final file = File(_filePath);
    if (file.existsSync()) {
      try {
        final data = jsonDecode(file.readAsStringSync());
        _beans = (data['beans'] as List).map((e) => _beanFromJson(e)).toList();
      } catch (_) {
        _beans = [];
      }
    }
    _initialized = true;
    if (_beans.isEmpty) {
      await _loadSampleData();
    }
  }

  Future<void> _loadSampleData() async {
    final now = DateTime.now();
    _beans = [
      Bean(id: 'bean-1', name: 'Ethiopia Yirgacheffe', roaster: 'Local Roast Co.', origin: 'Ethiopia', variety: 'Heirloom', process: 'Natural', roastLevel: 'Light', roastDate: now.subtract(const Duration(days: 7)), weightRemaining: 250, weightInitial: 500, notes: 'Floral, citrus, berry notes. Great for V60.', createdAt: now, updatedAt: now),
      Bean(id: 'bean-2', name: 'Colombia Huila', roaster: 'Mountain Peak', origin: 'Colombia', variety: 'Caturra', process: 'Washed', roastLevel: 'Medium', roastDate: now.subtract(const Duration(days: 14)), weightRemaining: 380, weightInitial: 500, notes: 'Chocolate, caramel, nutty. Versatile.', createdAt: now, updatedAt: now),
      Bean(id: 'bean-3', name: 'Vietnam Robusta', roaster: 'Saigon Roasters', origin: 'Vietnam', variety: 'Robusta', process: 'Natural', roastLevel: 'Dark', roastDate: now.subtract(const Duration(days: 3)), weightRemaining: 450, weightInitial: 500, notes: 'Bold, earthy, strong. Traditional Phin.', createdAt: now, updatedAt: now),
      Bean(id: 'bean-4', name: 'Kenya AA Nyeri', roaster: 'African Joy', origin: 'Kenya', variety: 'SL28', process: 'Washed', roastLevel: 'Medium-Light', roastDate: now.subtract(const Duration(days: 10)), weightRemaining: 200, weightInitial: 500, notes: 'Bright acidity, blackcurrant. Excellent for pour-over.', createdAt: now, updatedAt: now),
      Bean(id: 'bean-5', name: 'Guatemala Antigua', roaster: 'Central American', origin: 'Guatemala', variety: 'Bourbon', process: 'Honey', roastLevel: 'Medium', roastDate: now.subtract(const Duration(days: 5)), weightRemaining: 320, weightInitial: 500, notes: 'Smooth body, spicy, chocolate. Good for espresso.', createdAt: now, updatedAt: now),
    ];
    await _saveToFile();
  }

  Future<void> _saveToFile() async {
    final file = File(_filePath);
    final data = {'beans': _beans.map((b) => _beanToJson(b)).toList()};
    await file.writeAsString(jsonEncode(data));
  }

  Map<String, dynamic> _beanToJson(Bean bean) => {
    'id': bean.id, 'name': bean.name, 'roaster': bean.roaster, 'origin': bean.origin,
    'variety': bean.variety, 'process': bean.process, 'roastLevel': bean.roastLevel,
    'roastDate': bean.roastDate?.toIso8601String(), 'weightRemaining': bean.weightRemaining,
    'weightInitial': bean.weightInitial, 'notes': bean.notes, 'imageUrl': bean.imageUrl,
    'createdAt': bean.createdAt.toIso8601String(), 'updatedAt': bean.updatedAt.toIso8601String(),
  };

  Bean _beanFromJson(Map<String, dynamic> json) => Bean(
    id: json['id'], name: json['name'], roaster: json['roaster'], origin: json['origin'],
    variety: json['variety'], process: json['process'], roastLevel: json['roastLevel'],
    roastDate: json['roastDate'] != null ? DateTime.parse(json['roastDate']) : null,
    weightRemaining: json['weightRemaining'], weightInitial: json['weightInitial'],
    notes: json['notes'], imageUrl: json['imageUrl'],
    createdAt: DateTime.parse(json['createdAt']), updatedAt: DateTime.parse(json['updatedAt']),
  );

  @override
  Future<List<Bean>> getAllBeans() async {
    await _ensureInitialized();
    return List.from(_beans);
  }

  @override
  Future<Bean?> getBeanById(String id) async {
    await _ensureInitialized();
    try { return _beans.firstWhere((b) => b.id == id); } catch (_) { return null; }
  }

  @override
  Future<Bean> createBean(Bean bean) async {
    await _ensureInitialized();
    _beans.add(bean);
    await _saveToFile();
    return bean;
  }

  @override
  Future<Bean> updateBean(Bean bean) async {
    await _ensureInitialized();
    final index = _beans.indexWhere((b) => b.id == bean.id);
    if (index >= 0) { _beans[index] = bean; await _saveToFile(); }
    return bean;
  }

  @override
  Future<void> deleteBean(String id) async {
    await _ensureInitialized();
    _beans.removeWhere((b) => b.id == id);
    await _saveToFile();
  }

  @override
  Future<void> updateWeight(String id, double newWeight) async {
    await _ensureInitialized();
    final index = _beans.indexWhere((b) => b.id == id);
    if (index >= 0) { _beans[index] = _beans[index].copyWith(weightRemaining: newWeight); await _saveToFile(); }
  }
}

/// Provider for BeanRepository - uses app documents directory
final beanRepositoryProvider = Provider<BeanRepository>((ref) {
  return FilePersistentBeanRepository('beans_data.json');
});

/// State notifier for beans list
class BeansNotifier extends StateNotifier<AsyncValue<List<Bean>>> {
  final BeanRepository _repository;

  BeansNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadBeans();
  }

  Future<void> loadBeans() async {
    state = const AsyncValue.loading();
    try {
      final beans = await _repository.getAllBeans();
      state = AsyncValue.data(beans);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBean(Bean bean) async {
    try {
      await _repository.createBean(bean);
      await loadBeans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateBean(Bean bean) async {
    try {
      await _repository.updateBean(bean);
      await loadBeans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteBean(String id) async {
    try {
      await _repository.deleteBean(id);
      await loadBeans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateWeight(String beanId, double newWeight) async {
    try {
      await _repository.updateWeight(beanId, newWeight);
      await loadBeans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Save processed bean image to app documents directory
  Future<String> saveBeanImage(Uint8List imageBytes, String beanId) async {
    final dir = Directory('${(await getApplicationDocumentsDirectory()).path}/beans');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    final file = File('${dir.path}/$beanId.png');
    await file.writeAsBytes(imageBytes);
    return file.path;
  }
}

/// Provider for beans list state
final beansProvider = StateNotifierProvider<BeansNotifier, AsyncValue<List<Bean>>>((ref) {
  final repository = ref.watch(beanRepositoryProvider);
  return BeansNotifier(repository);
});
