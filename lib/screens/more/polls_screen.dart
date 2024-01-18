import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:http/http.dart' as http;

import '../../models/polls_model.dart';
import '../../models/today_market_model.dart';
import '../../provider/user_provider.dart';
import 'widgets/show_open_close_popup_widget.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({Key? key}) : super(key: key);

  @override
  State<PollsScreen> createState() => _PollsScreenState();
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

  void fetchGameData() async {
    setState(() {
      _isLoading = true;
    });
    if (kDebugMode) {
      print('fetching');
    }
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

            print(market.marketName);

            // Map<int, int> initialOptions = {
            //   0: 0,
            //   1: 0,
            //   2: 0,
            //   3: 0,
            //   4: 0,
            //   5: 0,
            //   6: 0,
            //   7: 0,
            //   8: 0,
            //   9: 0,
            // };
            // addPollToFirestore(market.marketName, 'open', initialOptions);
            // addPollToFirestore(market.marketName, 'close', initialOptions);

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
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.redType,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Polls',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              .map((DocumentSnapshot document) =>
                  PollModel.fromMap(document.data() as Map<String, dynamic>))
              .toList();

          for (int i = 0; i < markets.length; i++) {
            for (int j = 0; j < polls.length; j++) {
              if (polls[j].name == markets[i].marketName) {
                polls[j].revealed = !markets[i].isOpen;
              }
            }
          }

          return ListView.builder(
            itemCount: polls.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(polls[index].name),
                    trailing: const Icon(Icons.poll),
                    onTap: () {
                      showPopup(context, polls[index]);
                    },
                  ),
                  const Divider(
                    color: AppColors.opBlueType,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
