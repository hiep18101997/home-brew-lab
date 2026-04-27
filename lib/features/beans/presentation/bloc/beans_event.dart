import 'package:equatable/equatable.dart';
import '../../domain/entities/bean.dart';

abstract class BeansEvent extends Equatable {
  const BeansEvent();

  @override
  List<Object?> get props => [];
}

class BeansRequested extends BeansEvent {}

class BeanCreated extends BeansEvent {
  final Bean bean;
  const BeanCreated(this.bean);

  @override
  List<Object?> get props => [bean];
}

class BeanDeleted extends BeansEvent {
  final String id;
  const BeanDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

// BeanUpdated - reserved for future implementation when update feature is added