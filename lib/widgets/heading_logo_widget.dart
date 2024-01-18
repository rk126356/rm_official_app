import 'package:flutter/material.dart';

class HeadingLogo extends StatelessWidget {
  const HeadingLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 0.5,
        ),
        Image.asset('assets/images/rm_logo_banner.jpg'),
      ],
    );
  }
}
