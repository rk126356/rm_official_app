class PannaResponse {
  bool error;
  String message;
  List<PanaData> data;

  PannaResponse(
      {required this.error, required this.message, required this.data});

  factory PannaResponse.fromJson(Map<String, dynamic> json) {
    return PannaResponse(
      error: json['error'],
      message: json['message'],
      data: (json['data'] as List)
          .map((panaData) => PanaData.fromJson(panaData))
          .toList(),
    );
  }
}

class PanaData {
  String pana;

  PanaData({required this.pana});

  Map<String, dynamic> toJson() {
    return {
      'pana': pana,
    };
  }

  factory PanaData.fromJson(Map<String, dynamic> json) {
    return PanaData(
      pana: json['pana'].toString(),
    );
  }
}
