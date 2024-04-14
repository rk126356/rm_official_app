// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/provider/user_provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/screens/auth/login_screen.dart';

import '../../controllers/check_wallet_on.dart';
import '../../models/user_model.dart';
import '../../provider/resend_otp_timer_provider.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../navigation/bottom_navigation.dart';
import '../navigation/wallet_off_bottom.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';

  late UserModel user;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isButtonLoading = false;
  String otpError = '';
  bool _isOtpError = false;
  String otp = '';
  String inputOtp = '';
  bool _isLoadingOtp = false;
  bool walletOn = true;

  Future<void> _register() async {
    setState(() {
      _isButtonLoading = true;
      _isOtpError = false;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      const String apiUrl = 'https://rmmatka.com/app/api/signup';

      Map<String, String> body = {
        'name': _name,
        'mobile': _phoneNumber,
        'password': _password,
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: body,
        );

        final Map<String, dynamic> data = json.decode(response.body);

        if (data['error'] == false) {
          _resendOtp();
          user = UserModel.fromJson(data['data']);
          final otp = data['data']['otp'];
          final mobile = data['data']['mobile'];
          // print(otp);
          _showOtpVerificationPopup(context, otp, mobile);
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
      'mobile': _phoneNumber,
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
      'mobile': _phoneNumber,
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
        // print(otp);
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

  void success() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(user);
    userProvider.setIsLoggedIn(true);

    // print(user);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTER'),
        backgroundColor: AppColors.primaryColor,
      ),
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 20),
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
                                  'REGISTER',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        fillColor: AppColors.blueType,
                                        prefixIcon: Icon(Icons.phone),
                                        prefixIconColor: AppColors.blueType,
                                        labelText: 'Phone Number',
                                        labelStyle: TextStyle(
                                            color: AppColors.blueType,
                                            fontStyle: FontStyle.italic)),
                                    validator: (value) {
                                      if (value!.length < 10) {
                                        return '     Please enter your phone number';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _phoneNumber = value!,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        fillColor: AppColors.blueType,
                                        prefixIcon: Icon(Icons.person),
                                        prefixIconColor: AppColors.blueType,
                                        labelText: 'Username',
                                        labelStyle: TextStyle(
                                            color: AppColors.blueType,
                                            fontStyle: FontStyle.italic)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '     Please enter your username';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) => _name = value!,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
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
                                      // Add suffix icon to toggle password visibility
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
                                    onSaved: (value) => _password = value!,
                                    onChanged: (value) {
                                      _password = value;
                                    },
                                    obscureText:
                                        !_isPasswordVisible, // Toggle password visibility
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
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
                                      labelText: 'Confirm Password',
                                      labelStyle: const TextStyle(
                                        color: AppColors.blueType,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      // Add suffix icon to toggle password visibility
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isConfirmPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: AppColors.blueType,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isConfirmPasswordVisible =
                                                !_isConfirmPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '     Please confirm your password';
                                      }
                                      if (value != _password) {
                                        return '     Passwords do not match';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) =>
                                        _confirmPassword = value!,
                                    obscureText:
                                        !_isConfirmPasswordVisible, // Toggle password visibility
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              _isButtonLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: _register,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 12),
                                        foregroundColor: Colors.white,
                                        backgroundColor: AppColors.blueType,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('REGISTER'),
                                    ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(
                                            refresh: false,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          decorationColor: Colors.white,
                                          color: AppColors.primaryColor,
                                          decoration: TextDecoration.underline,
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
                  style: TextStyle(fontSize: 14, color: AppColors.blueType),
                ),
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
