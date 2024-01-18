class PollModel {
  final String name;
  final String status;
  bool revealed;
  final Map<int, int> options;

  PollModel({
    required this.name,
    required this.status,
    this.revealed = false,
    required this.options,
  });

  factory PollModel.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      // Handle the case where data is null (e.g., document not found)
      return PollModel(
        name: '',
        status: '',
        options: {},
      );
    }

    Map<int, int> optionsMap = {};
    if (data['options'] != null && data['options'] is Map<dynamic, dynamic>) {
      optionsMap =
          Map.from(data['options'] as Map<dynamic, dynamic>).map((key, value) {
        // Ensure the values are cast to int
        return MapEntry(int.parse(key.toString()), value as int);
      });
    }

    return PollModel(
      name: data['name'] ?? '',
      status: data['status'] ?? '',
      options: optionsMap,
    );
  }
}
