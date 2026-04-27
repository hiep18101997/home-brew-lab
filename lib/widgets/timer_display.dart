import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final Duration elapsed;
  final Duration? total;
  final double? progress;

  const TimerDisplay({
    super.key,
    required this.elapsed,
    this.total,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatDuration(elapsed),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        if (total != null) ...[
          const SizedBox(height: 4),
          Text(
            'of ${_formatDuration(total!)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
        if (progress != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}