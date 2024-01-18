class MarketList {
  final String id;
  final String marketName;
  final String day;
  final String status;
  final String isHoliday;
  final String color;
  final bool isOpen;
  final String openTime;
  final String closeTime;
  String timeLeftOpenTime;
  String timeLeftCloseTime;
  final String number;
  final String onWallet;

  MarketList({
    required this.id,
    required this.marketName,
    required this.day,
    required this.status,
    required this.isHoliday,
    required this.color,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    required this.timeLeftOpenTime,
    required this.timeLeftCloseTime,
    required this.number,
    required this.onWallet,
  });

  factory MarketList.fromJson(Map<String, dynamic> json) {
    return MarketList(
      id: json['id'],
      marketName: json['market_name'],
      day: json['Thu'],
      status: json['status'],
      isHoliday: json['is_holiday'],
      color: json['color'],
      isOpen: json['is_open'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      timeLeftOpenTime: json['time_left_open_time'],
      timeLeftCloseTime: json['time_left_close_time'],
      number: json['number'],
      onWallet: json['on_wallet'],
    );
  }
}
