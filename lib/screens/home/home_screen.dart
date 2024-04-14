// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/models/today_market_model.dart';
import 'package:rm_official_app/screens/navigation/drawer_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/utils/fetch_upi_bank_on_load.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/heading_logo_widget.dart';

import '../../const/colors.dart';
import '../../controllers/fetch_balance_controller.dart';
import '../../provider/user_provider.dart';
import '../../widgets/item_loop_widget.dart';
import '../../widgets/phone_number_widget.dart';
import '../navigation/bottom_navigation.dart';
import '../navigation/wallet_off_bottom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MarketList> markets = [];
  bool _isLoading = false;

  void fetchGameData(bool refresh) async {
    if (!refresh) {
      setState(() {
        _isLoading = false;
      });
    }
    if (kDebugMode) {
      print('fetching');
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String apiUrl = 'https://rmmatka.com/app/api/today-markets';

    Map<String, String> body = {
      'user_id': userProvider.user.id,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('error') &&
            jsonResponse['error'] == false) {
          List<dynamic> dataList = jsonResponse['data'];

          for (var data in dataList) {
            final market = MarketList.fromJson(data);
            if (refresh) {
              for (int i = 0; i < markets.length; i++) {
                if (markets[i].id == market.id) {
                  if (markets[i].onWallet == '0' &&
                      userProvider.user.onWallet != '0') {
                    userProvider.user.onWallet = '0';
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const WalletOffBottom(),
                      ),
                      (route) => false,
                    );
                  } else if (markets[i].onWallet != '0' &&
                      userProvider.user.onWallet == '0') {
                    userProvider.user.onWallet = '1';
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const NavigationBarApp(),
                      ),
                      (route) => false,
                    );
                  }

                  markets[i] = market;
                  setState(() {});
                }
              }
            } else {
              markets.add(market);
            }
          }
        } else {
          if (kDebugMode) {
            print('Error: ${jsonResponse['message']}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
    if (!refresh) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void run() {
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      fetchGameData(true);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchGameData(false);

    // run();

    fetchBalance(context);
    getBankDetails(context);
    getUpi(context);
  }

  Future<void> addPollToFirestore(
      String name, String status, Map<int, int> initialOptions) async {
    try {
      Map<String, dynamic> optionsMap = initialOptions.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      Map<String, dynamic> data = {
        'name': name.toUpperCase(),
        'status': status,
        'options': optionsMap,
        'timestamp': Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection('polls').add(data);
      if (kDebugMode) {
        print('Poll added to Firestore successfully.');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error adding poll to Firestore: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.blueGrey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
              'Confirm Exit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            content: const Text(
              'Do you want to exit the app?',
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
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
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

        return exit;
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        drawer: const NavBar(),
        appBar: AppBar(
            actions: [
              if (userProvider.user.onWallet != '0')
                ElevatedButton.icon(
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.redType),
                    ),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.wallet,
                      color: Colors.white,
                    ),
                    label: Text(
                      userProvider.user.balance.toString(),
                      style: const TextStyle(color: Colors.white),
                    )),
            ],
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              'WELCOME ${userProvider.user.name}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            backgroundColor: AppColors.redType),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const HeadingLogo(),
                if (userProvider.user.onWallet != '0')
                  const SizedBox(
                    height: 12,
                  ),
                if (userProvider.user.onWallet != '0')
                  const SizedBox(
                    height: 16,
                  ),
                if (userProvider.user.onWallet != '0') const PhoneNumber(),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 18,
                ),
                Image.asset('assets/images/gifs/live_result.gif'),
                const SizedBox(
                  height: 12,
                ),
                if (markets.isEmpty) const CircularProgressIndicator(),
                if (!_isLoading)
                  for (int i = 0; i < markets.length; i++)
                    ItemLoop(
                      market: markets[i],
                    ),
                if (markets.isNotEmpty) const BottomContact()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
