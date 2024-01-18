class ChartItem {
  String startDate;
  String endDate;
  List<Result> results;

  ChartItem(
      {required this.startDate, required this.endDate, required this.results});

  factory ChartItem.fromJson(Map<String, dynamic> json) {
    return ChartItem(
      startDate: json['startDate'],
      endDate: json['endDate'],
      results: List<Result>.from(
          json['results'].map((item) => Result.fromJson(item))),
    );
  }
}

class Result {
  bool color;
  String day;
  String date;
  String openPanna;
  String closePanna;
  String jodi;

  Result({
    required this.color,
    required this.day,
    required this.date,
    required this.openPanna,
    required this.closePanna,
    required this.jodi,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      color: json['color'],
      day: json['day'],
      date: json['date'],
      openPanna: json['open_panna'],
      closePanna: json['close_panna'],
      jodi: json['jodi'],
    );
  }
}
