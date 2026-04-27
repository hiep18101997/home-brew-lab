import '../entities/grinder_profile.dart';
import '../repositories/grinder_repository.dart';

class GetAllGrinders {
  final GrinderRepository repository;

  GetAllGrinders(this.repository);

  Future<List<GrinderProfile>> call() async {
    return await repository.getAllGrinders();
  }
}
