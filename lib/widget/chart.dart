import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:trackexx/theme/color.dart';

List<Color> gradientColors = [primary];

LineChartData mainData() {
  return LineChartData(
    gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0.1,
          );
        }),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles:AxisTitles(sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        // getTextStyles: (value) =>
        //     const TextStyle(color: Color(0xff68737d), fontSize: 12),
        getTitlesWidget: (value,MetaData) {
          switch (value.toInt()) {
            case 2:
              return Text("1");
            case 5:
              return Text('11');
            case 8:
              return Text('21');
          }
          return Text('');
        },
        interval: 8,
      ),),
      leftTitles: AxisTitles(sideTitles: SideTitles(
        showTitles: true,
        // getTextStyles: (value) => const TextStyle(
        //   color: Color(0xff67727d),
        //   fontSize: 12,
        // ),
        getTitlesWidget: (value,MetaData) {
          switch (value.toInt()) {
            case 1:
              return Text('10k');
            case 3:
              return Text('50k');
            case 5:
              return Text('100k');
          }
          return Text('');
        },
        reservedSize: 28,
        interval: 12,
      ),)
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
        ],
        isCurved: true,
        color: primary,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
      ),
    ],
  );
}
