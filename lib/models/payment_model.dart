class PaymentModel {
  String id;
  String userId;
  String type;
  String upiId;
  String createdAt;
  String updatedAt;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.upiId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      upiId: json['upi_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'upi_id': upiId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
