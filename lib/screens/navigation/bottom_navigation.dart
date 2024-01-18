// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/screens/bid/bid_history_screen.dart';
import 'package:rm_official_app/screens/home/home_screen.dart';
import 'package:rm_official_app/screens/profile/profile_screen.dart';
import 'package:rm_official_app/screens/transaction/transaction_history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../provider/user_provider.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../auth/send_otp_screen.dart';

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key, this.isHistory});

  @override
  State<NavigationBarApp> createState() => _NavigationBarAppState();

  final bool? isHistory;
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  int _selectedIndex = 0;

  void logout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String apiUrl = 'https://rmmatka.com/ravan/api/logout';

    Map<String, dynamic> body = {
      'id': userProvider.user.id,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const SendOtpScreen(),
          ),
          (route) => false,
        );

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setIsLoggedIn(false);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        if (kDebugMode) {
          print('Logged out');
        }
      } else {
        showCoolErrorSnackbar(context, 'Check your internet connection');
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void showLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text(
          'Confirm Logout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        content: const Text(
          'Do you want to logout?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'No',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          TextButton(
            onPressed: logout,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Yes',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BidHistoryScreen(
      isRoute: false,
    ),
    TransactionHistoryScreen(
      isRoute: false,
    ),
    ProfileScreen(
      isRoute: false,
    )
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      showLogout();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.isHistory != null) {
      _selectedIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.white,
        backgroundColor: AppColors.redType,
        iconSize: 24,
        onTap: _onItemTapped,
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
            icon: Icon(Icons.logout),
            label: 'LOGOUT',
          ),
        ],
      ),
    );
  }
}
