class AllPanaModel {
  int digit;
  int amount;
  String type;

  AllPanaModel({
    required this.digit,
    required this.amount,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'digit': digit,
      'amount': amount,
    };
  }
}
