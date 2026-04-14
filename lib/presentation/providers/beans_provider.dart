import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/bean.dart';
import '../../domain/repositories/bean_repository.dart';

/// In-memory implementation of BeanRepository for MVP
class InMemoryBeanRepository implements BeanRepository {
  final List<Bean> _beans = [];

  @override
  Future<List<Bean>> getAllBeans() async {
    return List.from(_beans);
  }

  @override
  Future<Bean?> getBeanById(String id) async {
    try {
      return _beans.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Bean> createBean(Bean bean) async {
    _beans.add(bean);
    return bean;
  }

  @override
  Future<Bean> updateBean(Bean bean) async {
    final index = _beans.indexWhere((b) => b.id == bean.id);
    if (index >= 0) {
      _beans[index] = bean;
    }
    return bean;
  }

  @override
  Future<void> deleteBean(String id) async {
    _beans.removeWhere((b) => b.id == id);
  }

  @override
  Future<void> updateWeight(String id, double newWeight) async {
    final index = _beans.indexWhere((b) => b.id == id);
    if (index >= 0) {
      _beans[index] = _beans[index].copyWith(weightRemaining: newWeight);
    }
  }
}

/// Provider for BeanRepository
final beanRepositoryProvider = Provider<BeanRepository>((ref) {
  return InMemoryBeanRepository();
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
