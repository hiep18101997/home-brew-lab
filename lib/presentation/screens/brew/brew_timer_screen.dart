import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/brew_timer_provider.dart';
import '../../providers/brew_logs_provider.dart';
import '../../providers/beans_provider.dart';
import '../../../core/constants/brew_methods.dart';
import '../../../domain/entities/brew_log.dart';

class BrewTimerScreen extends ConsumerStatefulWidget {
  const BrewTimerScreen({super.key});

  @override
  ConsumerState<BrewTimerScreen> createState() => _BrewTimerScreenState();
}

class _BrewTimerScreenState extends ConsumerState<BrewTimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(brewTimerProvider);
    final timerNotifier = ref.read(brewTimerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          '${timerState.method?.displayName ?? "Brew"} Brew',
          style: GoogleFonts.notoSerif(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.onSurface),
          onPressed: () => _showCancelDialog(context, timerNotifier),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // Circular timer with animated progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                // Circular progress timer
                _CircularTimer(
                  elapsed: timerState.elapsed,
                  totalDuration: timerState.totalDuration,
                  progress: timerState.progress,
                  isRunning: timerState.isRunning,
                  isPaused: timerState.isPaused,
                  pulseAnimation: _pulseAnimation,
                ),
                const SizedBox(height: 24),

                // Step progress dots
                if (timerState.guide != null) ...[
                  _StepProgressDots(
                    totalSteps: timerState.guide!.steps.length,
                    currentStep: timerState.currentStepIndex,
                    isPaused: timerState.isPaused,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step ${timerState.currentStepIndex + 1} of ${timerState.guide!.steps.length}',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Current step card - immersive step display
          if (timerState.currentStep != null)
            Expanded(
              child: _StepCard(
                step: timerState.currentStep!,
                stepElapsed: timerState.stepElapsed,
                isPaused: timerState.isPaused,
              ),
            ),

          const SizedBox(height: 20),

          // Control buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Pause/Resume - Large prominent button
                _AnimatedBrewButton(
                  isPaused: timerState.isPaused,
                  onPressed: () {
                    if (timerState.isPaused) {
                      timerNotifier.resume();
                    } else {
                      timerNotifier.pause();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Bottom row: Next Step + Finish
                Row(
                  children: [
                    if (!timerState.isLastStep)
                      Expanded(
                        child: _SecondaryButton(
                          icon: Icons.skip_next,
                          label: 'Next Step',
                          onPressed: () => timerNotifier.nextStep(),
                        ),
                      ),
                    if (!timerState.isLastStep) const SizedBox(width: 12),
                    Expanded(
                      child: _SecondaryButton(
                        icon: Icons.check,
                        label: 'Finish',
                        isPrimary: true,
                        onPressed: () {
                          timerNotifier.pause();
                          _showSaveDialog(context, ref, timerState);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
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
      builder: (context) => Dialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cancel Brew?',
                style: GoogleFonts.notoSerif(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to cancel this brew? Your progress will be lost.',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'No',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        notifier.stop();
                        Navigator.pop(context);
                        context.pop();
                      },
                      child: Text(
                        'Yes, Cancel',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onError,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context, WidgetRef ref, BrewTimerState timerState) {
    int rating = 0;
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: AppColors.surfaceContainerHigh,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Save Brew',
                  style: GoogleFonts.notoSerif(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'How was your brew?',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => GestureDetector(
                    onTap: () => setState(() => rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        i < rating ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 36,
                        color: AppColors.secondary,
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
                            ref.read(brewTimerProvider.notifier).stop();
                            Navigator.pop(dialogContext);
                            context.pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Discard',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.9)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
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
                              SnackBar(
                                content: Text(
                                  'Brew saved!',
                                  style: GoogleFonts.manrope(),
                                ),
                                backgroundColor: AppColors.surfaceContainerHigh,
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Save',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularTimer extends StatelessWidget {
  final Duration elapsed;
  final Duration totalDuration;
  final double progress;
  final bool isRunning;
  final bool isPaused;
  final Animation<double> pulseAnimation;

  const _CircularTimer({
    required this.elapsed,
    required this.totalDuration,
    required this.progress,
    required this.isRunning,
    required this.isPaused,
    required this.pulseAnimation,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isRunning && !isPaused ? pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainerLow,
              ),
            ),
            // Progress arc
            SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: _CircularProgressPainter(
                  progress: progress,
                  progressColor: AppColors.secondary,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  strokeWidth: 6,
                ),
              ),
            ),
            // Glassmorphic inner circle
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerLow.withOpacity(0.7),
                    border: Border.all(
                      color: AppColors.surfaceContainer.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDuration(elapsed),
                        style: GoogleFonts.notoSerif(
                          fontSize: 44,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurface,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isPaused ? 'PAUSED' : 'BREWING',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isPaused ? AppColors.secondary : AppColors.onSurfaceVariant,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -3.14159 / 2; // Start from top
    final sweepAngle = 2 * 3.14159 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _StepProgressDots extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final bool isPaused;

  const _StepProgressDots({
    required this.totalSteps,
    required this.currentStep,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.secondary
                : isCompleted
                    ? AppColors.primary
                    : AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(5),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class _StepCard extends StatelessWidget {
  final dynamic step;
  final Duration stepElapsed;
  final bool isPaused;

  const _StepCard({
    required this.step,
    required this.stepElapsed,
    required this.isPaused,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Step name with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (step.waterAmount > 0)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.water_drop_outlined,
                    size: 18,
                    color: AppColors.secondary,
                  ),
                ),
              const SizedBox(width: 12),
              Text(
                step.name,
                style: GoogleFonts.notoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            step.instruction,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 15,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Water amount badge
          if (step.waterAmount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${step.waterAmount.toStringAsFixed(0)}g water',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),

          const Spacer(),

          // Step timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Step: ${_formatDuration(stepElapsed)} / ${_formatDuration(step.duration)}',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBrewButton extends StatelessWidget {
  final bool isPaused;
  final VoidCallback onPressed;

  const _AnimatedBrewButton({
    required this.isPaused,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPaused ? Icons.play_arrow : Icons.pause,
                key: ValueKey(isPaused),
                color: AppColors.onSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isPaused ? 'Resume' : 'Pause',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.surfaceContainerHigh : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary
            ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
            : null,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isPrimary ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}