import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rm_official_app/models/single_bid_history_model.dart';
import 'package:rm_official_app/widgets/all_bids_popup_widget.dart';
import '../const/colors.dart';

class SingleBidHistoryLoop extends StatelessWidget {
  const SingleBidHistoryLoop({
    Key? key,
    required this.history,
  }) : super(key: key);

  final SingleBidHistory history;

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AllBidsPopup(
        histories: history.allHistory,
        name: history.ticketId.first,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime createdAtDateTime = DateFormat('dd-MM-yyyy hh:mm a')
        .parse(history.allHistory.first.createdAt);

    String formattedDate = DateFormat('hh:mm a').format(createdAtDateTime);

    return Container(
      height: 60,
      color: AppColors.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  history.ticketId.first,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            color: Colors.blueGrey,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${history.allHistory.first.marketName} (${history.allHistory.first.session.toUpperCase()})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  history.allHistory.first.type.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            color: Colors.blueGrey,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 4, top: 4, bottom: 4, right: 8),
            child: InkWell(
              onTap: () {
                _showPopup(context);
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_red_eye),
                  Text(
                    'View',
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
          if (history.deleteStatus)
            Container(
              width: 1,
              color: Colors.blueGrey,
            ),
          if (history.deleteStatus)
            const Padding(
              padding: EdgeInsets.only(left: 4, top: 4, bottom: 4, right: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete),
                  Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
