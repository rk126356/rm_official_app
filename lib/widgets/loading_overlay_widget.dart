import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/rm_logo.png',
            height: 250,
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 280,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(22))),
            child: Image.asset('assets/images/loading3.gif'),
          ),
        ],
      ),
    );
  }
}
