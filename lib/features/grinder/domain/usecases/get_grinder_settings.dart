import '../entities/grinder_profile.dart';
import '../repositories/grinder_repository.dart';

class GetGrinderSettings {
  final GrinderRepository repository;

  GetGrinderSettings(this.repository);

  Future<GrinderSettings?> call(
    GrinderBrand brand,
    String model,
    String brewMethod,
  ) async {
    return await repository.getGrinderSettings(brand, model, brewMethod);
  }
}
