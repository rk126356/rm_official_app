// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/provider/resend_otp_timer_provider.dart';
import 'package:rm_official_app/screens/auth/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/screens/navigation/bottom_navigation.dart';
import 'package:rm_official_app/widgets/loading_overlay_widget.dart';

import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../../widgets/error_snackbar_widget.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';
  String _verifiedPhoneNumber = '';
  String _name = '';
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';
  bool _isLoading = false;
  String otp = '';
  String inputOtp = '';
  late UserModel user;
  bool otpSend = false;
  bool otpVerified = false;
  bool _isButtonLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String otpError = '';
  bool _isOtpError = false;

  Future<void> _sendOtp() async {
    final timerProvider =
        Provider.of<ResendTimerProvider>(context, listen: false);
    timerProvider.stopResendTimer();
    setState(() {
      _isButtonLoading = true;
      _isOtpError = false;
    });
    if (_phoneNumber.length > 9) {
      const String apiUrl = 'https://rmmatka.com/ravan/api/send-otp';

      Map<String, String> body = {
        'mobile': _phoneNumber,
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: body,
        );

        final Map<String, dynamic> data = json.decode(response.body);

        if (data['error'] == false) {
          String otpData = data['data']['otp'].toString();
          timerProvider.startResendTimer();
          timerProvider.switchResendVisible(false);
          setState(() {
            otp = otpData;
            otpSend = true;
          });
          _showOtpVerificationPopup(context, otp, _phoneNumber);
        } else {
          showCoolErrorSnackbar(context, data['message']);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    } else {
      showCoolErrorSnackbar(context, 'Please enter a valid phone number');
    }
    setState(() {
      _isButtonLoading = false;
    });
  }

  Future<void> _resendOtp() async {
    final timerProvider =
        Provider.of<ResendTimerProvider>(context, listen: false);
    timerProvider.stopResendTimer();
    setState(() {
      _isOtpError = false;

      _isButtonLoading = true;
    });
    const String apiUrl = 'https://rmmatka.com/ravan/api/resend-otp';

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
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    _isButtonLoading = false;
  }

  Future<void> _verifyOtp() async {
    final timerProvider =
        Provider.of<ResendTimerProvider>(context, listen: false);
    setState(() {
      _isButtonLoading = true;
      _isOtpError = false;
    });
    const String apiUrl = 'https://rmmatka.com/ravan/api/otp-verify';

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
        setState(() {
          _isOtpError = false;
          _verifiedPhoneNumber = _phoneNumber;
          otpVerified = true;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          _isOtpError = true;
          otpError = data['message'];
        });
        Navigator.pop(context);
        _showOtpVerificationPopup(context, otp, _phoneNumber);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    setState(() {
      _isButtonLoading = false;
    });
  }

  Future<void> _register() async {
    setState(() {
      _isButtonLoading = true;
    });

    if (!otpVerified) {
      showCoolErrorSnackbar(context, 'Please verify your phone number');
      setState(() {
        _isButtonLoading = false;
      });
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      const String apiUrl = 'https://rmmatka.com/ravan/api/signup';

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
          user = UserModel.fromJson(data['data']);
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

  void success() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(user);
    userProvider.setIsLoggedIn(true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const NavigationBarApp(),
      ),
      (route) => false,
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
    wait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading ? null : const Text('Register'),
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
                                    const SizedBox(height: 20),
                                    if (!otpVerified)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color:
                                                        AppColors.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          fillColor: AppColors
                                                              .blueType,
                                                          prefixIcon: Icon(
                                                              Icons.phone),
                                                          prefixIconColor:
                                                              AppColors
                                                                  .blueType,
                                                          labelText:
                                                              'Phone Number',
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  AppColors
                                                                      .blueType,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic)),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _phoneNumber = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            _isButtonLoading
                                                ? const CircularProgressIndicator()
                                                : Container(
                                                    decoration: const BoxDecoration(
                                                        color:
                                                            AppColors.pinkType,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12))),
                                                    child: TextButton(
                                                      onPressed: _sendOtp,
                                                      child: const Text(
                                                        'SEND OTP',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    if (otpVerified)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: TextFormField(
                                            initialValue: _verifiedPhoneNumber,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                                fillColor: AppColors.blueType,
                                                suffixIcon:
                                                    Icon(Icons.verified),
                                                prefixIcon: Icon(Icons.phone),
                                                prefixIconColor:
                                                    AppColors.blueType,
                                                labelText: 'Phone Number',
                                                labelStyle: TextStyle(
                                                    color: AppColors.blueType,
                                                    fontStyle:
                                                        FontStyle.italic)),
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
                                                Radius.circular(12))),
                                        child: TextFormField(
                                          readOnly: otpVerified ? false : true,
                                          decoration: InputDecoration(
                                              hintText: otpVerified
                                                  ? null
                                                  : 'Verify phone number first.',
                                              fillColor: AppColors.blueType,
                                              prefixIcon:
                                                  const Icon(Icons.person),
                                              prefixIconColor:
                                                  AppColors.blueType,
                                              labelText: 'Username',
                                              labelStyle: const TextStyle(
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: TextFormField(
                                          readOnly: otpVerified ? false : true,
                                          decoration: InputDecoration(
                                            hintText: otpVerified
                                                ? null
                                                : 'Verify phone number first.',
                                            fillColor: AppColors.blueType,
                                            prefixIcon: const Icon(Icons.lock),
                                            prefixIconColor: AppColors.blueType,
                                            labelText: 'Enter Password',
                                            labelStyle: const TextStyle(
                                              color: AppColors.blueType,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            suffixIcon: !otpVerified
                                                ? null
                                                : IconButton(
                                                    icon: Icon(
                                                      _isPasswordVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
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
                                          onChanged: (value) {
                                            _password = value;
                                          },
                                          obscureText: !_isPasswordVisible,
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
                                          readOnly: otpVerified ? false : true,
                                          decoration: InputDecoration(
                                            hintText: otpVerified
                                                ? null
                                                : 'Verify phone number first.',
                                            fillColor: AppColors.blueType,
                                            prefixIcon: const Icon(Icons.lock),
                                            prefixIconColor: AppColors.blueType,
                                            labelText: 'Confirm Password',
                                            labelStyle: const TextStyle(
                                              color: AppColors.blueType,
                                              fontStyle: FontStyle.italic,
                                            ),
                                            suffixIcon: !otpVerified
                                                ? null
                                                : IconButton(
                                                    icon: Icon(
                                                      _isConfirmPasswordVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
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
                                              !_isConfirmPasswordVisible,
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
                                            child: const Text('REGISTER'),
                                          ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Already have an account?',
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
                                                    const LoginScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Login',
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
          backgroundColor: AppColors.opBlueType,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(otp),
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
                      color: Colors.yellow,
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : OtpTextField(
                        autoFocus: true,
                        numberOfFields: 6,
                        borderColor: AppColors.primaryColor,
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {},
                        onSubmit: (String verificationCode) {
                          inputOtp = verificationCode;
                          _verifyOtp();
                        },
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: timerProvider.isResendVisible ? _resendOtp : null,
                  child: Text(
                    timerProvider.isResendVisible
                        ? 'Resend OTP'
                        : 'Resend OTP (${timerProvider.remainingSeconds} seconds)',
                    style: TextStyle(
                      color: timerProvider.isResendVisible
                          ? Colors.white
                          : Colors.white70,
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
