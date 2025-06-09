import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AttendanceChart extends StatelessWidget {
  final double attendancePercent;

  const AttendanceChart({
    Key? key,
    required this.attendancePercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double safePercent =
        attendancePercent.isFinite && !attendancePercent.isNaN
            ? attendancePercent
            : 0.0;
    final double percentValue = (safePercent * 100).clamp(0, 100);
    final String displayPercent = percentValue.toStringAsFixed(0);

    return SizedBox(
      width: 150,
      height: 150,
      child: SfCircularChart(
        annotations: [
          CircularChartAnnotation(
            widget: Text(
              '$displayPercent%',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        series: <CircularSeries>[
          RadialBarSeries<_ChartData, String>(
            maximumValue: 100, // This ensures 100% scale
            dataSource: [
              _ChartData('Attendance', percentValue),
            ],
            xValueMapper: (_ChartData data, _) => data.label,
            yValueMapper: (_ChartData data, _) => data.value,
            pointColorMapper: (_, __) => Colors.green,
            radius: '100%',
            innerRadius: '70%',
            cornerStyle: CornerStyle.bothCurve,
            trackColor: Colors.grey.withOpacity(0.2), // Light grey background
            trackOpacity: 1,
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  final String label;
  final double value;

  _ChartData(this.label, this.value);
}
