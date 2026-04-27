import '../../domain/entities/bean.dart';
import '../../domain/repositories/bean_repository.dart';
import '../datasources/beans_drift_datasource.dart';
import '../models/bean_dto.dart';

class BeanRepositoryImpl implements BeanRepository {
  final BeansDriftDataSource _dataSource;

  BeanRepositoryImpl(this._dataSource);

  @override
  Future<List<Bean>> getAllBeans() async {
    final dtos = await _dataSource.getAllBeans();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Bean?> getBeanById(String id) async {
    final dto = await _dataSource.getBeanById(int.parse(id));
    return dto?.toEntity();
  }

  @override
  Future<Bean> createBean(Bean bean) async {
    final companion = BeanDto.fromEntity(bean);
    final inserted = await _dataSource.insertBean(companion);
    return inserted.toEntity();
  }

  @override
  Future<Bean> updateBean(Bean bean) async {
    final companion = BeanDto.fromEntity(bean);
    await _dataSource.updateBean(companion);
    return bean;
  }

  @override
  Future<void> deleteBean(String id) async {
    await _dataSource.deleteBean(int.parse(id));
  }

  @override
  Future<void> updateWeight(String id, double newWeight) async {
    final bean = await getBeanById(id);
    if (bean != null) {
      await updateBean(bean.copyWith(weightRemaining: newWeight));
    }
  }
}