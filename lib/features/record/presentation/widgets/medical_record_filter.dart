import 'package:flutter/material.dart';

class MedicalRecordFilter extends StatelessWidget {
  final String? selectedType;
  final String? selectedStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function({
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) onFilterChanged;

  const MedicalRecordFilter({
    super.key,
    this.selectedType,
    this.selectedStatus,
    this.startDate,
    this.endDate,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Records',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All Types'),
                    ),
                    DropdownMenuItem(
                      value: 'reminder',
                      child: Text('Reminders'),
                    ),
                    DropdownMenuItem(
                      value: 'appointment',
                      child: Text('Appointments'),
                    ),
                  ],
                  onChanged: (value) {
                    onFilterChanged(
                      type: value,
                      status: selectedStatus,
                      startDate: startDate,
                      endDate: endDate,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All Status'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed'),
                    ),
                    DropdownMenuItem(
                      value: 'missed',
                      child: Text('Missed'),
                    ),
                    DropdownMenuItem(
                      value: 'attended',
                      child: Text('Attended'),
                    ),
                    DropdownMenuItem(
                      value: 'cancelled',
                      child: Text('Cancelled'),
                    ),
                    DropdownMenuItem(
                      value: 'pending',
                      child: Text('Pending'),
                    ),
                  ],
                  onChanged: (value) {
                    onFilterChanged(
                      type: selectedType,
                      status: value,
                      startDate: startDate,
                      endDate: endDate,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          onFilterChanged(
                            type: selectedType,
                            status: selectedStatus,
                            startDate: date,
                            endDate: endDate,
                          );
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: startDate != null
                        ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                        : '',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          onFilterChanged(
                            type: selectedType,
                            status: selectedStatus,
                            startDate: startDate,
                            endDate: date,
                          );
                        }
                      },
                    ),
                  ),
                  controller: TextEditingController(
                    text: endDate != null
                        ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                        : '',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  onFilterChanged(
                    type: null,
                    status: null,
                    startDate: null,
                    endDate: null,
                  );
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
