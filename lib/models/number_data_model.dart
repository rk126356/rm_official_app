class NumberDataModel {
  bool error;
  String message;
  NumberData data;

  NumberDataModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory NumberDataModel.fromJson(Map<String, dynamic> json, bool isHalf) {
    return NumberDataModel(
      error: json['error'],
      message: json['message'],
      data: NumberData.fromJson(json['data'], isHalf),
    );
  }
}

class NumberData {
  List<NumberCategory> ink;
  List<NumberCategory> pana;

  NumberData({
    required this.ink,
    required this.pana,
  });

  factory NumberData.fromJson(Map<String, dynamic> json, bool isHalf) {
    List<dynamic> inkList = isHalf ? json['ink'] : json['open_pana'];
    List<dynamic> panaList = isHalf ? json['pana'] : json['close_pana'];

    List<NumberCategory> ink =
        inkList.map((e) => NumberCategory.fromJson(e)).toList();
    List<NumberCategory> pana =
        panaList.map((e) => NumberCategory.fromJson(e)).toList();

    return NumberData(
      ink: ink,
      pana: pana,
    );
  }
}

class NumberCategory {
  String number;

  NumberCategory({
    required this.number,
  });

  factory NumberCategory.fromJson(Map<String, dynamic> json) {
    return NumberCategory(
      number: json['number'],
    );
  }
}
