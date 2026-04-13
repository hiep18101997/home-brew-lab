import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_beans.dart';
import '../../domain/usecases/create_bean.dart';
import '../../domain/usecases/delete_bean.dart';
import 'beans_event.dart';
import 'beans_state.dart';

class BeansBloc extends Bloc<BeansEvent, BeansState> {
  final GetBeans getBeans;
  final CreateBean createBean;
  final DeleteBean deleteBean;

  BeansBloc({
    required this.getBeans,
    required this.createBean,
    required this.deleteBean,
  }) : super(BeansInitial()) {
    on<BeansRequested>(_onBeansRequested);
    on<BeanCreated>(_onBeanCreated);
    on<BeanDeleted>(_onBeanDeleted);
  }

  Future<void> _onBeansRequested(
    BeansRequested event,
    Emitter<BeansState> emit,
  ) async {
    emit(BeansLoading());
    try {
      final beans = await getBeans();
      emit(BeansSuccess(beans));
    } catch (e) {
      emit(BeansError(e.toString()));
    }
  }

  Future<void> _onBeanCreated(
    BeanCreated event,
    Emitter<BeansState> emit,
  ) async {
    emit(BeansLoading());
    try {
      await createBean(event.bean);
      final beans = await getBeans();
      emit(BeansSuccess(beans));
    } catch (e) {
      emit(BeansError(e.toString()));
    }
  }

  Future<void> _onBeanDeleted(
    BeanDeleted event,
    Emitter<BeansState> emit,
  ) async {
    emit(BeansLoading());
    try {
      await deleteBean(event.id);
      final beans = await getBeans();
      emit(BeansSuccess(beans));
    } catch (e) {
      emit(BeansError(e.toString()));
    }
  }
}
