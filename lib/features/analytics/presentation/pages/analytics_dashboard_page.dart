import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/features/user/bloc/user_bloc.dart';
import 'package:medicine_reminder/helpers/helpers.dart';
import '../../data/models/medical_analytics.dart';
import '../../data/services/analytics_service.dart';
import '../widgets/analytics_charts.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final int userId;
  late final AnalyticsService _analyticsService;
  late Future<MedicalAnalytics> _analyticsFuture;

  @override
  void initState() {
    super.initState();
    _analyticsService = AnalyticsService();
    // Replace with actual user ID - you might get this from auth service or global state
    final userState = context.read<UserBloc>().state;
    userId = (userState is CurrentUser || userState is UserLoaded)
        ? (userState as dynamic).user.userId!
        : 0;

    if (userId == 0) {
      debugPrint('No user logged in. Defaulting userId to 0.');
    } else {
      debugPrint('User ID in ReminderListBody: $userId');
    }

    _analyticsFuture = _analyticsService.getMedicalAnalytics(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Medical Analytics'),
      body: FutureBuilder<MedicalAnalytics>(
        future: _analyticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading analytics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _analyticsFuture =
                            _analyticsService.getMedicalAnalytics(1);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No analytics data available'),
            );
          }

          final analytics = snapshot.data!;
          return _buildAnalyticsContent(analytics);
        },
      ),
    );
  }

  Widget _buildAnalyticsContent(MedicalAnalytics analytics) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _analyticsFuture = _analyticsService.getMedicalAnalytics(1);
        });
        await _analyticsFuture;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewSection(analytics),
            const SizedBox(height: 24),
            _buildComplianceSection(analytics),
            const SizedBox(height: 24),
            _buildMedicineAnalysisSection(analytics),
            const SizedBox(height: 24),
            _buildActivitySection(analytics),
            const SizedBox(height: 24),
            _buildTrendsSection(analytics),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(MedicalAnalytics data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Entries',
                    data.totalEntries.toString(),
                    Icons.medical_services,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Compliance Rate',
                    '${data.overallComplianceRate.toInt()}%',
                    Icons.check_circle,
                    data.overallComplianceRate >= 70
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Reminders',
                    data.reminderEntries.toString(),
                    Icons.notifications,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    'Appointments',
                    data.appointmentEntries.toString(),
                    Icons.calendar_today,
                    Colors.teal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceSection(MedicalAnalytics data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compliance Summary',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // Add pie chart for visual representation

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildComplianceItem(
                              'Completed',
                              data.completedReminders,
                              data.reminderEntries,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildComplianceItem(
                              'Missed',
                              data.missedReminders,
                              data.reminderEntries,
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildComplianceItem(
                              'Attended Apps',
                              data.attendedAppointments,
                              data.appointmentEntries,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildComplianceItem(
                              'Missed Apps',
                              data.missedAppointments,
                              data.appointmentEntries,
                              Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineAnalysisSection(MedicalAnalytics data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicine Analysis',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // Add medicine compliance bar chart
            if (data.medicineAnalysis.isNotEmpty) ...[
              Text(
                'Medicine Compliance Rates',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              MedicineComplianceBarChart(
                  medicineAnalysis: data.medicineAnalysis),
              const SizedBox(height: 16),
            ],
            // Medicine cards
            ...data.medicineAnalysis
                .map((medicine) => _buildMedicineCard(medicine)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection(MedicalAnalytics data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Summary',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildActivityCard('Last Week', data.lastWeekActivity),
            const SizedBox(height: 12),
            _buildActivityCard('Last Month', data.lastMonthActivity),
            const SizedBox(height: 16),
            if (data.mostActiveTimeSlots.isNotEmpty) ...[
              Text(
                'Most Active Time Slots',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              // Add time slot activity chart
              TimeSlotActivityChart(timeSlots: data.mostActiveTimeSlots),
              const SizedBox(height: 12),
              // Time slot cards
              ...data.mostActiveTimeSlots
                  .map((slot) => _buildTimeSlotCard(slot)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsSection(MedicalAnalytics data) {
    if (data.weeklyTrends.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Trends',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // Add weekly trend chart
            WeeklyTrendChart(weeklyTrends: data.weeklyTrends),
            const SizedBox(height: 16),
            // Weekly trend cards
            ...data.weeklyTrends.map((trend) => _buildWeeklyTrendCard(trend)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(String label, int value, int total, Color color) {
    final percentage = total > 0 ? ((value / total) * 100).toInt() : 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            '$label ($percentage%)',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(MedicineAnalysis medicine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  medicine.medicineName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: medicine.complianceRate >= 70
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${medicine.complianceRate.toInt()}%',
                  style: TextStyle(
                    color: medicine.complianceRate >= 70
                        ? Colors.green[700]
                        : Colors.orange[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMiniMetric('Total', medicine.totalLogs.toString()),
              _buildMiniMetric('Taken', medicine.takenCount.toString()),
              _buildMiniMetric('Missed', medicine.missedCount.toString()),
              _buildMiniMetric('Skipped', medicine.skippedCount.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String period, ActivitySummary activity) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                period,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      _getTrendColor(activity.trendDirection).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  activity.trendDirection,
                  style: TextStyle(
                    color: _getTrendColor(activity.trendDirection),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('Reminders: ${activity.totalReminders}'),
              ),
              Expanded(
                child: Text('Appointments: ${activity.totalAppointments}'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text('Compliance: ${activity.complianceRate.toInt()}%'),
              ),
              Expanded(
                child: Text('Top Medicine: ${activity.mostTakenMedicine}'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard(TimeSlotActivity slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              slot.timeRange,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Text('${slot.count} activities'),
          Text('${slot.complianceRate.toInt()}% compliance'),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendCard(WeeklyTrend trend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            trend.week,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text('${trend.totalReminders} reminders'),
          Text('${trend.completedReminders} completed'),
          Text('${trend.complianceRate.toInt()}%'),
        ],
      ),
    );
  }

  Color _getTrendColor(String trend) {
    switch (trend.toLowerCase()) {
      case 'improving':
        return Colors.green;
      case 'declining':
        return Colors.red;
      case 'stable':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
