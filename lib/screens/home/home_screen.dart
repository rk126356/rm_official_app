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
import 'package:rm_official_app/widgets/heading_logo_widget.dart';

import '../../const/colors.dart';
import '../../controllers/fetch_balance_controller.dart';
import '../../provider/user_provider.dart';
import '../../widgets/item_loop_widget.dart';
import '../../widgets/phone_number_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<void> fetchHomeData() async {
  String apiUrl = 'https://rmmatka.com/ravan/api/home-page';

  try {
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('error') && jsonResponse['error'] == false) {
        final data = jsonResponse['data'];

        if (kDebugMode) {
          print(data);
        }

        if (kDebugMode) {
          print('Contact: ${data['contact']['contact_no']}');
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
}

class _HomeScreenState extends State<HomeScreen> {
  List<MarketList> markets = [];
  bool _isLoading = false;

  void fetchGameData(bool refresh) async {
    setState(() {
      _isLoading = true;
    });
    if (kDebugMode) {
      print('fetching');
    }
    fetchBalance(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String apiUrl = 'https://rmmatka.com/ravan/api/today-markets';

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
                  markets[i] = market;
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
    setState(() {
      _isLoading = false;
    });
  }

  void run() {
    Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      fetchGameData(true);
    });
  }

  @override
  void initState() {
    super.initState();
    // fetchHomeData();
    fetchGameData(false);
    // run();

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
      print('Poll added to Firestore successfully.');
    } catch (error) {
      print('Error adding poll to Firestore: $error');
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Map<int, int> initialOptions = {
        //       0: 0,
        //       1: 0,
        //       2: 0,
        //       3: 0,
        //       4: 0,
        //       5: 0,
        //       6: 0,
        //       7: 0,
        //       8: 0,
        //       9: 0,
        //     };
        //     addPollToFirestore('avanti day', 'close', initialOptions);
        //   },
        //   child: Icon(Icons.add),
        // ),
        backgroundColor: AppColors.primaryColor,
        drawer: const NavBar(),
        appBar: AppBar(
            actions: [
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
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(
                  height: 16,
                ),
                const PhoneNumber(),
                const SizedBox(
                  height: 16,
                ),
                // Column(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: InkWell(
                //         onTap: () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => const AddFundsScreen(),
                //             ),
                //           );
                //         },
                //         child: Image.asset(
                //           'assets/images/gifs/add_funds.gif',
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: InkWell(
                //         onTap: () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => const WithdrawFundsScreen(),
                //             ),
                //           );
                //         },
                //         child: Image.asset(
                //           'assets/images/gifs/withdraw_funds.gif',
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                const SizedBox(
                  height: 18,
                ),
                // Container(
                //   width: 320,
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.centerLeft,
                //       end: Alignment.centerRight,
                //       colors: [
                //         Colors.red.withOpacity(0.5),
                //         Colors.red,
                //         Colors.red,
                //         Colors.red,
                //         Colors.red,
                //         Colors.red,
                //         Colors.red.withOpacity(0.5)
                //       ],
                //     ),
                //   ),
                //   child: const Padding(
                //     padding: EdgeInsets.symmetric(vertical: 16.0),
                //     child: Center(
                //       child: Text(
                //         'Live Result',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 24.0,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Image.asset('assets/images/gifs/live_result.gif'),
                const SizedBox(
                  height: 12,
                ),
                if (_isLoading) const CircularProgressIndicator(),
                if (!_isLoading)
                  for (int i = 0; i < markets.length; i++)
                    ItemLoop(
                      market: markets[i],
                    ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
