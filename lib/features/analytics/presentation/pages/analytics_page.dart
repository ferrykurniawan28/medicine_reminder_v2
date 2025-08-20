// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class AnalyticsPage extends StatelessWidget {
//   const AnalyticsPage({super.key});

//   Future<Map<String, dynamic>> _fetchAnalyticsData() async {
//     // Simulate API call delay
//     await Future.delayed(const Duration(seconds: 2));

//     // Return your mock data here
//     return {
//       "message": "enhanced medical record summary retrieved",
//       "data": {
//         "total_entries": 25,
//         "reminder_entries": 10,
//         "appointment_entries": 15,
//         "completed_reminders": 2,
//         "missed_reminders": 2,
//         "attended_appointments": 4,
//         "missed_appointments": 9,
//         "medicine_analysis": [
//           {
//             "medicine_name": "Atorvastatin",
//             "total_logs": 1,
//             "taken_count": 0,
//             "missed_count": 0,
//             "skipped_count": 1,
//             "partial_count": 0,
//             "compliance_rate": 0,
//             "average_dosage": 3,
//             "first_taken": "2025-08-08",
//             "last_taken": "2025-08-08",
//             "duration_days": 0,
//             "most_common_time": ""
//           },
//           {
//             "medicine_name": "Levothyroxine",
//             "total_logs": 1,
//             "taken_count": 0,
//             "missed_count": 0,
//             "skipped_count": 1,
//             "partial_count": 0,
//             "compliance_rate": 0,
//             "average_dosage": 2,
//             "first_taken": "2025-08-09",
//             "last_taken": "2025-08-09",
//             "duration_days": 0,
//             "most_common_time": ""
//           },
//           {
//             "medicine_name": "Aspirin",
//             "total_logs": 1,
//             "taken_count": 1,
//             "missed_count": 0,
//             "skipped_count": 0,
//             "partial_count": 0,
//             "compliance_rate": 100,
//             "average_dosage": 1,
//             "first_taken": "2025-08-13",
//             "last_taken": "2025-08-13",
//             "duration_days": 0,
//             "most_common_time": ""
//           },
//           {
//             "medicine_name": "Lisinopril",
//             "total_logs": 7,
//             "taken_count": 1,
//             "missed_count": 2,
//             "skipped_count": 2,
//             "partial_count": 2,
//             "compliance_rate": 14.285714285714285,
//             "average_dosage": 1.8571428571428572,
//             "first_taken": "2025-08-07",
//             "last_taken": "2025-08-12",
//             "duration_days": 5,
//             "most_common_time": ""
//           }
//         ],
//         "reminder_status_breakdown": {
//           "missed": 2,
//           "partial": 2,
//           "skipped": 4,
//           "taken": 2
//         },
//         "appointment_status_breakdown": {
//           "attended": 4,
//           "cancelled": 3,
//           "missed": 6,
//           "rescheduled": 2
//         },
//         "overall_compliance_rate": 20,
//         "last_week_activity": {
//           "total_reminders": 0,
//           "total_appointments": 0,
//           "compliance_rate": 0,
//           "most_taken_medicine": "None",
//           "trend_direction": "declining"
//         },
//         "last_month_activity": {
//           "total_reminders": 10,
//           "total_appointments": 0,
//           "compliance_rate": 20,
//           "most_taken_medicine": "Lisinopril",
//           "trend_direction": "declining"
//         }
//       }
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Analytics'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _fetchAnalyticsData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error, color: Colors.red, size: 64),
//                   const SizedBox(height: 16),
//                   Text('Error: ${snapshot.error}'),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Trigger rebuild
//                       (context as Element).markNeedsBuild();
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final data = snapshot.data!['data'] as Map<String, dynamic>;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildOverviewCards(data),
//                 const SizedBox(height: 24),
//                 _buildComplianceChart(data),
//                 const SizedBox(height: 24),
//                 _buildMedicineAnalysis(data),
//                 const SizedBox(height: 24),
//                 _buildStatusBreakdown(data),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildOverviewCards(Map<String, dynamic> data) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Overview',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _buildStatCard(
//                 'Total Entries',
//                 data['total_entries'].toString(),
//                 Icons.list_alt,
//                 Colors.blue,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildStatCard(
//                 'Compliance Rate',
//                 '${data['overall_compliance_rate']}%',
//                 Icons.show_chart,
//                 Colors.green,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: _buildStatCard(
//                 'Reminders',
//                 data['reminder_entries'].toString(),
//                 Icons.alarm,
//                 Colors.orange,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _buildStatCard(
//                 'Appointments',
//                 data['appointment_entries'].toString(),
//                 Icons.calendar_today,
//                 Colors.purple,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//       String title, String value, IconData icon, Color color) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 32),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               title,
//               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildComplianceChart(Map<String, dynamic> data) {
//     final reminderBreakdown =
//         data['reminder_status_breakdown'] as Map<String, dynamic>;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Reminder Status Breakdown',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   sections: [
//                     PieChartSectionData(
//                       value: reminderBreakdown['taken'].toDouble(),
//                       title: 'Taken\n${reminderBreakdown['taken']}',
//                       color: Colors.green,
//                       radius: 60,
//                     ),
//                     PieChartSectionData(
//                       value: reminderBreakdown['missed'].toDouble(),
//                       title: 'Missed\n${reminderBreakdown['missed']}',
//                       color: Colors.red,
//                       radius: 60,
//                     ),
//                     PieChartSectionData(
//                       value: reminderBreakdown['skipped'].toDouble(),
//                       title: 'Skipped\n${reminderBreakdown['skipped']}',
//                       color: Colors.orange,
//                       radius: 60,
//                     ),
//                     PieChartSectionData(
//                       value: reminderBreakdown['partial'].toDouble(),
//                       title: 'Partial\n${reminderBreakdown['partial']}',
//                       color: Colors.yellow,
//                       radius: 60,
//                     ),
//                   ],
//                   centerSpaceRadius: 40,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMedicineAnalysis(Map<String, dynamic> data) {
//     final medicineAnalysis = data['medicine_analysis'] as List<dynamic>;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Medicine Analysis',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...medicineAnalysis.map((medicine) => _buildMedicineCard(medicine)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMedicineCard(Map<String, dynamic> medicine) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey[300]!),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 medicine['medicine_name'],
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _getComplianceColor(medicine['compliance_rate']),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   '${medicine['compliance_rate'].toInt()}%',
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               _buildMedicineDetail('Taken', medicine['taken_count'].toString()),
//               _buildMedicineDetail(
//                   'Missed', medicine['missed_count'].toString()),
//               _buildMedicineDetail(
//                   'Skipped', medicine['skipped_count'].toString()),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMedicineDetail(String label, String value) {
//     return Expanded(
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text(
//             label,
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusBreakdown(Map<String, dynamic> data) {
//     final appointmentBreakdown =
//         data['appointment_status_breakdown'] as Map<String, dynamic>;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Appointment Status',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             ...appointmentBreakdown.entries.map(
//                 (entry) => _buildStatusRow(entry.key, entry.value.toString())),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusRow(String status, String count) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             status.toUpperCase(),
//             style: const TextStyle(fontWeight: FontWeight.w500),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               color: _getStatusColor(status),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               count,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getComplianceColor(double rate) {
//     if (rate >= 80) return Colors.green;
//     if (rate >= 60) return Colors.orange;
//     return Colors.red;
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'attended':
//       case 'taken':
//         return Colors.green;
//       case 'missed':
//         return Colors.red;
//       case 'cancelled':
//       case 'skipped':
//         return Colors.orange;
//       case 'rescheduled':
//       case 'partial':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
// }
