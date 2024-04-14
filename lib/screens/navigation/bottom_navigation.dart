// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/screens/bid/bid_history_screen.dart';
import 'package:rm_official_app/screens/home/home_screen.dart';
import 'package:rm_official_app/screens/more/forum_screen.dart';
import 'package:rm_official_app/screens/more/polls_screen.dart';
import 'package:rm_official_app/screens/profile/profile_screen.dart';
import 'package:rm_official_app/screens/transaction/transaction_history_screen.dart';

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key, this.isHistory});

  @override
  State<NavigationBarApp> createState() => _NavigationBarAppState();

  final bool? isHistory;
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BidHistoryScreen(
      isRoute: false,
    ),
    TransactionHistoryScreen(
      isRoute: false,
    ),
    ForumScreen(
      isRoute: false,
    ),
    PollsScreen(isRoute: false)
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isHistory != null) {
      _selectedIndex = 1;
    }
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
            icon: Icon(Icons.analytics),
            label: 'BID HISTORY',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'HISTORY',
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
