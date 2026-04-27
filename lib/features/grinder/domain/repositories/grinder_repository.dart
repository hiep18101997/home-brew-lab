import '../entities/grinder_profile.dart';

abstract class GrinderRepository {
  Future<List<GrinderProfile>> getAllGrinders();
  Future<List<GrinderProfile>> getGrindersByBrand(GrinderBrand brand);
  Future<GrinderSettings?> getGrinderSettings(
    GrinderBrand brand,
    String model,
    String brewMethod,
  );
}
