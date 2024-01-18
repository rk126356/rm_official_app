import 'package:flutter/material.dart';

import '../const/colors.dart';

class WelcomeBoxHeading extends StatelessWidget {
  const WelcomeBoxHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.redType,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text(
            'WELCOME TO RM OFFICIAL APP',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: AppColors.yellowType,
              fontStyle: FontStyle.italic,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/rm_logo.png',
                width: 70,
              ),
              const SizedBox(
                width: 12,
              ),
              const Column(
                children: [
                  Text(
                    'RM GROUP !! RM !!',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  Text(
                    'Amit Bhai',
                    style: TextStyle(fontSize: 18, color: Colors.yellow),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Image.asset(
                'assets/images/rm_logo.png',
                width: 70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
