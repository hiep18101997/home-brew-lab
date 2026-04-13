import '../../../../domain/repositories/bean_repository.dart';
import '../../../../domain/entities/bean.dart';

class GetBeans {
  final BeanRepository repository;

  GetBeans(this.repository);

  Future<List<Bean>> call() async {
    return await repository.getAllBeans();
  }
}