import 'package:equatable/equatable.dart';
import '../../domain/entities/brew_log.dart';

abstract class BrewEvent extends Equatable {
  const BrewEvent();

  @override
  List<Object?> get props => [];
}

class BrewLogsRequested extends BrewEvent {}

class BrewLogCreated extends BrewEvent {
  final BrewLog log;
  const BrewLogCreated(this.log);

  @override
  List<Object?> get props => [log];
}

class BrewLogDeleted extends BrewEvent {
  final String id;
  const BrewLogDeleted(this.id);

  @override
  List<Object?> get props => [id];
}