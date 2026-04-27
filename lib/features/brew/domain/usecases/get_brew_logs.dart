import '../entities/brew_log.dart';
import '../repositories/brew_repository.dart';

class GetBrewLogs {
  final BrewRepository repository;

  GetBrewLogs(this.repository);

  Future<List<BrewLog>> call() async {
    return await repository.getAllBrewLogs();
  }
}