import '../../../../domain/repositories/brew_repository.dart';
import '../../../../domain/entities/brew_log.dart';

class GetBrewLogs {
  final BrewRepository repository;

  GetBrewLogs(this.repository);

  Future<List<BrewLog>> call() async {
    return await repository.getAllBrewLogs();
  }
}
