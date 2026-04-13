import '../repositories/bean_repository.dart';
import '../../domain/entities/bean.dart';

class CreateBean {
  final BeanRepository repository;

  CreateBean(this.repository);

  Future<Bean> call(Bean bean) async {
    return await repository.createBean(bean);
  }
}