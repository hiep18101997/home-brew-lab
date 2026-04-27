import 'package:equatable/equatable.dart';
import '../../domain/entities/analytics_data.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsSuccess extends AnalyticsState {
  final AnalyticsData analytics;

  const AnalyticsSuccess(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
