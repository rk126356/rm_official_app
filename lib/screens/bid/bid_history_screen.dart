// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/models/single_bid_history_model.dart';
import 'package:rm_official_app/widgets/all_bids_with_delete_popup_widget.dart';
import 'package:rm_official_app/widgets/app_bar_widget.dart';

import '../../const/colors.dart';
import '../../controllers/delete_bid_controller.dart';
import '../../controllers/fetch_bid_history_controller.dart';
import '../../models/bid_history_model.dart';
import '../../provider/user_provider.dart';
import '../../widgets/all_bids_popup_widget.dart';
import '../../widgets/bottom_contact_widget.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../../widgets/heading_logo_widget.dart';
import '../../widgets/heading_title_widget.dart';
import '../../widgets/success_snackbar_widget.dart';
import '../../widgets/white_side_heading_widget.dart';
import '../navigation/drawer_nav_bar.dart';

class BidHistoryScreen extends StatefulWidget {
  const BidHistoryScreen({super.key, required this.isRoute, this.type});

  @override
  State<BidHistoryScreen> createState() => _BidHistoryScreenState();
  final bool isRoute;
  final String? type;
}

class _BidHistoryScreenState extends State<BidHistoryScreen> {
  String startDate = '2024-1-6';
  String endDate = '2024-1-6';
  String type = '1';
  String table = 'bids';
  String gameType = '1';
  bool _isLoading = false;
  bool _isButtonLoading = false;
  List<BidHistory> list = [];
  List<SingleBidHistory> histories = [];

  void fetch() async {
    histories.clear();
    list.clear();
    setState(() {
      _isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    list = await fetchHistory(
        userProvider.user.id, startDate, endDate, type, table, gameType);
    filterHistory();
    setState(() {
      _isLoading = false;
    });
  }

  void filterHistory() {
    setState(() {
      _isLoading = true;
    });
    Map<String, List<BidHistory>> historyMap = {};

    for (BidHistory history in list) {
      if (!historyMap.containsKey(history.ticketId)) {
        historyMap[history.ticketId] = [];
      }
      historyMap[history.ticketId]!.add(history);
    }

    histories = historyMap.entries.map((entry) {
      String ticketId = entry.key;
      List<BidHistory> allHistory = entry.value;

      bool deleteStatus = allHistory.first.deleteStatus;

      return SingleBidHistory(
        ticketId: [ticketId],
        deleteStatus: deleteStatus,
        allHistory: allHistory,
      );
    }).toList();
    filterAgain();
  }

  void filterAgain() {
    Map<String, List<BidHistory>> groupedHistories = {};

    for (final history in histories) {
      for (final h in history.allHistory) {
        String createdAt = h.createdAt;

        if (!groupedHistories.containsKey(createdAt)) {
          groupedHistories[createdAt] = [];
        }

        groupedHistories[createdAt]!.add(h);
      }
    }

    List<SingleBidHistory> updatedHistories = [];
    groupedHistories.forEach((createdAt, historyList) {
      SingleBidHistory singleHistory = SingleBidHistory(
        ticketId: historyList.map((h) => h.ticketId).toList(),
        deleteStatus: historyList.first.deleteStatus,
        allHistory: historyList,
      );
      updatedHistories.add(singleHistory);
    });

    setState(() {
      histories = updatedHistories;
      _isLoading = false;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        startDate = DateFormat('yyyy-M-d').format(picked);
      });
      fetch();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        endDate = DateFormat('yyyy-M-d').format(picked);
      });
      fetch();
    }
  }

  void _showPopup(BuildContext context, SingleBidHistory history) {
    showDialog(
      context: context,
      builder: (_) => AllBidsPopup(
        histories: history.allHistory,
        name: history.allHistory.first.bidDate,
      ),
    );
  }

  void removeBid(SingleBidHistory bid) async {
    setState(() {
      _isButtonLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (bid.ticketId.first == bid.allHistory.last.ticketId) {
      bool deleted =
          await deleteBid(bid.allHistory.first, userProvider.user.id);
      if (deleted) {
        showCoolSuccessSnackbar(context, 'Bid deleted successfully');
        histories.removeWhere((b) => b.ticketId == bid.ticketId);
      } else {
        showCoolErrorSnackbar(context, 'Error');
      }
    } else {
      showDialog(
        context: context,
        builder: (_) => AllBidsWithDelete(
          histories: bid.allHistory,
          name: bid.allHistory.first.bidDate,
        ),
      );
    }

    setState(() {
      _isButtonLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    startDate = DateFormat('yyyy-M-d').format(DateTime.now());
    endDate = DateFormat('yyyy-M-d').format(DateTime.now());
    if (widget.type != null) {
      type = widget.type!;
    }
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      drawer: widget.isRoute ? null : const NavBar(),
      appBar: AppBarWidget(
        title: 'Welcome: ${userProvider.user.name}',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadingLogo(),
            const SizedBox(
              height: 18,
            ),
            Image.asset('assets/images/gifs/bid_history.gif'),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _selectStartDate(context),
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'Start Date\n$startDate',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectEndDate(context),
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'End Date\n$endDate',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            OutlinedButton(
              onPressed: () {
                fetch();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              child: const Text(
                'SUBMIT',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            HeadingTitle(
              title: startDate == endDate ? 'TODAY' : '$startDate to $endDate',
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Time & ID',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('MARKET NAME',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('VIEW',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('DELETE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                )
              ],
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            if (histories.isEmpty && !_isLoading)
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('No History'),
              ),
            if (histories.isNotEmpty && !_isLoading)
              for (int i = 0; i < histories.length; i++) loopPart(i, context),
            Container(
              decoration: const BoxDecoration(
                  border: BorderDirectional(
                      top: BorderSide(
                color: Colors.blueGrey,
              ))),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                'Ticket can be Cancelled Only Before 15 Mins Prior To Result Timing',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const BottomContact(),
          ],
        ),
      ),
    );
  }

  Column loopPart(int i, BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: BorderDirectional(
                  top: BorderSide(
            color: Colors.blueGrey,
          ))),
          child: Container(
            height: 60,
            color: AppColors.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('hh:mm a').format(
                              DateFormat('dd-MM-yyyy hh:mm a').parse(
                                  histories[i].allHistory.first.createdAt)),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          histories[i].ticketId.first,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.blueGrey,
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${histories[i].allHistory.first.marketName} (${histories[i].allHistory.first.session.toUpperCase()})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          histories[i].allHistory.first.type.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.blueGrey,
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 4, top: 4, bottom: 4, right: 8),
                    child: InkWell(
                      onTap: () {
                        _showPopup(context, histories[i]);
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.remove_red_eye),
                          Text(
                            'VIEW',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.blueGrey,
                ),
                _isButtonLoading
                    ? const CircularProgressIndicator()
                    : Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4, top: 4, bottom: 4, right: 8),
                          child: InkWell(
                            onTap: () {
                              if (histories[i].deleteStatus) {
                                removeBid(histories[i]);
                              } else {
                                showCoolErrorSnackbar(
                                    context, 'Time is closed');
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!histories[i].deleteStatus)
                                  const Icon(Icons.lock_clock),
                                if (histories[i].deleteStatus)
                                  const Icon(Icons.delete),
                                if (!histories[i].deleteStatus)
                                  const Text(
                                    'TIMES UP',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                if (histories[i].deleteStatus)
                                  const Text(
                                    'DELETE',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        )
      ],
    );
  }
}
