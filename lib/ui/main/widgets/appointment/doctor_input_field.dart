part of '../widgets.dart';

class DoctorInputField extends StatefulWidget {
  final Function(String) onDoctorChanged;
  final Function(String) onNoteChanged;
  final Doctor? doctor;
  final String? note;
  const DoctorInputField({
    super.key,
    required this.onDoctorChanged,
    required this.onNoteChanged,
    this.doctor,
    this.note,
  });

  @override
  DoctorInputFieldState createState() => DoctorInputFieldState();
}

class DoctorInputFieldState extends State<DoctorInputField>
    with TickerProviderStateMixin {
  final TextEditingController _doctorController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.doctor != null) {
      _doctorController.text = widget.doctor!.name;
      _isExpanded = true;
    }
    if (widget.note != null && widget.note!.isNotEmpty) {
      _isExpanded = true;
    }
    _doctorController.addListener(() {
      setState(() {
        _isExpanded = _doctorController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            TextFormField(
              controller: _doctorController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(8),
                hintText: 'Enter doctor name',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: widget.onDoctorChanged,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? TextFormField(
                      maxLines: 4,
                      initialValue: widget.note,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'Enter note',
                      ),
                      onChanged: widget.onNoteChanged,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _doctorController.dispose();
    super.dispose();
  }
}
