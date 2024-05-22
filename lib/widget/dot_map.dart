import 'package:flutter/material.dart';

class PixelMap extends StatelessWidget {
  final int rows;
  final int cols;
  final List<List<bool>> map;

  const PixelMap({
    super.key,
    required this.rows,
    required this.cols,
    required this.map,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(cols * 20.0, rows * 20.0),
      painter: _PixelMapPainter(rows, cols, map),
    );
  }
}

class _PixelMapPainter extends CustomPainter {
  final int rows;
  final int cols;
  final List<List<bool>> map;

  _PixelMapPainter(this.rows, this.cols, this.map);

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        if (map[y][x]) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellWidth, y * cellHeight, cellWidth, cellHeight),
            Paint()..color = Colors.black,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_PixelMapPainter oldDelegate) {
    return oldDelegate.map != map || oldDelegate.rows != rows || oldDelegate.cols != cols;
  }
}
