import 'package:equatable/equatable.dart';
import '../../domain/entities/bean.dart';

abstract class BeansState extends Equatable {
  const BeansState();

  @override
  List<Object?> get props => [];
}

class BeansInitial extends BeansState {}

class BeansLoading extends BeansState {}

class BeansSuccess extends BeansState {
  final List<Bean> beans;
  const BeansSuccess(this.beans);

  @override
  List<Object?> get props => [beans];
}

class BeansError extends BeansState {
  final String message;
  const BeansError(this.message);

  @override
  List<Object?> get props => [message];
}