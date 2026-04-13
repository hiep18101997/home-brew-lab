import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../brew/domain/usecases/get_brew_logs.dart';
import '../../../brew/domain/usecases/create_brew_log.dart';
import '../../../brew/domain/usecases/delete_brew_log.dart';
import 'brew_event.dart';
import 'brew_state.dart';

class BrewBloc extends Bloc<BrewEvent, BrewState> {
  final GetBrewLogs getBrewLogs;
  final CreateBrewLog createBrewLog;
  final DeleteBrewLog deleteBrewLog;

  BrewBloc({
    required this.getBrewLogs,
    required this.createBrewLog,
    required this.deleteBrewLog,
  }) : super(BrewInitial()) {
    on<BrewLogsRequested>(_onBrewLogsRequested);
    on<BrewLogCreated>(_onBrewLogCreated);
    on<BrewLogDeleted>(_onBrewLogDeleted);
  }

  Future<void> _onBrewLogsRequested(
    BrewLogsRequested event,
    Emitter<BrewState> emit,
  ) async {
    emit(BrewLoading());
    try {
      final logs = await getBrewLogs();
      emit(BrewSuccess(logs));
    } catch (e) {
      emit(BrewError(e.toString()));
    }
  }

  Future<void> _onBrewLogCreated(
    BrewLogCreated event,
    Emitter<BrewState> emit,
  ) async {
    emit(BrewLoading());
    try {
      await createBrewLog(event.log);
      final logs = await getBrewLogs();
      emit(BrewSuccess(logs));
    } catch (e) {
      emit(BrewError(e.toString()));
    }
  }

  Future<void> _onBrewLogDeleted(
    BrewLogDeleted event,
    Emitter<BrewState> emit,
  ) async {
    emit(BrewLoading());
    try {
      await deleteBrewLog(event.id);
      final logs = await getBrewLogs();
      emit(BrewSuccess(logs));
    } catch (e) {
      emit(BrewError(e.toString()));
    }
  }
}
