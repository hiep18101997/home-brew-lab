import '../../../../domain/repositories/brew_repository.dart';

class DeleteBrewLog {
  final BrewRepository repository;

  DeleteBrewLog(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteBrewLog(id);
  }
}
