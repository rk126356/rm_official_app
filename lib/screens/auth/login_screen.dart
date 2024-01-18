import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/models/user_model.dart';
import 'package:rm_official_app/screens/auth/otp_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/screens/auth/send_otp_screen.dart';
import 'package:rm_official_app/widgets/loading_overlay_widget.dart';

import '../../provider/user_provider.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../navigation/bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _usernameOrMobileNumber = '';
  String _password = '';
  bool _isLoading = false;
  bool _isButtonLoading = false;
  late UserModel user;
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    setState(() {
      _isButtonLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      const String apiUrl = 'https://rmmatka.com/ravan/api/login';

      Map<String, String> body = {
        'username': _usernameOrMobileNumber,
        'password': _password,
        'fcm_token': ''
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: body,
        );

        final Map<String, dynamic> data = json.decode(response.body);

        if (data['message'] == 'Please verify your number') {
          String otp = data['data']['otp'].toString();
          String mobile = data['data']['mobile'].toString();

          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                otp: otp,
                mobile: mobile,
              ),
            ),
          );
        }

        if (data['error'] == false) {
          user = UserModel.fromJson(data['data']);
          success();
        } else {
          // ignore: use_build_context_synchronously
          showCoolErrorSnackbar(context, data['message']);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
    setState(() {
      _isButtonLoading = false;
    });
  }

  void success() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(user);
    userProvider.setIsLoggedIn(true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const NavigationBarApp(),
      ),
    );
  }

  Future<void> fetchUser(String userId) async {
    String apiUrl = 'https://rmmatka.com/ravan/api/fetch-profile';

    Map<String, String> body = {
      'user_id': userId,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['error'] == false) {
        user = UserModel.fromJson(data['data']);
        user.id = userId;
        success();
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void wait() async {
    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    const duration = Duration(seconds: 2);

    await Future.delayed(duration);

    if (userProvider.isLoggedIn) {
      await fetchUser(userProvider.userId);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading ? null : const Text('Login'),
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: _isLoading
            ? const LoadingWidget()
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/rm_logo_banner.jpg'),
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Warning: Play By Virtual Points For Virtual Win Only "No Real Money" ... this is Only For Entertainment By traditionall Indian Matka Game..',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        color: AppColors.blueType,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12)),
                                  color: AppColors.opBlueType,
                                ),
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              fillColor: AppColors.blueType,
                                              prefixIcon: Icon(Icons.person),
                                              prefixIconColor:
                                                  AppColors.blueType,
                                              labelText:
                                                  'Username / Mobile Number',
                                              labelStyle: TextStyle(
                                                  color: AppColors.blueType,
                                                  fontStyle: FontStyle.italic)),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return '     Please enter a mobile number';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) =>
                                              _usernameOrMobileNumber = value!,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            fillColor: AppColors.blueType,
                                            prefixIcon: const Icon(Icons.lock),
                                            prefixIconColor: AppColors.blueType,
                                            labelText: 'Enter Password',
                                            labelStyle: const TextStyle(
                                              color: AppColors.blueType,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: AppColors.blueType,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible;
                                                });
                                              },
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return '     Please enter a password';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) =>
                                              _password = value!,
                                          obscureText:
                                              !_isPasswordVisible, // Toggle password visibility
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _isButtonLoading
                                        ? const CircularProgressIndicator()
                                        : ElevatedButton(
                                            onPressed: _login,
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 12),
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  AppColors.blueType,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: const Text('LOGIN'),
                                          ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Forget Your password?',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'New Members Register Here',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const SendOtpScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Register',
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/whatsapp.png',
                            width: 60,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            'This Application is Specially Designed For\n'
                            'India Users So, The Otp service is Only\n'
                            'Available For Indian Users Only.',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.blueType),
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.of(context).pushReplacement(
                      //         MaterialPageRoute(
                      //           builder: (context) => const NavigationBarApp(),
                      //         ),
                      //       );
                      //     },
                      //     child: const Text('SKIP')),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
