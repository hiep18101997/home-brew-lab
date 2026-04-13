import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/brew_timer_provider.dart';
import '../../providers/brew_logs_provider.dart';
import '../../providers/beans_provider.dart';
import '../../../core/constants/brew_methods.dart';
import '../../../domain/entities/brew_log.dart';

class BrewTimerScreen extends ConsumerWidget {
  const BrewTimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(brewTimerProvider);
    final timerNotifier = ref.read(brewTimerProvider.notifier);

    return Scaffold(
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
                      timerState.currentStep!.instruction,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (timerState.currentStep!.waterAmount > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${timerState.currentStep!.waterAmount.toStringAsFixed(0)}g water',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
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
      builder: (context) => AlertDialog(
        title: const Text('Cancel Brew?'),
        content: const Text('Are you sure you want to cancel this brew?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () {
              notifier.stop();
              Navigator.pop(context);
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
                ref.read(brewLogsProvider.notifier).addBrewLog(brewLog);

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
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Brew saved!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}