// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/screens/home/home_screen.dart';
import 'package:rm_official_app/screens/profile/profile_screen.dart';

import '../more/forum_screen.dart';
import '../more/polls_screen.dart';

class WalletOffBottom extends StatefulWidget {
  const WalletOffBottom({
    super.key,
  });

  @override
  State<WalletOffBottom> createState() => _WalletOffBottomState();
}

class _WalletOffBottomState extends State<WalletOffBottom> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ProfileScreen(isRoute: false),
    ForumScreen(
      isRoute: false,
    ),
    PollsScreen(isRoute: false)
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.white,
        backgroundColor: AppColors.redType,
        iconSize: 24,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),
            label: 'Polls',
          ),
        ],
      ),
    );
  }
}
