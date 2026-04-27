import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../providers/brew_timer_provider.dart';
import '../../providers/beans_provider.dart';
import '../../../core/constants/brew_methods.dart';
import '../../../features/brew/domain/entities/brew_log.dart';
import '../../../features/brew/presentation/bloc/brew_bloc.dart';
import '../../../features/brew/presentation/bloc/brew_event.dart';
import '../../../features/brew/presentation/bloc/brew_state.dart';

class BrewTimerScreen extends ConsumerWidget {
  const BrewTimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(brewTimerProvider);
    final timerNotifier = ref.read(brewTimerProvider.notifier);

    return BlocListener<BrewBloc, BrewState>(
      listener: (context, state) {
        if (state is BrewSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Brew saved!')),
          );
          context.pop();
        } else if (state is BrewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${timerState.method?.displayName ?? "Brew"} Brew'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _showCancelDialog(context, timerNotifier);
            },
          ),
        ),
        body: Column(
          children: [
            // Timer display
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Main timer
                  Text(
                    _formatDuration(timerState.elapsed),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress indicator
                  if (timerState.guide != null) ...[
                    LinearProgressIndicator(
                      value: timerState.progress,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Step ${timerState.currentStepIndex + 1} of ${timerState.guide!.steps.length}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),

            // Current step card
            if (timerState.currentStep != null)
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        timerState.currentStep!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timerState.currentStep!.instruction ?? '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDuration(timerState.currentStep!.duration),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Control buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!timerState.isLastStep)
                    OutlinedButton.icon(
                      onPressed: () => timerNotifier.nextStep(),
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Next Step'),
                    ),
                  FilledButton.icon(
                    onPressed: () {
                      timerNotifier.pause();
                      _showSaveDialog(context, ref, timerState);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Finish'),
                  ),
                ],
              ),
            ),

            // Pause/Resume
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: FilledButton.tonalIcon(
                onPressed: () {
                  if (timerState.isPaused) {
                    timerNotifier.resume();
                  } else {
                    timerNotifier.pause();
                  }
                },
                icon: Icon(timerState.isPaused ? Icons.play_arrow : Icons.pause),
                label: Text(timerState.isPaused ? 'Resume' : 'Pause'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showCancelDialog(BuildContext context, BrewTimerNotifier notifier) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Brew?'),
        content: const Text('Are you sure you want to cancel this brew?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () {
              notifier.stop();
              Navigator.pop(dialogContext);
              context.pop();
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog(BuildContext context, WidgetRef ref, BrewTimerState timerState) {
    int rating = 0;
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Save Brew'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rate this brew:'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => IconButton(
                  icon: Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => rating = i + 1),
                )),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(brewTimerProvider.notifier).stop();
                Navigator.pop(dialogContext);
                context.pop();
              },
              child: const Text('Discard'),
            ),
            FilledButton(
              onPressed: () {
                // Create brew log
                final brewLog = BrewLog.create(
                  beanId: timerState.beanId,
                  method: timerState.method ?? BrewMethod.v60,
                  dose: timerState.targetDose ?? 15,
                  yield_: timerState.targetYield ?? 250,
                  grindSize: timerState.grindSize,
                  waterTemperature: timerState.waterTemperature,
                  brewTime: timerState.elapsed,
                  rating: rating > 0 ? rating : null,
                );

                // Dispatch to BrewBloc instead of using provider
                context.read<BrewBloc>().add(BrewLogCreated(brewLog));

                // Subtract from bean inventory if bean was selected
                if (timerState.beanId != null) {
                  final beans = ref.read(beansProvider).valueOrNull ?? [];
                  final bean = beans.where((b) => b.id == timerState.beanId).firstOrNull;
                  if (bean != null) {
                    final newWeight = bean.weightRemaining - (timerState.targetDose ?? 0);
                    ref.read(beansProvider.notifier).updateWeight(bean.id, newWeight > 0 ? newWeight : 0);
                  }
                }

                ref.read(brewTimerProvider.notifier).stop();
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}