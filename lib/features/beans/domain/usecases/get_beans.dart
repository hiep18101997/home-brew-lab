import '../entities/bean.dart';
import '../repositories/bean_repository.dart';

class GetBeans {
  final BeanRepository repository;

  GetBeans(this.repository);

  Future<List<Bean>> call() async {
    return await repository.getAllBeans();
  }
}