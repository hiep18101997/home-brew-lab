import '../repositories/bean_repository.dart';

class DeleteBean {
  final BeanRepository repository;

  DeleteBean(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteBean(id);
  }
}