import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/medical_analytics.dart';

class ComplianceChart extends StatelessWidget {
  final MedicalAnalytics analytics;

  const ComplianceChart({
    super.key,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: _buildPieChartSections(),
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              // Handle touch events if needed
            },
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final total = analytics.reminderEntries;
    if (total == 0) return [];

    final completed = analytics.completedReminders;
    final missed = analytics.missedReminders;
    final remaining = total - completed - missed;

    return [
      PieChartSectionData(
        value: completed.toDouble(),
        title: '${((completed / total) * 100).toInt()}%',
        color: Colors.green,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: missed.toDouble(),
        title: '${((missed / total) * 100).toInt()}%',
        color: Colors.red,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      if (remaining > 0)
        PieChartSectionData(
          value: remaining.toDouble(),
          title: '${((remaining / total) * 100).toInt()}%',
          color: Colors.orange,
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
    ];
  }
}

class WeeklyTrendChart extends StatelessWidget {
  final List<WeeklyTrend> weeklyTrends;

  const WeeklyTrendChart({
    super.key,
    required this.weeklyTrends,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklyTrends.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('No trend data available'),
        ),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 20,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() < weeklyTrends.length) {
                    final week = weeklyTrends[value.toInt()].week;
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        week.replaceAll('2025-W', 'W'),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          minX: 0,
          maxX: (weeklyTrends.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: weeklyTrends.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.complianceRate,
                );
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.8),
                  Colors.blue,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.blue,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.blue.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineComplianceBarChart extends StatelessWidget {
  final List<MedicineAnalysis> medicineAnalysis;

  const MedicineComplianceBarChart({
    super.key,
    required this.medicineAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    if (medicineAnalysis.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('No medicine data available'),
        ),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() < medicineAnalysis.length) {
                    final medicine = medicineAnalysis[value.toInt()];
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        medicine.medicineName.length > 8
                            ? '${medicine.medicineName.substring(0, 8)}...'
                            : medicine.medicineName,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 25,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          barGroups: medicineAnalysis.asMap().entries.map((entry) {
            final index = entry.key;
            final medicine = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: medicine.complianceRate,
                  color: _getComplianceColor(medicine.complianceRate),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getComplianceColor(double complianceRate) {
    if (complianceRate >= 80) return Colors.green;
    if (complianceRate >= 60) return Colors.orange;
    return Colors.red;
  }
}

class TimeSlotActivityChart extends StatelessWidget {
  final List<TimeSlotActivity> timeSlots;

  const TimeSlotActivityChart({
    super.key,
    required this.timeSlots,
  });

  @override
  Widget build(BuildContext context) {
    if (timeSlots.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(
          child: Text('No time slot data available'),
        ),
      );
    }

    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: timeSlots
                  .map((e) => e.count)
                  .reduce((a, b) => a > b ? a : b)
                  .toDouble() +
              2,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() < timeSlots.length) {
                    final slot = timeSlots[value.toInt()];
                    final timeParts =
                        slot.timeRange.split(' ')[0]; // Get just the time part
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        timeParts,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    );
                  }
                  return Container();
                },
                reservedSize: 25,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          barGroups: timeSlots.asMap().entries.map((entry) {
            final index = entry.key;
            final slot = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: slot.count.toDouble(),
                  color: Colors.purple,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
