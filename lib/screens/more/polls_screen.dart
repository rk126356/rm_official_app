import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/heading_logo_widget.dart';

import '../../models/polls_model.dart';
import '../../models/today_market_model.dart';
import '../../provider/user_provider.dart';
import '../../widgets/app_bar_widget.dart';
import '../navigation/drawer_nav_bar.dart';
import 'widgets/show_open_close_popup_widget.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({Key? key, required this.isRoute}) : super(key: key);

  @override
  State<PollsScreen> createState() => _PollsScreenState();
  final bool isRoute;
}

class _PollsScreenState extends State<PollsScreen> {
  List<MarketList> markets = [];

  bool _isLoading = false;

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
      // Handle the error as needed
    }
  }

  Future<void> deleteFromFirebase() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Get all documents in the 'polls' collection
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('polls').get();

      // Iterate through each document and delete it
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        await doc.reference.delete();
      }

      reset();
      print('Polls deleted from Firestore successfully.');
    } catch (error) {
      print('Error deleting polls from Firestore: $error');
      // Handle the error as needed
    }
  }

  void reset() async {
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

            Map<int, int> initialOptions = {
              0: 0,
              1: 0,
              2: 0,
              3: 0,
              4: 0,
              5: 0,
              6: 0,
              7: 0,
              8: 0,
              9: 0,
            };
            addPollToFirestore(market.marketName, 'open', initialOptions);
            addPollToFirestore(market.marketName, 'close', initialOptions);
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
    fetchGameData();
  }

  void fetchGameData() async {
    setState(() {
      _isLoading = true;
    });
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

            markets.add(market);
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

  @override
  void initState() {
    super.initState();
    fetchGameData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      drawer: widget.isRoute ? null : const NavBar(),
      appBar: const AppBarWidget(
        title: 'POLLS',
      ),
      floatingActionButton: userProvider.user.mobile != '9506798536'
          ? null
          : _isLoading
              ? null
              : IconButton.filled(
                  onPressed: deleteFromFirebase,
                  icon: const Icon(Icons.restart_alt)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('polls')
                  .where('status', isEqualTo: 'open')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<PollModel> polls = snapshot.data!.docs
                    .map((DocumentSnapshot document) => PollModel.fromMap(
                        document.data() as Map<String, dynamic>))
                    .toList();

                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);

                for (int i = 0; i < markets.length; i++) {
                  for (int j = 0; j < polls.length; j++) {
                    if (polls[j].name == markets[i].marketName) {
                      polls[j].revealed = !markets[i].isOpen;

                      if (markets[i].timeLeftCloseTime != 'TIMER OVER' &&
                          !markets[i].isOpen &&
                          markets[i].timeLeftCloseTime != 'RESULT DECLARED') {
                        polls.remove(polls[j]);
                      }
                    }
                  }
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const HeadingLogo(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: AppColors.opBlueType,
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Text(
                            "Welcome to our daily Matka Market Opinion Poll! Cast your vote for the number you believe will emerge as today's Matka winner. Your input matters, so choose wisely and let's see which number gains the most support! Remember, luck favors the bold – make your pick now! 🎲",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.blueType,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Text(
                          DateFormat('dd-MMM-yyyy')
                              .format(DateTime.now())
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      userProvider.user.onWallet == '0'
                          ? const Padding(
                              padding: EdgeInsets.all(38.0),
                              child: Text('Coming Soon...'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: polls.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color:
                                      const Color.fromARGB(255, 249, 238, 216),
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(
                                      polls[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: const Icon(Icons.poll),
                                    onTap: () {
                                      showPopup(context, polls[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                      const BottomContact()
                    ],
                  ),
                );
              },
            ),
    );
  }
}
