// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class VerificationDialog extends StatelessWidget {
  final bool isSuccess;
  const VerificationDialog({
    super.key,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Verification')),
      content: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                child: Icon(
                  isSuccess ? Icons.check_circle_rounded : Icons.cancel,
                  size: 30,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isSuccess
                  ? const Text('Verification successful!')
                  : const Text('Verification failed!'),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
