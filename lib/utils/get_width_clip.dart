import 'package:flutter/material.dart';

class ParallelogramBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height) // Bottom-left corner
      ..lineTo(size.width * 0.2, 0) // Top-left corner
      ..lineTo(size.width, 0) // Top-right corner
      ..lineTo(size.width * 0.8, size.height) // Bottom-right corner
      ..close(); // Close the path to form a parallelogram

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
