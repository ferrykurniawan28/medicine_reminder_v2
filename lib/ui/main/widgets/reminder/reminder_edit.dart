part of '../widgets.dart';

void showReminderEdit(BuildContext context, Reminder reminder) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.grey[100],
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: ReminderEdit(reminder: reminder),
      );
    },
  );
}

class ReminderEdit extends StatefulWidget {
  const ReminderEdit({
    super.key,
    required this.reminder,
  });

  final Reminder reminder;

  @override
  State<ReminderEdit> createState() => _ReminderEditState();
}

class _ReminderEditState extends State<ReminderEdit> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _medicineLeftController = TextEditingController();
  final _noteController = TextEditingController();

  // Form state variables
  late ReminderType _selectedType;
  late List<int> _dosage;
  late List<Time> _times;
  late List<Days>? _selectedDays;
  late DateTime? _endDate;
  late bool _isActive;
  late bool _isAlert;

  // UI state variables
  bool _isLoading = false;
  final ValueNotifier<bool> _showEndDate = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    // Initialize controllers with existing data
    _medicineNameController.text = widget.reminder.medicineName;
    _medicineLeftController.text =
        widget.reminder.medicineLeft?.toString() ?? '';
    _noteController.text = widget.reminder.note ?? '';

    // Initialize form variables
    _selectedType = widget.reminder.type;
    _dosage = List.from(widget.reminder.dosage);
    _times = List.from(widget.reminder.times);
    _selectedDays = widget.reminder.daysofWeek != null
        ? List.from(widget.reminder.daysofWeek!)
        : null;
    _endDate = widget.reminder.endDate;
    _isActive = widget.reminder.isActive;
    _isAlert = widget.reminder.isAlert;

    _showEndDate.value = _endDate != null;
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _medicineLeftController.dispose();
    _noteController.dispose();
    _showEndDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildMedicineSection(),
                  const SizedBox(height: 20),
                  _buildDosageSection(),
                  const SizedBox(height: 20),
                  _buildScheduleSection(),
                  const SizedBox(height: 20),
                  _buildTimesSection(),
                  const SizedBox(height: 20),
                  _buildDaysSection(),
                  const SizedBox(height: 20),
                  _buildEndDateSection(),
                  const SizedBox(height: 20),
                  _buildStatusSection(),
                  const SizedBox(height: 20),
                  _buildNotesSection(),
                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _saveReminder,
        backgroundColor: kPrimaryColor,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save, color: Colors.white),
        label: Text(
          _isLoading ? 'Saving...' : 'Save Changes',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [defaultShadow],
      ),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          Text(
            'Edit Reminder',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          const SizedBox(width: 70), // Balance the cancel button
        ],
      ),
    );
  }

  Widget _buildSection({
    required Widget icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildMedicineSection() {
    return _buildSection(
      icon: const OptimizedIcon(
        assetPath: 'assets/icons/pill.png',
        size: 24,
        color: kPrimaryColor,
      ),
      title: 'Medicine Information',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _medicineNameController,
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
                hintText: 'Enter medicine name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Medicine name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _medicineLeftController,
              decoration: const InputDecoration(
                labelText: 'Quantity Left',
                hintText: 'Enter quantity remaining',
                border: OutlineInputBorder(),
                suffixText: 'pills',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDosageSection() {
    return _buildSection(
      icon: const Icon(Icons.medication, size: 24, color: kPrimaryColor),
      title: 'Dosage',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Number of pills per dose:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _dosage.asMap().entries.map((entry) {
                int index = entry.key;
                int value = entry.value;
                return Chip(
                  label: Text(
                      'Dose ${index + 1}: $value pill${value > 1 ? 's' : ''}'),
                  onDeleted: _dosage.length > 1
                      ? () => setState(() => _dosage.removeAt(index))
                      : null,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showDosageDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Dose'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return _buildSection(
      icon: const OptimizedIcon(
        assetPath: 'assets/icons/calendar.png',
        size: 24,
        color: kPrimaryColor,
      ),
      title: 'Schedule Type',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<ReminderType>(
          value: _selectedType,
          decoration: const InputDecoration(
            labelText: 'Reminder Type',
            border: OutlineInputBorder(),
          ),
          items: ReminderType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(_getReminderTypeName(type)),
            );
          }).toList(),
          onChanged: (ReminderType? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedType = newValue;
                _updateTimesForType(newValue);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildTimesSection() {
    return _buildSection(
      icon: const Icon(Icons.access_time, size: 24, color: kPrimaryColor),
      title: 'Times',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reminder times:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _times.asMap().entries.map((entry) {
                int index = entry.key;
                Time time = entry.value;
                return Chip(
                  label: Text(DateFormat.Hm()
                      .format(DateTime(2023, 1, 1, time.hour, time.minute))),
                  onDeleted: _times.length > 1
                      ? () => setState(() => _times.removeAt(index))
                      : null,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showTimePickerDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Time'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysSection() {
    if (_selectedType != ReminderType.specificDays) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      icon: const Icon(Icons.calendar_today, size: 24, color: kPrimaryColor),
      title: 'Days of Week',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select days:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: Days.values.map((day) {
                bool isSelected = _selectedDays?.contains(day) ?? false;
                return FilterChip(
                  label: Text(_getDayName(day)),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedDays ??= [];
                      if (selected) {
                        _selectedDays!.add(day);
                      } else {
                        _selectedDays!.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDateSection() {
    return _buildSection(
      icon: const Icon(Icons.event, size: 24, color: kPrimaryColor),
      title: 'End Date',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _showEndDate,
              builder: (context, showEndDate, child) {
                return SwitchListTile(
                  title: const Text('Set End Date'),
                  subtitle: showEndDate && _endDate != null
                      ? Text('Ends on: ${DateFormat.yMMMd().format(_endDate!)}')
                      : const Text('No end date set'),
                  value: showEndDate,
                  onChanged: (bool value) {
                    _showEndDate.value = value;
                    if (!value) {
                      _endDate = null;
                    } else if (_endDate == null) {
                      _endDate = DateTime.now().add(const Duration(days: 30));
                    }
                  },
                );
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _showEndDate,
              builder: (context, showEndDate, child) {
                if (!showEndDate) return const SizedBox.shrink();

                return ElevatedButton.icon(
                  onPressed: () => _selectEndDate(),
                  icon: const Icon(Icons.calendar_month),
                  label: Text(_endDate != null ? 'Change Date' : 'Select Date'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    return _buildSection(
      icon: const Icon(Icons.toggle_on, size: 24, color: kPrimaryColor),
      title: 'Status',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Active'),
              subtitle: Text(
                  _isActive ? 'Reminder is active' : 'Reminder is inactive'),
              value: _isActive,
              onChanged: (bool value) {
                setState(() => _isActive = value);
              },
            ),
            SwitchListTile(
              title: const Text('Alert'),
              subtitle: Text(_isAlert ? 'Show alerts' : 'No alerts'),
              value: _isAlert,
              onChanged: (bool value) {
                setState(() => _isAlert = value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return _buildSection(
      icon: const Icon(Icons.note, size: 24, color: kPrimaryColor),
      title: 'Notes',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          controller: _noteController,
          decoration: const InputDecoration(
            labelText: 'Additional Notes',
            hintText: 'Enter any additional notes...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ),
    );
  }

  void _updateTimesForType(ReminderType type) {
    switch (type) {
      case ReminderType.onceDaily:
        if (_times.isEmpty) {
          _times = [const Time(8, 0)];
        } else {
          _times = [_times.first];
        }
        break;
      case ReminderType.twiceDaily:
        if (_times.length < 2) {
          _times = [
            const Time(8, 0),
            const Time(20, 0),
          ];
        } else {
          _times = _times.take(2).toList();
        }
        break;
      case ReminderType.multipleTimesDaily:
        if (_times.length < 3) {
          _times = [
            const Time(8, 0),
            const Time(14, 0),
            const Time(20, 0),
          ];
        }
        break;
      default:
        // Keep existing times for other types
        break;
    }
  }

  void _showDosageDialog() {
    int newDosage = 1;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Dose'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Number of pills:'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: newDosage > 1
                        ? () => setState(() => newDosage--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      newDosage.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: newDosage < 10
                        ? () => setState(() => newDosage++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _dosage.add(newDosage));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showTimePickerDialog() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _times.add(Time(picked.hour, picked.minute));
      });
    }
  }

  void _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  void _saveReminder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one time')),
      );
      return;
    }

    if (_selectedType == ReminderType.specificDays &&
        (_selectedDays == null || _selectedDays!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedReminder = widget.reminder.copyWith(
        medicineName: _medicineNameController.text.trim(),
        medicineLeft: _medicineLeftController.text.isNotEmpty
            ? int.parse(_medicineLeftController.text)
            : null,
        dosage: _dosage,
        type: _selectedType,
        times: _times,
        daysofWeek: _selectedDays,
        endDate: _endDate,
        isActive: _isActive,
        isAlert: _isAlert,
        note: _noteController.text.trim().isNotEmpty
            ? _noteController.text.trim()
            : null,
      );

      context.read<ReminderBloc>().add(UpdateReminder(updatedReminder));

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating reminder: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getDayName(Days day) {
    switch (day) {
      case Days.monday:
        return 'Mon';
      case Days.tuesday:
        return 'Tue';
      case Days.wednesday:
        return 'Wed';
      case Days.thursday:
        return 'Thu';
      case Days.friday:
        return 'Fri';
      case Days.saturday:
        return 'Sat';
      case Days.sunday:
        return 'Sun';
    }
  }

  String _getReminderTypeName(ReminderType type) {
    switch (type) {
      case ReminderType.onceDaily:
        return 'Once Daily';
      case ReminderType.twiceDaily:
        return 'Twice Daily';
      case ReminderType.multipleTimesDaily:
        return 'Multiple Times Daily';
      case ReminderType.intervalhours:
        return 'Every Few Hours';
      case ReminderType.intervaldays:
        return 'Every Few Days';
      case ReminderType.specificDays:
        return 'Specific Days';
      case ReminderType.cyclic:
        return 'Cyclic';
    }
  }
}
