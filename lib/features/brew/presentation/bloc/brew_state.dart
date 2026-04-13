import 'package:equatable/equatable.dart';
import '../../../../domain/entities/brew_log.dart';

abstract class BrewState extends Equatable {
  const BrewState();

  @override
  List<Object?> get props => [];
}

class BrewInitial extends BrewState {}

class BrewLoading extends BrewState {}

class BrewSuccess extends BrewState {
  final List<BrewLog> logs;
  const BrewSuccess(this.logs);

  @override
  List<Object?> get props => [logs];
}

class BrewError extends BrewState {
  final String message;
  const BrewError(this.message);

  @override
  List<Object?> get props => [message];
}
