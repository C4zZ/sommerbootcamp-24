import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Chat Message Bubble
class MessageBubble extends StatelessWidget {
  /// constructor
  const MessageBubble({
    required this.message,
    required this.isSender,
    super.key,
  });

  /// message text
  final String message;

  /// is sender of this message
  final bool isSender;

  Widget _senderBubble() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.cyan[900],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          CustomPaint(painter: _CustomShape(Colors.cyan[900]!)),
        ],
      ),
    );
  }

  Widget _receiverBubble() {
    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: CustomPaint(
              painter: _CustomShape(Colors.grey[300]!),
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18, left: 18, top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 30),
          if (isSender) _senderBubble() else _receiverBubble(),
        ],
      ),
    );
  }
}

class _CustomShape extends CustomPainter {
  _CustomShape(this.bgColor);
  final Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = bgColor;

    final path = Path()
      ..lineTo(-5, 0)
      ..lineTo(0, 10)
      ..lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
