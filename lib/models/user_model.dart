class UserModel {
  String id;
  String name;
  String image;
  String mobile;
  String language;
  String state;
  String city;
  String fcmToken;
  String status;
  String onWallet;
  String upi;
  String customerName;
  String bankName;
  String bankAccountNumber;
  String ifscCode;
  String bankAddress;
  String lastLoginDateTime;
  String lastLogoutDateTime;
  String createdAt;
  String updatedAt;
  int balance;

  UserModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.mobile,
      required this.language,
      required this.state,
      required this.city,
      required this.fcmToken,
      required this.status,
      required this.onWallet,
      required this.customerName,
      required this.upi,
      required this.bankName,
      required this.bankAccountNumber,
      required this.ifscCode,
      required this.bankAddress,
      required this.lastLoginDateTime,
      required this.lastLogoutDateTime,
      required this.createdAt,
      required this.updatedAt,
      required this.balance});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      mobile: json['mobile'],
      language: json['language'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      fcmToken: json['fcm_token'] ?? '',
      status: json['status'] ?? '',
      onWallet: json['on_wallet'] ?? '',
      upi: json['upi'] ?? '',
      customerName: json['customer_name'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankAccountNumber: json['bank_account_number'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      bankAddress: json['bank_address'] ?? '',
      lastLoginDateTime: json['last_login_date_time'] ?? '',
      lastLogoutDateTime: json['last_logout_date_time'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      balance: json['balance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'mobile': mobile,
      'language': language,
      'state': state,
      'city': city,
      'fcm_token': fcmToken,
      'status': status,
      'on_wallet': onWallet,
      'customer_name': customerName,
      'bank_name': bankName,
      'bank_account_number': bankAccountNumber,
      'ifsc_code': ifscCode,
      'bank_address': bankAddress,
      'last_login_date_time': lastLoginDateTime,
      'last_logout_date_time': lastLogoutDateTime,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
