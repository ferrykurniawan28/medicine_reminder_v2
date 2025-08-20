class MedicalAnalytics {
  final int totalEntries;
  final int reminderEntries;
  final int appointmentEntries;
  final int completedReminders;
  final int missedReminders;
  final int attendedAppointments;
  final int missedAppointments;
  final List<MedicineAnalysis> medicineAnalysis;
  final Map<String, int> reminderStatusBreakdown;
  final Map<String, int> appointmentStatusBreakdown;
  final List<TimeSlotActivity> mostActiveTimeSlots;
  final List<WeeklyTrend> weeklyTrends;
  final double overallComplianceRate;
  final List<MedicineCompliance> medicineComplianceRates;
  final ActivitySummary lastWeekActivity;
  final ActivitySummary lastMonthActivity;

  MedicalAnalytics({
    required this.totalEntries,
    required this.reminderEntries,
    required this.appointmentEntries,
    required this.completedReminders,
    required this.missedReminders,
    required this.attendedAppointments,
    required this.missedAppointments,
    required this.medicineAnalysis,
    required this.reminderStatusBreakdown,
    required this.appointmentStatusBreakdown,
    required this.mostActiveTimeSlots,
    required this.weeklyTrends,
    required this.overallComplianceRate,
    required this.medicineComplianceRates,
    required this.lastWeekActivity,
    required this.lastMonthActivity,
  });

  factory MedicalAnalytics.fromJson(Map<String, dynamic> json) {
    return MedicalAnalytics(
      totalEntries: json['total_entries'] ?? 0,
      reminderEntries: json['reminder_entries'] ?? 0,
      appointmentEntries: json['appointment_entries'] ?? 0,
      completedReminders: json['completed_reminders'] ?? 0,
      missedReminders: json['missed_reminders'] ?? 0,
      attendedAppointments: json['attended_appointments'] ?? 0,
      missedAppointments: json['missed_appointments'] ?? 0,
      medicineAnalysis: (json['medicine_analysis'] as List<dynamic>? ?? [])
          .map((item) => MedicineAnalysis.fromJson(item))
          .toList(),
      reminderStatusBreakdown:
          Map<String, int>.from(json['reminder_status_breakdown'] ?? {}),
      appointmentStatusBreakdown:
          Map<String, int>.from(json['appointment_status_breakdown'] ?? {}),
      mostActiveTimeSlots:
          (json['most_active_time_slots'] as List<dynamic>? ?? [])
              .map((item) => TimeSlotActivity.fromJson(item))
              .toList(),
      weeklyTrends: (json['weekly_trends'] as List<dynamic>? ?? [])
          .map((item) => WeeklyTrend.fromJson(item))
          .toList(),
      overallComplianceRate: (json['overall_compliance_rate'] ?? 0).toDouble(),
      medicineComplianceRates:
          (json['medicine_compliance_rates'] as List<dynamic>? ?? [])
              .map((item) => MedicineCompliance.fromJson(item))
              .toList(),
      lastWeekActivity:
          ActivitySummary.fromJson(json['last_week_activity'] ?? {}),
      lastMonthActivity:
          ActivitySummary.fromJson(json['last_month_activity'] ?? {}),
    );
  }
}

class MedicineAnalysis {
  final String medicineName;
  final int totalLogs;
  final int takenCount;
  final int missedCount;
  final int skippedCount;
  final int partialCount;
  final double complianceRate;
  final double averageDosage;
  final String firstTaken;
  final String lastTaken;
  final int durationDays;
  final String mostCommonTime;

  MedicineAnalysis({
    required this.medicineName,
    required this.totalLogs,
    required this.takenCount,
    required this.missedCount,
    required this.skippedCount,
    required this.partialCount,
    required this.complianceRate,
    required this.averageDosage,
    required this.firstTaken,
    required this.lastTaken,
    required this.durationDays,
    required this.mostCommonTime,
  });

  factory MedicineAnalysis.fromJson(Map<String, dynamic> json) {
    return MedicineAnalysis(
      medicineName: json['medicine_name'] ?? '',
      totalLogs: json['total_logs'] ?? 0,
      takenCount: json['taken_count'] ?? 0,
      missedCount: json['missed_count'] ?? 0,
      skippedCount: json['skipped_count'] ?? 0,
      partialCount: json['partial_count'] ?? 0,
      complianceRate: (json['compliance_rate'] ?? 0).toDouble(),
      averageDosage: (json['average_dosage'] ?? 0).toDouble(),
      firstTaken: json['first_taken'] ?? '',
      lastTaken: json['last_taken'] ?? '',
      durationDays: json['duration_days'] ?? 0,
      mostCommonTime: json['most_common_time'] ?? '',
    );
  }
}

class TimeSlotActivity {
  final String timeRange;
  final int count;
  final double complianceRate;

  TimeSlotActivity({
    required this.timeRange,
    required this.count,
    required this.complianceRate,
  });

  factory TimeSlotActivity.fromJson(Map<String, dynamic> json) {
    return TimeSlotActivity(
      timeRange: json['time_range'] ?? '',
      count: json['count'] ?? 0,
      complianceRate: (json['compliance_rate'] ?? 0).toDouble(),
    );
  }
}

class WeeklyTrend {
  final String week;
  final int totalReminders;
  final int completedReminders;
  final double complianceRate;

  WeeklyTrend({
    required this.week,
    required this.totalReminders,
    required this.completedReminders,
    required this.complianceRate,
  });

  factory WeeklyTrend.fromJson(Map<String, dynamic> json) {
    return WeeklyTrend(
      week: json['week'] ?? '',
      totalReminders: json['total_reminders'] ?? 0,
      completedReminders: json['completed_reminders'] ?? 0,
      complianceRate: (json['compliance_rate'] ?? 0).toDouble(),
    );
  }
}

class MedicineCompliance {
  final String medicineName;
  final double complianceRate;
  final double recommendationScore;

  MedicineCompliance({
    required this.medicineName,
    required this.complianceRate,
    required this.recommendationScore,
  });

  factory MedicineCompliance.fromJson(Map<String, dynamic> json) {
    return MedicineCompliance(
      medicineName: json['medicine_name'] ?? '',
      complianceRate: (json['compliance_rate'] ?? 0).toDouble(),
      recommendationScore: (json['recommendation_score'] ?? 0).toDouble(),
    );
  }
}

class ActivitySummary {
  final int totalReminders;
  final int totalAppointments;
  final double complianceRate;
  final String mostTakenMedicine;
  final String trendDirection;

  ActivitySummary({
    required this.totalReminders,
    required this.totalAppointments,
    required this.complianceRate,
    required this.mostTakenMedicine,
    required this.trendDirection,
  });

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      totalReminders: json['total_reminders'] ?? 0,
      totalAppointments: json['total_appointments'] ?? 0,
      complianceRate: (json['compliance_rate'] ?? 0).toDouble(),
      mostTakenMedicine: json['most_taken_medicine'] ?? '',
      trendDirection: json['trend_direction'] ?? '',
    );
  }
}
