import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddClassDialog extends StatefulWidget {
  final void Function(DateTime startTime, DateTime endTime, String meetLink)
      onSubmit;

  const AddClassDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  DateTime? startDateTime;
  DateTime? endDateTime;
  final TextEditingController linkController = TextEditingController();
  String? errorMessage;

  Future<void> _pickDateTime({
    required DateTime? initialDate,
    required Function(DateTime) onPicked,
  }) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? now),
    );

    if (pickedTime == null) return;

    final result = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onPicked(result);
  }

  void _submit() {
    final link = linkController.text.trim();

    setState(() {
      errorMessage = null;
    });

    if (startDateTime == null || endDateTime == null || link.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    if (startDateTime!.isAfter(endDateTime!)) {
      setState(() {
        errorMessage = 'Start time must be before end time';
      });
      return;
    }

    Navigator.of(context).pop();
    widget.onSubmit(startDateTime!, endDateTime!, link);
  }

  String _format(DateTime? dt) {
    if (dt == null) return 'Select time';
    return DateFormat('yyyy-MM-dd – HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen width and constrain max width of dialog
    final maxWidth = MediaQuery.of(context).size.width * 0.85;
    final dialogWidth = maxWidth > 400 ? 400.0 : maxWidth;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add a Class',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Start time picker
              _buildDateTimePicker(
                label: 'Start Time',
                dateTime: startDateTime,
                onPressed: () => _pickDateTime(
                  initialDate: startDateTime,
                  onPicked: (val) => setState(() => startDateTime = val),
                ),
              ),
              const SizedBox(height: 16),
              // End time picker
              _buildDateTimePicker(
                label: 'End Time',
                dateTime: endDateTime,
                onPressed: () => _pickDateTime(
                  initialDate: endDateTime,
                  onPicked: (val) => setState(() => endDateTime = val),
                ),
              ),
              const SizedBox(height: 20),
              // Link input with copy button
              TextField(
                controller: linkController,
                decoration: InputDecoration(
                  labelText: 'Google Meet Link',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: 'Copy link',
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      final text = linkController.text.trim();
                      if (text.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Link copied to clipboard')),
                        );
                      }
                    },
                  ),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required DateTime? dateTime,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: onPressed,
            tooltip: 'Pick $label',
          ),
        ),
        child: Text(
          dateTime == null ? 'Select time' : _format(dateTime),
          style: TextStyle(
            fontSize: 16,
            color: dateTime == null ? Colors.grey.shade600 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
