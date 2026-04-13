import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/brew_methods.dart';
import '../../../domain/entities/brew_guide.dart';

/// Timer state
class BrewTimerState {
  final BrewMethod? method;
  final BrewGuide? guide;
  final Duration elapsed;
  final int currentStepIndex;
  final Duration stepElapsed;
  final bool isRunning;
  final bool isPaused;
  final double? targetDose;
  final double? targetYield;
  final String? beanId;
  final int grindSize;
  final int waterTemperature;

  const BrewTimerState({
    this.method,
    this.guide,
    this.elapsed = Duration.zero,
    this.currentStepIndex = 0,
    this.stepElapsed = Duration.zero,
    this.isRunning = false,
    this.isPaused = false,
    this.targetDose,
    this.targetYield,
    this.beanId,
    this.grindSize = 5,
    this.waterTemperature = 96,
  });

  BrewTimerState copyWith({
    BrewMethod? method,
    BrewGuide? guide,
    Duration? elapsed,
    int? currentStepIndex,
    Duration? stepElapsed,
    bool? isRunning,
    bool? isPaused,
    double? targetDose,
    double? targetYield,
    String? beanId,
    int? grindSize,
    int? waterTemperature,
  }) {
    return BrewTimerState(
      method: method ?? this.method,
      guide: guide ?? this.guide,
      elapsed: elapsed ?? this.elapsed,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      stepElapsed: stepElapsed ?? this.stepElapsed,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      targetDose: targetDose ?? this.targetDose,
      targetYield: targetYield ?? this.targetYield,
      beanId: beanId ?? this.beanId,
      grindSize: grindSize ?? this.grindSize,
      waterTemperature: waterTemperature ?? this.waterTemperature,
    );
  }

  PourStep? get currentStep {
    if (guide == null || currentStepIndex >= guide!.steps.length) return null;
    return guide!.steps[currentStepIndex];
  }

  bool get isLastStep {
    if (guide == null) return true;
    return currentStepIndex >= guide!.steps.length - 1;
  }

  Duration get totalDuration => guide?.totalTime ?? Duration.zero;

  double get progress {
    if (totalDuration.inSeconds == 0) return 0;
    return elapsed.inSeconds / totalDuration.inSeconds;
  }
}

class BrewTimerNotifier extends StateNotifier<BrewTimerState> {
  Timer? _timer;

  BrewTimerNotifier() : super(const BrewTimerState());

  void startBrew(BrewMethod method, {double? dose, double? yield_, String? beanId, int? grindSize, int? waterTemperature}) {
    _timer?.cancel();
    final guide = BrewGuide.getGuide(method);
    state = BrewTimerState(
      method: method,
      guide: guide,
      isRunning: true,
      isPaused: false,
      targetDose: dose,
      targetYield: yield_,
      beanId: beanId,
      grindSize: grindSize ?? 5,
      waterTemperature: waterTemperature ?? 96,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused && state.isRunning) {
        final newElapsed = state.elapsed + const Duration(seconds: 1);
        final newStepElapsed = state.stepElapsed + const Duration(seconds: 1);

        // Check if we need to advance to next step
        if (state.currentStep != null && newStepElapsed >= state.currentStep!.duration) {
          if (!state.isLastStep) {
            state = state.copyWith(
              elapsed: newElapsed,
              currentStepIndex: state.currentStepIndex + 1,
              stepElapsed: Duration.zero,
            );
          } else {
            state = state.copyWith(elapsed: newElapsed, stepElapsed: newStepElapsed);
          }
        } else {
          state = state.copyWith(elapsed: newElapsed, stepElapsed: newStepElapsed);
        }
      }
    });
  }

  void pause() {
    state = state.copyWith(isPaused: true);
  }

  void resume() {
    state = state.copyWith(isPaused: false);
  }

  void stop() {
    _timer?.cancel();
    state = const BrewTimerState();
  }

  void nextStep() {
    if (!state.isLastStep) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
        stepElapsed: Duration.zero,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final brewTimerProvider = StateNotifierProvider<BrewTimerNotifier, BrewTimerState>((ref) {
  return BrewTimerNotifier();
});
