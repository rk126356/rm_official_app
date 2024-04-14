import 'pana_data_model.dart';

class FamilyBids {
  int digit;
  int amount;
  String? type;
  List<SingleBids>? bids;
  List<PanaData>? data;

  FamilyBids({
    required this.digit,
    required this.amount,
    this.type,
    this.bids,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'digit': digit,
      'amount': amount,
      'bids': bids?.map((bid) => bid.toJson()).toList() ?? [],
      'data': data?.map((data) => data.toJson()).toList() ?? [],
    };
  }
}

class SingleBids {
  String type;
  String number;
  String bidPoint;

  SingleBids({
    required this.type,
    required this.number,
    required this.bidPoint,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'number': number,
      'bid_point': bidPoint,
    };
  }

  factory SingleBids.fromJson(Map<String, dynamic> json) {
    return SingleBids(
      type: json['type'] ?? '',
      number: json['number'] ?? '',
      bidPoint: json['bid_point'] ?? '',
    );
  }
}
