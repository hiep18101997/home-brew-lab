import '../entities/bean.dart';

/// Abstract repository interface for Bean operations
abstract class BeanRepository {
  /// Get all beans
  Future<List<Bean>> getAllBeans();

  /// Get a bean by ID
  Future<Bean?> getBeanById(String id);

  /// Create a new bean
  Future<Bean> createBean(Bean bean);

  /// Update an existing bean
  Future<Bean> updateBean(Bean bean);

  /// Delete a bean by ID
  Future<void> deleteBean(String id);

  /// Update bean weight (for inventory tracking)
  Future<void> updateWeight(String id, double newWeight);
}