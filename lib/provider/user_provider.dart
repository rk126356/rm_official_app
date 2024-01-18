import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  late UserModel _user;
  bool _isLoggedIn = false;
  String _userId = "";

  UserModel get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  String get userId => _userId;

  static const String _isLoggedInKey = 'isLoggedIn';

  UserProvider() {
    _loadIsLoggedIn();
  }

  void setBalance(int balance) {
    _user.balance = balance;
    notifyListeners();
  }

  Future<void> _loadIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    _userId = prefs.getString('userid') ?? '';
    notifyListeners();
  }

  void setIsLoggedIn(bool data) async {
    _isLoggedIn = data;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isLoggedInKey, _isLoggedIn);
  }

  void setUser(UserModel user) {
    _user = user;
    _userId = user.id;
    saveUserId(user.id);
    notifyListeners();
  }

  void saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', userId);
  }

  void clearUser() {
    _user = UserModel(
      id: '',
      name: '',
      image: '',
      mobile: '',
      language: '',
      state: '',
      city: '',
      fcmToken: '',
      status: '',
      onWallet: '',
      upi: '',
      customerName: '',
      bankName: '',
      bankAccountNumber: '',
      ifscCode: '',
      bankAddress: '',
      lastLoginDateTime: '',
      lastLogoutDateTime: '',
      createdAt: '',
      updatedAt: '',
      balance: 0,
    );
    notifyListeners();
  }
}
