import '../../../../domain/repositories/brew_repository.dart';
import '../../../../domain/entities/brew_log.dart';

class CreateBrewLog {
  final BrewRepository repository;

  CreateBrewLog(this.repository);

  Future<BrewLog> call(BrewLog log) async {
    return await repository.createBrewLog(log);
  }
}
