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

class VerificationDialog2 extends StatelessWidget {
  final bool isSuccess;
  final VoidCallback? onClosed;

  const VerificationDialog2({
    Key? key,
    required this.isSuccess,
    this.onClosed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isSuccess ? 'Verification Successful' : 'Verification Failed',
        style: TextStyle(
          color: isSuccess ? Colors.green : Colors.red,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.cancel,
            color: isSuccess ? Colors.green : Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            isSuccess
                ? 'Your location has been verified successfully. You will be marked present'
                : 'Your failed to be at the correct location. You will be marked absent',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (onClosed != null) {
              onClosed!();
            }
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
