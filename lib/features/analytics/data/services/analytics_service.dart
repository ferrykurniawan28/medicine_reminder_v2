import 'dart:convert';
import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/core/network/network_service.dart';

import '../models/medical_analytics.dart';

class AnalyticsService {
  final NetworkService _networkServices = NetworkService();

  Future<MedicalAnalytics> getMedicalAnalytics(int userId) async {
    try {
      final response = await _networkServices.get(
        '$medicalAnalyticsUrl/$userId',
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Handle different response formats
        Map<String, dynamic> jsonData;

        if (response.data is String) {
          // If response is a string, decode it
          jsonData = json.decode(response.data);
        } else if (response.data is Map<String, dynamic>) {
          // If response is already a Map, use it directly
          jsonData = response.data;
        } else {
          throw Exception('Unexpected response format');
        }

        print('Parsed JSON data: $jsonData');

        // Feed data directly to the model
        return MedicalAnalytics.fromJson(jsonData);
      } else {
        throw Exception('Failed to load analytics data');
      }
    } catch (e) {
      print('Error fetching analytics data: $e');
      // For demo purposes, return mock data
      // Remove this in production and handle the actual API call
      return _getMockAnalytics();
    }
  }

  // Mock data for development/testing
  MedicalAnalytics _getMockAnalytics() {
    const mockJsonString = '''
    {
      "message": "enhanced medical record summary retrieved",
      "data": {
        "total_entries": 25,
        "reminder_entries": 10,
        "appointment_entries": 15,
        "completed_reminders": 2,
        "missed_reminders": 2,
        "attended_appointments": 4,
        "missed_appointments": 9,
        "medicine_analysis": [
          {
            "medicine_name": "Atorvastatin",
            "total_logs": 1,
            "taken_count": 0,
            "missed_count": 0,
            "skipped_count": 1,
            "partial_count": 0,
            "compliance_rate": 0,
            "average_dosage": 3,
            "first_taken": "2025-08-08",
            "last_taken": "2025-08-08",
            "duration_days": 0,
            "most_common_time": ""
          },
          {
            "medicine_name": "Aspirin",
            "total_logs": 1,
            "taken_count": 1,
            "missed_count": 0,
            "skipped_count": 0,
            "partial_count": 0,
            "compliance_rate": 100,
            "average_dosage": 1,
            "first_taken": "2025-08-13",
            "last_taken": "2025-08-13",
            "duration_days": 0,
            "most_common_time": ""
          },
          {
            "medicine_name": "Lisinopril",
            "total_logs": 7,
            "taken_count": 1,
            "missed_count": 2,
            "skipped_count": 2,
            "partial_count": 2,
            "compliance_rate": 14.285714285714285,
            "average_dosage": 1.8571428571428572,
            "first_taken": "2025-08-07",
            "last_taken": "2025-08-12",
            "duration_days": 5,
            "most_common_time": ""
          }
        ],
        "reminder_status_breakdown": {
          "missed": 2,
          "partial": 2,
          "skipped": 4,
          "taken": 2
        },
        "appointment_status_breakdown": {
          "attended": 4,
          "cancelled": 3,
          "missed": 6,
          "rescheduled": 2
        },
        "most_active_time_slots": [
          {
            "time_range": "Night (21:00-06:00)",
            "count": 5,
            "compliance_rate": 20
          },
          {
            "time_range": "Morning (06:00-12:00)",
            "count": 3,
            "compliance_rate": 20
          }
        ],
        "weekly_trends": [
          {
            "week": "2025-W33",
            "total_reminders": 2,
            "completed_reminders": 2,
            "compliance_rate": 100
          },
          {
            "week": "2025-W32",
            "total_reminders": 8,
            "completed_reminders": 0,
            "compliance_rate": 0
          }
        ],
        "overall_compliance_rate": 20,
        "medicine_compliance_rates": [
          {
            "medicine_name": "Aspirin",
            "compliance_rate": 100,
            "recommendation_score": 80
          },
          {
            "medicine_name": "Lisinopril",
            "compliance_rate": 14.285714285714285,
            "recommendation_score": 15.476190476190474
          }
        ],
        "last_week_activity": {
          "total_reminders": 0,
          "total_appointments": 0,
          "compliance_rate": 0,
          "most_taken_medicine": "None",
          "trend_direction": "declining"
        },
        "last_month_activity": {
          "total_reminders": 10,
          "total_appointments": 0,
          "compliance_rate": 20,
          "most_taken_medicine": "Lisinopril",
          "trend_direction": "declining"
        }
      }
    }
    ''';

    final jsonData = json.decode(mockJsonString);
    return MedicalAnalytics.fromJson(jsonData);
  }
}
