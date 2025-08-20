import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_reminder/features/user/bloc/user_bloc.dart';
import '../bloc/medical_record_bloc.dart';
import '../widgets/medical_record_list.dart';
import '../widgets/medical_record_filter.dart';
import '../../domain/entities/medical_record.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  late final int userId;
  String? selectedType;
  String? selectedStatus;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    // Load initial data
    _loadRecords();
  }

  void _loadRecords() {
    final userState = context.read<UserBloc>().state;
    userId = (userState is CurrentUser || userState is UserLoaded)
        ? (userState as dynamic).user.userId!
        : 0;
    context.read<MedicalRecordBloc>().add(
          LoadMedicalRecords(
            userId: userId,
            type: selectedType,
            status: selectedStatus,
            startDate: startDate,
            endDate: endDate,
          ),
        );
  }

  void _onFilterChanged({
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    setState(() {
      selectedType = type;
      selectedStatus = status;
      this.startDate = startDate;
      this.endDate = endDate;
    });
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MedicalRecordBloc>().add(
                    RefreshMedicalRecords(
                      userId: userId,
                      type: selectedType,
                      status: selectedStatus,
                      startDate: startDate,
                      endDate: endDate,
                    ),
                  );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // MedicalRecordFilter(
          //   selectedType: selectedType,
          //   selectedStatus: selectedStatus,
          //   startDate: startDate,
          //   endDate: endDate,
          //   onFilterChanged: _onFilterChanged,
          // ),
          Expanded(
            child: BlocBuilder<MedicalRecordBloc, MedicalRecordState>(
              builder: (context, state) {
                if (state is MedicalRecordLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MedicalRecordsLoaded) {
                  if (state.records.isEmpty) {
                    return const Center(
                      child: Text(
                        'No medical records found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return MedicalRecordList(records: state.records);
                } else if (state is MedicalRecordError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadRecords,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
