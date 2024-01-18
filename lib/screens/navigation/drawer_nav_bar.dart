import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/screens/auth/send_otp_screen.dart';
import 'package:rm_official_app/screens/bid/bid_history_screen.dart';
import 'package:rm_official_app/screens/funds/add_funds_screen.dart';
import 'package:rm_official_app/screens/funds/withdraw_accounts_screen.dart';
import 'package:rm_official_app/screens/funds/withdraw_funds_screen.dart';
import 'package:rm_official_app/screens/more/forum_screen.dart';
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
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SendOtpScreen(),
          ),
        );
        // ignore: use_build_context_synchronously
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setIsLoggedIn(false);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        if (kDebugMode) {
          print('Logged out');
        }
      } else {
        // ignore: use_build_context_synchronously
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
          const Divider(
            color: Colors.white30,
          ),
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
          ListTile(
            title: const Text('Opinion Poll'),
            leading: const Icon(Icons.poll),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PollsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Forums'),
            leading: const Icon(Icons.forum),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ForumScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Help and Guide'),
            leading: const Icon(Icons.help),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              logout();
            },
          ),
        ],
      ),
    );
  }
}
