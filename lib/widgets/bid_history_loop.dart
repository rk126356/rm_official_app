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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple, Colors.blue],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn(
                [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    history.bidDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const VerticalDivider(
                color: Colors.white,
                width: 1,
                thickness: 15,
              ),
              _buildColumn(
                [
                  const Text(
                    'RESULT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getResultText(history),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: _getResultColor(history),
                    ),
                  ),
                ],
              ),
              const VerticalDivider(
                color: Colors.white,
                width: 1,
                thickness: 15,
              ),
              _buildColumn(
                [
                  Text(
                    history.type.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getBidPointText(history),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  String _getResultText(BidHistory history) {
    if (history.deleteStatus) {
      return 'PENDING';
    } else {
      return history.isWin.toString().isEmpty ? 'LOST' : 'WON';
    }
  }

  Color _getResultColor(BidHistory history) {
    return history.deleteStatus
        ? Colors.orange // PENDING
        : history.isWin.toString().isEmpty
            ? Colors.red // LOST
            : Colors.green; // WON
  }

  String _getBidPointText(BidHistory history) {
    return history.closePana.isNotEmpty
        ? '${history.openDigit.isEmpty ? history.openPana : history.openDigit}*${history.closeDigit.isEmpty ? history.closePana : history.closeDigit} = ${history.bidPoint}'
        : '${history.singleDigit.isNotEmpty ? history.singleDigit : history.singlePana.isNotEmpty ? history.singlePana : history.singlePanna.isNotEmpty ? history.singlePanna : history.doubleDigit.isNotEmpty ? history.doubleDigit : history.doublePana.isNotEmpty ? history.doublePana : history.doublePanna.isNotEmpty ? history.doublePanna : history.triplePana.isNotEmpty ? history.triplePana : history.triplePanna.isNotEmpty ? history.triplePana : 'CLASS'} = ${history.bidPoint}';
  }
}
