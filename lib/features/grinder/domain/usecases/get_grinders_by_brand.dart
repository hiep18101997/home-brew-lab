import '../entities/grinder_profile.dart';
import '../repositories/grinder_repository.dart';

class GetGrindersByBrand {
  final GrinderRepository repository;

  GetGrindersByBrand(this.repository);

  Future<List<GrinderProfile>> call(GrinderBrand brand) async {
    return await repository.getGrindersByBrand(brand);
  }
}
