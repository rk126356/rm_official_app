// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/screens/auth/login_screen.dart';
import 'package:rm_official_app/screens/bid/bid_history_screen.dart';
import 'package:rm_official_app/screens/funds/add_funds_screen.dart';
import 'package:rm_official_app/screens/funds/withdraw_accounts_screen.dart';
import 'package:rm_official_app/screens/funds/withdraw_funds_screen.dart';
import 'package:rm_official_app/screens/more/forum_screen.dart';
import 'package:rm_official_app/screens/more/help_and_guide_screen.dart';
import 'package:rm_official_app/screens/more/market_rates_screen.dart';
import 'package:rm_official_app/screens/more/polls_screen.dart';
import 'package:rm_official_app/screens/navigation/bottom_navigation.dart';
import 'package:rm_official_app/screens/profile/change_password_screen.dart';
import 'package:rm_official_app/screens/profile/profile_screen.dart';
import 'package:rm_official_app/screens/transaction/transaction_history_screen.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../const/colors.dart';
import '../../provider/user_provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void logout() async {
    final userProvider = Provider.of<UserProvider>(context);
    String apiUrl = 'https://rmmatka.com/app/api/logout';

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
            builder: (context) => const LoginScreen(
              refresh: true,
            ),
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Drawer(
      backgroundColor: AppColors.primaryColor,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userProvider.user.name),
            accountEmail: Text(userProvider.user.mobile),
            currentAccountPicture: Image.asset('assets/images/rm_logo.png'),
            decoration: const BoxDecoration(
              color: AppColors.blueType,
            ),
          ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const NavigationBarApp(),
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(
              Icons.person,
            ),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(
                    isRoute: true,
                  ),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.white30,
          ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              leading: const Icon(
                Icons.add,
              ),
              title: const Text('Add Funds'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddFundsScreen(),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              leading: const Icon(
                Icons.upcoming,
              ),
              title: const Text('Withdraw Funds'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WithdrawFundsScreen(),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              leading: const Icon(
                Icons.account_balance,
              ),
              title: const Text('Withdraw Accounts'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WithdrawAccountsScreen(),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            const Divider(
              color: Colors.white30,
            ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              leading: const Icon(
                Icons.analytics,
              ),
              title: const Text('Bid History'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BidHistoryScreen(
                      isRoute: true,
                    ),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              leading: const Icon(
                Icons.currency_rupee,
              ),
              title: const Text('Win History'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BidHistoryScreen(
                      isRoute: true,
                      type: '2',
                    ),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              leading: const Icon(
                Icons.payment,
              ),
              title: const Text('Transaction History'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TransactionHistoryScreen(
                      isRoute: true,
                    ),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            const Divider(
              color: Colors.white30,
            ),
          ListTile(
            title: const Text('Change Password'),
            leading: const Icon(Icons.lock),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              title: const Text('Market Rates'),
              leading: const Icon(Icons.star_rate_sharp),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MarketRatesScreen(),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              title: const Text('Opinion Poll'),
              leading: const Icon(Icons.poll),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PollsScreen(
                      isRoute: true,
                    ),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              title: const Text('Forums'),
              leading: const Icon(Icons.forum),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ForumScreen(
                      isRoute: true,
                    ),
                  ),
                );
              },
            ),
          if (userProvider.user.onWallet != '0')
            ListTile(
              title: const Text('Help and Guide'),
              leading: const Icon(Icons.help),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HelpAndGuideScreen(),
                  ),
                );
              },
            ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: showLogout,
          ),
        ],
      ),
    );
  }
}
