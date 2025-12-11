import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/network/network_service.dart';
import 'package:medicine_reminder/core/constant/url.dart';
import 'package:medicine_reminder/helpers/helpers.dart';

class TakeMedicine extends StatefulWidget {
  final String medicineName;
  final int? dosage;
  final String scheduledTime;
  final int reminderId;
  final int? logId;

  const TakeMedicine({
    required this.medicineName,
    this.dosage = 0,
    required this.scheduledTime,
    required this.reminderId,
    this.logId,
    super.key,
  });

  @override
  State<TakeMedicine> createState() => _TakeMedicineState();
}

class _TakeMedicineState extends State<TakeMedicine> {
  bool _isLoading = false;
  bool _triggerDispense = false;
  final NetworkService _networkService = NetworkService();

  Future<void> _confirmMedicine(bool taken) async {
    if (widget.logId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Log ID not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final body = {
        "log_id": widget.logId,
        "confirmation": taken,
        "trigger_dispense": _triggerDispense,
      };

      final response = await _networkService.post(
        confirmMedicineUrl, // Update with your actual endpoint
        body: body,
      );

      if (response.isSuccess) {
        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              taken ? 'Medicine confirmed as taken!' : 'Medicine skipped',
            ),
            backgroundColor: taken ? Colors.green : Colors.orange,
          ),
        );

        // Navigate back
        Navigator.of(context).pop(true);
      } else {
        throw Exception(response.error ?? 'Failed to confirm medicine');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Medicine'),
        // backgroundColor:
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Medicine Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication,
                        size: 80,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  spacerHeight(20),

                  // Medicine Name
                  Center(
                    child: Text(
                      widget.medicineName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  spacerHeight(10),

                  // Dosage
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Dosage: ${widget.dosage} pill${widget.dosage! > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  spacerHeight(20),

                  // Time Info Card
                  Container(
                    // elevation: 2,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: kPrimaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Scheduled Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: kPrimaryColor,
                            thickness: 1,
                          ),
                          Text(
                            widget.scheduledTime,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  spacerHeight(20),

                  // Dispense Option
                  Container(
                    // elevation: 2,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(12),
                    // ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Trigger Dispense',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Automatically dispense medicine from device',
                        style: TextStyle(fontSize: 13),
                      ),
                      value: _triggerDispense,
                      onChanged: (value) {
                        setState(() {
                          _triggerDispense = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                      secondary: Icon(
                        Icons.medical_services,
                        color: _triggerDispense ? kPrimaryColor : Colors.grey,
                      ),
                    ),
                  ),
                  spacerHeight(20),

                  // Confirm Button
                  ElevatedButton(
                    onPressed: () => _confirmMedicine(true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'I Took This Medicine',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  spacerHeight(12),

                  // Skip Button
                  OutlinedButton(
                    onPressed: () => _confirmMedicine(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel, size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Skip This Dose',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  spacerHeight(20),

                  // Info Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Confirming will record that you took your medicine at this time. Skipping will mark this dose as missed.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade900,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.logId != null) ...[
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Log ID: ${widget.logId}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
