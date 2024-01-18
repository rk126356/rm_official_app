class BidHistory {
  String bidId;
  String id;
  String ticketId;
  String userId;
  String marketId;
  String type;
  String bidDate;
  String session;
  String singleDigit;
  String doubleDigit;
  String singlePana;
  String doublePana;
  String triplePana;
  String openPana;
  String closeDigit;
  String closePana;
  String openDigit;
  String bidPoint;
  String bidRevert;
  dynamic isWin;
  String createdAt;
  String updatedAt;
  dynamic winWalletId;
  String marketName;
  String startTime;
  String endTime;
  String color;
  dynamic winAmount;
  String singlePanna;
  String doublePanna;
  String triplePanna;
  String leftDigit;
  String rightDigit;
  bool deleteStatus;

  BidHistory({
    required this.bidId,
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.marketId,
    required this.type,
    required this.bidDate,
    required this.session,
    required this.singleDigit,
    required this.doubleDigit,
    required this.singlePana,
    required this.doublePana,
    required this.triplePana,
    required this.openPana,
    required this.closeDigit,
    required this.closePana,
    required this.openDigit,
    required this.bidPoint,
    required this.bidRevert,
    required this.isWin,
    required this.createdAt,
    required this.updatedAt,
    required this.winWalletId,
    required this.marketName,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.winAmount,
    required this.singlePanna,
    required this.doublePanna,
    required this.triplePanna,
    required this.leftDigit,
    required this.rightDigit,
    required this.deleteStatus,
  });

  factory BidHistory.fromJson(Map<String, dynamic> json) {
    return BidHistory(
      bidId: json['bid_id'] ?? '',
      id: json['id'] ?? '',
      ticketId: json['ticket_id'] ?? '',
      userId: json['user_id'] ?? '',
      marketId: json['market_id'] ?? '',
      type: json['type'] ?? '',
      bidDate: json['bid_date'] ?? '',
      session: json['session'] ?? '',
      singleDigit: json['single_digit'] ?? '',
      doubleDigit: json['double_digit'] ?? '',
      singlePana: json['single_pana'] ?? '',
      doublePana: json['double_pana'] ?? '',
      triplePana: json['triple_pana'] ?? '',
      openPana: json['open_pana'] ?? '',
      closeDigit: json['close_digit'] ?? '',
      closePana: json['close_pana'] ?? '',
      openDigit: json['open_digit'] ?? '',
      bidPoint: json['bid_point'] ?? '',
      bidRevert: json['bid_revert'] ?? '',
      isWin: json['is_win'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      winWalletId: json['win_wallet_id'] ?? '',
      marketName: json['market_name'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      color: json['color'] ?? '',
      winAmount: json['win_amount'] ?? '',
      singlePanna: json['single_panna'] ?? '',
      doublePanna: json['double_panna'] ?? '',
      triplePanna: json['triple_panna'] ?? '',
      leftDigit: json['left_digit'] ?? '',
      rightDigit: json['right_digit'] ?? '',
      deleteStatus: json['delete_status'] ?? false,
    );
  }
}
