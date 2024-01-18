import 'package:flutter/material.dart';

class WhiteSideHeading extends StatelessWidget {
  const WhiteSideHeading({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
          decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(width: 1, color: Colors.white)),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ],
    );
  }
}
