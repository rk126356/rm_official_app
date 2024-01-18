// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/models/bid_history_model.dart';
import 'package:rm_official_app/screens/bid/bid_history_screen.dart';
import 'package:rm_official_app/screens/navigation/bottom_navigation.dart';

import '../controllers/delete_bid_controller.dart';
import '../provider/user_provider.dart';
import 'error_snackbar_widget.dart';
import 'success_snackbar_widget.dart';

class BidHistoryLoopDelete extends StatefulWidget {
  const BidHistoryLoopDelete({
    Key? key,
    required this.history,
  }) : super(key: key);

  final BidHistory history;

  @override
  State<BidHistoryLoopDelete> createState() => _BidHistoryLoopDeleteState();
}

class _BidHistoryLoopDeleteState extends State<BidHistoryLoopDelete> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    DateTime createdAtDateTime =
        DateFormat('dd-MM-yyyy hh:mm a').parse(widget.history.createdAt);

    String formattedDate = DateFormat('hh:mm a').format(createdAtDateTime);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'WIN',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    widget.history.deleteStatus
                        ? 'PENDING'
                        : widget.history.isWin.toString().isEmpty
                            ? 'LOST'
                            : 'WON',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 2,
                height: 40,
                color: Colors.blueGrey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.history.type.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.history.closePana.isNotEmpty
                        ? '${widget.history.openDigit.isEmpty ? widget.history.openPana : widget.history.openDigit}*${widget.history.closeDigit.isEmpty ? widget.history.closePana : widget.history.closeDigit} = ${widget.history.bidPoint}'
                        : '${widget.history.singleDigit.isNotEmpty ? widget.history.singleDigit : widget.history.singlePana.isNotEmpty ? widget.history.singlePana : widget.history.singlePanna.isNotEmpty ? widget.history.singlePanna : widget.history.doubleDigit.isNotEmpty ? widget.history.doubleDigit : widget.history.doublePana.isNotEmpty ? widget.history.doublePana : widget.history.doublePanna.isNotEmpty ? widget.history.doublePanna : widget.history.triplePana.isNotEmpty ? widget.history.triplePana : widget.history.triplePanna.isNotEmpty ? widget.history.triplePana : 'CLASS'} = ${widget.history.bidPoint}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 2,
                height: 40,
                color: Colors.blueGrey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.history.ticketId,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4, top: 4, bottom: 4, right: 8),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              final userProvider = Provider.of<UserProvider>(
                                  context,
                                  listen: false);

                              bool deleted = await deleteBid(
                                  widget.history, userProvider.user.id);
                              if (deleted) {
                                showCoolSuccessSnackbar(
                                    context, 'Bid deleted successfully');

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NavigationBarApp(
                                      isHistory: true,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                showCoolErrorSnackbar(context, 'Error');
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: const Text(
                              'DELETE',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
