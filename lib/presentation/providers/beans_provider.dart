import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/beans/domain/entities/bean.dart';

/// State notifier for beans list
class BeansNotifier extends StateNotifier<AsyncValue<List<Bean>>> {
  BeansNotifier() : super(const AsyncValue.loading());

  void setBeans(List<Bean> beans) {
    state = AsyncValue.data(beans);
  }

  void updateWeight(String id, double newWeight) {
    state.whenData((beans) {
      final updatedBeans = beans.map((b) {
        if (b.id == id) {
          return b.copyWith(weightRemaining: newWeight);
        }
        return b;
      }).toList();
      state = AsyncValue.data(updatedBeans);
    });
  }

  void removeBean(String id) {
    state.whenData((beans) {
      final updatedBeans = beans.where((b) => b.id != id).toList();
      state = AsyncValue.data(updatedBeans);
    });
  }
}

final beansProvider = StateNotifierProvider<BeansNotifier, AsyncValue<List<Bean>>>((ref) {
  return BeansNotifier();
});