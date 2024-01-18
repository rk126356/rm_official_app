import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../const/colors.dart';
import '../provider/user_provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return AppBar(
      centerTitle: true,
      actions: [
        ElevatedButton.icon(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(AppColors.redType),
          ),
          onPressed: () {},
          icon: const Icon(
            Icons.wallet,
            color: Colors.white,
          ),
          label: Text(
            userProvider.user.balance.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      backgroundColor: AppColors.redType,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
