class FullNumberDataModel {
  bool error;
  String message;
  FullNumberData data;

  FullNumberDataModel({
    required this.error,
    required this.message,
    required this.data,
  });

  factory FullNumberDataModel.fromJson(Map<String, dynamic> json) {
    return FullNumberDataModel(
      error: json['error'],
      message: json['message'],
      data: FullNumberData.fromJson(json['data']),
    );
  }
}

class FullNumberData {
  List<NumberCategory> ink;
  List<NumberCategory> pana;

  FullNumberData({
    required this.ink,
    required this.pana,
  });

  factory FullNumberData.fromJson(Map<String, dynamic> json) {
    List<dynamic> inkList = json['ink'];
    List<dynamic> panaList = json['pana'];

    List<NumberCategory> ink =
        inkList.map((e) => NumberCategory.fromJson(e)).toList();
    List<NumberCategory> pana =
        panaList.map((e) => NumberCategory.fromJson(e)).toList();

    return FullNumberData(
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
