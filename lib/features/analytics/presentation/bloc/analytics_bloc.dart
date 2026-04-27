import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_analytics.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalytics getAnalytics;

  AnalyticsBloc({
    required this.getAnalytics,
  }) : super(AnalyticsInitial()) {
    on<AnalyticsRequested>(_onAnalyticsRequested);
  }

  Future<void> _onAnalyticsRequested(
    AnalyticsRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final analytics = await getAnalytics();
      emit(AnalyticsSuccess(analytics));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
}
