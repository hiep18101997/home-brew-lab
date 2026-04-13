import '../entities/brew_log.dart';
import '../constants/brew_methods.dart';

/// Abstract repository interface for BrewLog operations
abstract class BrewRepository {
  /// Get all brew logs
  Future<List<BrewLog>> getAllBrewLogs();

  /// Get brew logs filtered by bean ID
  Future<List<BrewLog>> getBrewLogsByBeanId(String beanId);

  /// Get brew logs filtered by method
  Future<List<BrewLog>> getBrewLogsByMethod(BrewMethod method);

  /// Get a brew log by ID
  Future<BrewLog?> getBrewLogById(String id);

  /// Create a new brew log
  Future<BrewLog> createBrewLog(BrewLog log);

  /// Update an existing brew log
  Future<BrewLog> updateBrewLog(BrewLog log);

  /// Delete a brew log by ID
  Future<void> deleteBrewLog(String id);
}