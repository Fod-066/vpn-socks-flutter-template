import 'package:flutter/material.dart';

class GridLine extends StatelessWidget {
  const GridLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: GridPainter(),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final verticalLineSpacing = size.width / 26;
    final horizontalLineSpacing = size.height / 61;
    final linePaint = Paint()..color = Colors.black12;
    for (int i = 0; i < 25; i++) {
      final x = (i + 1) * verticalLineSpacing;
      final startPoint = Offset(x, 0);
      final endPoint = Offset(x, size.height);
      canvas.drawLine(startPoint, endPoint, linePaint);
    }
    for (int i = 0; i < 60; i++) {
      final y = (i + 1) * horizontalLineSpacing;
      final startPoint = Offset(0, y);
      final endPoint = Offset(size.width, y);
      canvas.drawLine(startPoint, endPoint, linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
