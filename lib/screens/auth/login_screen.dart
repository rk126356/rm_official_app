// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/screens/auth/register_screen.dart';
import 'package:rm_official_app/screens/navigation/wallet_off_bottom.dart';
import 'package:rm_official_app/widgets/loading_overlay_widget.dart';

import '../../controllers/check_wallet_on.dart';
import '../../provider/resend_otp_timer_provider.dart';
import '../../provider/user_provider.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../navigation/bottom_navigation.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.refresh});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  final bool refresh;
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _usernameOrMobileNumber = '';
  String _password = '';
  bool _isLoading = false;
  bool _isButtonLoading = false;
  late UserModel user;
  bool _isPasswordVisible = false;
  String otpError = '';
  bool _isOtpError = false;
  String otp = '';
  String inputOtp = '';
  bool _isLoadingOtp = false;
  String mobile = '';
  bool walletOn = true;

  Future<void> _login() async {
    setState(() {
      _isButtonLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      const String apiUrl = 'https://rmmatka.com/app/api/login';

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
        final timerProvider =
            Provider.of<ResendTimerProvider>(context, listen: false);

        if (data['message'] == 'Please verify your number') {
          String phone = data['data']['mobile'].toString();
          String otp = data['data']['otp'].toString();
          mobile = phone;
          timerProvider.stopResendTimer();
          timerProvider.startResendTimer();
          timerProvider.switchResendVisible(false);
          _showOtpVerificationPopup(context, otp, phone);
        }

        if (data['error'] == false) {
          user = UserModel.fromJson(data['data']);
          walletOn = await fetchIsWalletOn(user.id);
          success();
        } else {
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

  Future<void> _verifyOtp() async {
    const String apiUrl = 'https://rmmatka.com/app/api/otp-verify';
    final timerProvider =
        Provider.of<ResendTimerProvider>(context, listen: false);
    setState(() {
      _isLoadingOtp = true;
    });
    Map<String, dynamic> body = {
      'otp': inputOtp,
      'mobile': mobile,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['error'] == false) {
        timerProvider.stopResendTimer();
        user = UserModel.fromJson(data['data']);
        walletOn = await fetchIsWalletOn(user.id);
        setState(() {
          _isOtpError = false;
        });
        success();
      } else {
        setState(() {
          _isOtpError = true;
          otpError = data['message'];
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    setState(() {
      _isLoadingOtp = false;
    });
  }

  Future<void> _resendOtp() async {
    final timerProvider =
        Provider.of<ResendTimerProvider>(context, listen: false);
    timerProvider.stopResendTimer();
    setState(() {
      _isOtpError = false;
      _isLoadingOtp = true;
    });

    const String apiUrl = 'https://rmmatka.com/app/api/resend-otp';

    Map<String, dynamic> body = {
      'mobile': mobile,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['error'] == false) {
        timerProvider.startResendTimer();
        timerProvider.switchResendVisible(false);
        setState(() {
          otp = data['data']['otp'].toString();
        });
      } else {
        showCoolErrorSnackbar(context, data['message']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    setState(() {
      _isLoadingOtp = false;
    });
  }

  Future<void> fetchUser(String userId) async {
    String apiUrl = 'https://rmmatka.com/app/api/fetch-profile';

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
        // walletOn = await fetchIsWalletOn(user.id);
        walletOn = true;
        print(userId);
        success();
      } else {
        showCoolErrorSnackbar(context, 'Something went wrong');
      }
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
    await Future.delayed(duration);
    setState(() {
      _isLoading = false;
    });
  }

  void success() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(user);
    userProvider.setIsLoggedIn(true);

    if (walletOn) {
      userProvider.user.onWallet = '1';
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const NavigationBarApp(),
        ),
        (route) => false,
      );
    } else {
      userProvider.user.onWallet = '0';
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const WalletOffBottom(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.refresh) {
      wait();
    }
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
                                        horizontal: 30,
                                      ),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 10,
                                              ),
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
                                          horizontal: 30),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
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
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Forget Your password?",
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
                                                    const ForgetPasswordScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'RESET',
                                            style: TextStyle(
                                                decorationColor: Colors.white,
                                                color: AppColors.primaryColor,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Don't have an account?",
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
                                                    const RegisterScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'REGISTER',
                                            style: TextStyle(
                                                decorationColor: Colors.white,
                                                color: AppColors.primaryColor,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 18),
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
                      const Text(
                        'This Application is Specially Designed For\n'
                        'India Users So, The Otp service is Only\n'
                        'Available For Indian Users Only.',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: AppColors.blueType),
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

  void _showOtpVerificationPopup(
    BuildContext context,
    String otp,
    String phoneNumber,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final timerProvider = Provider.of<ResendTimerProvider>(context);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 239, 196, 110),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(otp),
                const Text(
                  'Enter the OTP sent to your mobile number',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  phoneNumber,
                  style: const TextStyle(fontSize: 22, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 12,
                ),
                if (_isOtpError)
                  Text(
                    _isOtpError ? 'Error: $otpError' : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: const Text(
                    'Change Number',
                    style: TextStyle(
                      color: AppColors.blueType,
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoadingOtp
                    ? const CircularProgressIndicator()
                    : OtpTextField(
                        fieldWidth: 36,
                        fillColor: Colors.black,
                        cursorColor: Colors.black,
                        enabledBorderColor: Colors.black,
                        autoFocus: true,
                        numberOfFields: 6,
                        borderColor: Colors.black,
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {
                          inputOtp = verificationCode;
                          _verifyOtp();
                        },
                      ),
                const SizedBox(height: 20),
                timerProvider.isResendVisible
                    ? TextButton(
                        onPressed:
                            timerProvider.isResendVisible ? _resendOtp : null,
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: AppColors.redType,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed:
                            timerProvider.isResendVisible ? _resendOtp : null,
                        child: Text(
                          'Resend OTP (${timerProvider.remainingSeconds} seconds)',
                          style: TextStyle(
                            color: timerProvider.isResendVisible
                                ? AppColors.blueType
                                : AppColors.blueType,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
