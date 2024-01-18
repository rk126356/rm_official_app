import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rm_official_app/models/bid_history_model.dart';

class BidHistoryLoop extends StatelessWidget {
  const BidHistoryLoop({
    Key? key,
    required this.history,
  }) : super(key: key);

  final BidHistory history;

  @override
  Widget build(BuildContext context) {
    DateTime createdAtDateTime =
        DateFormat('dd-MM-yyyy hh:mm a').parse(history.createdAt);

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
                  Text(
                    formattedDate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    history.bidDate,
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
                  const Text(
                    'WIN',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    history.deleteStatus
                        ? 'PENDING'
                        : history.isWin.toString().isEmpty
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
                    history.type.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    history.closePana.isNotEmpty
                        ? '${history.openDigit.isEmpty ? history.openPana : history.openDigit}*${history.closeDigit.isEmpty ? history.closePana : history.closeDigit} = ${history.bidPoint}'
                        : '${history.singleDigit.isNotEmpty ? history.singleDigit : history.singlePana.isNotEmpty ? history.singlePana : history.singlePanna.isNotEmpty ? history.singlePanna : history.doubleDigit.isNotEmpty ? history.doubleDigit : history.doublePana.isNotEmpty ? history.doublePana : history.doublePanna.isNotEmpty ? history.doublePanna : history.triplePana.isNotEmpty ? history.triplePana : history.triplePanna.isNotEmpty ? history.triplePana : 'CLASS'} = ${history.bidPoint}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
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
