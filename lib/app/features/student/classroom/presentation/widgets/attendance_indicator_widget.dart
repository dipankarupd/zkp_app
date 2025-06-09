import 'package:flutter/material.dart';

class AttendanceIndicator extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;

  const AttendanceIndicator({
    Key? key,
    required this.label,
    required this.value,
    required this.max,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the progress value safely
    final double progressValue = max > 0 ? value / max : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 120,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 0, end: progressValue),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}
