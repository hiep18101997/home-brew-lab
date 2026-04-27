import '../entities/brew_log.dart';
import '../repositories/brew_repository.dart';

class CreateBrewLog {
  final BrewRepository repository;

  CreateBrewLog(this.repository);

  Future<BrewLog> call(BrewLog log) async {
    return await repository.createBrewLog(log);
  }
}