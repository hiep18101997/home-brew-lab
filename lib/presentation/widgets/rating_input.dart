import 'package:flutter/material.dart';

class RatingInput extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  const RatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: size,
            color: Colors.amber,
          ),
          onPressed: () => onChanged(index + 1),
        );
      }),
    );
  }
}