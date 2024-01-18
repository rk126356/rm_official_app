import 'package:rm_official_app/models/bid_history_model.dart';

class SingleBidHistory {
  List<String> ticketId;
  bool deleteStatus;
  List<BidHistory> allHistory;

  SingleBidHistory({
    required this.ticketId,
    required this.deleteStatus,
    required this.allHistory,
  });
}
