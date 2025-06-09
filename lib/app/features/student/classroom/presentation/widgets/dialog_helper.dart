import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogHelper {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SizedBox(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Marking attendance...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showSuccessDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onSuccess,
  }) {
    final bool isMeetLink = message.contains('meet');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isMeetLink ? 'Attendance Marked!' : 'Success'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isMeetLink
                    ? 'You have been marked present. Join the class using the link below:'
                    : 'You are in wrong location. You will be marked absent!',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: message));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Message copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSuccess();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Something went wrong. Try again'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void dismissDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static void showAttendanceConfirmation({
    required BuildContext context,
    required String classId,
    required Function(bool) onMarkAttendance,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark Attendance'),
          content: const Text('Are you present in the class?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onMarkAttendance(false);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Absent'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onMarkAttendance(true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: const Text('Present'),
            ),
          ],
        );
      },
    );
  }
}
