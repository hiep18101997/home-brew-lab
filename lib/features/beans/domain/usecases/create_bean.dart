import '../entities/bean.dart';
import '../repositories/bean_repository.dart';

class CreateBean {
  final BeanRepository repository;

  CreateBean(this.repository);

  Future<Bean> call(Bean bean) async {
    return await repository.createBean(bean);
  }
}