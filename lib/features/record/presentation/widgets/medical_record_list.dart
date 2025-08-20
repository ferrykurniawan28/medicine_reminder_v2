import 'package:flutter/material.dart';
import '../../domain/entities/medical_record.dart';
import 'medical_record_card.dart';

class MedicalRecordList extends StatelessWidget {
  final List<MedicalRecord> records;

  const MedicalRecordList({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: MedicalRecordCard(record: record),
        );
      },
    );
  }
}
