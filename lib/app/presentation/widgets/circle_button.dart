import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  final VoidCallback onPressed;

  const CircleButton({super.key, required this.onPressed});

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onPressed();
        },
        onHover: (hovering) {
          setState(() {
            _isHovering = hovering;
          });
        },
        onHighlightChanged: (isPressed) {
          setState(() {
            _isPressed = isPressed;
          });
        },
        borderRadius: BorderRadius.circular(30),
        child: AnimatedScale(
          scale: _isPressed ? 0.9 : 1.0, // Slightly shrink on press
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isHovering ? Colors.green[300] : Colors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
