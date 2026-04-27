import 'package:equatable/equatable.dart';

/// Base failure class for domain layer errors
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server-side failure (database, network, etc.)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code});
}