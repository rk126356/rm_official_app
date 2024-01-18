import 'package:flutter/material.dart';

class RbgSmallBoxText extends StatelessWidget {
  const RbgSmallBoxText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 28,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Color.fromARGB(255, 209, 169, 255), Colors.blue],
          begin: Alignment.bottomLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
