import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/models/user_model.dart';
import 'package:rm_official_app/screens/auth/register_screen.dart';
import 'package:rm_official_app/widgets/loading_overlay_widget.dart';

import '../../provider/user_provider.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../navigation/bottom_navigation.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.otp, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
  final String otp;
  final String mobile;
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = '';
  String inputOtp = '';
  bool _isLoading = false;
  late UserModel user;

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
    });
    const String apiUrl = 'https://rmmatka.com/app/api/resend-otp';

    Map<String, dynamic> body = {
      'mobile': widget.mobile,
      'otp': otp,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['error'] == false) {
        setState(() {
          otp = data['data']['otp'].toString();
        });
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    _isLoading = false;
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    const String apiUrl = 'https://rmmatka.com/app/api/otp-verify';

    Map<String, dynamic> body = {
      'otp': inputOtp,
      'mobile': widget.mobile,
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
        // ignore: use_build_context_synchronously
        showCoolErrorSnackbar(context, data['message']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    setState(() {
      _isLoading = false;
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

  @override
  void initState() {
    super.initState();
    _resendOtp();
    otp = widget.otp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.redType,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'OTP Verification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading ? const LoadingWidget() : newMethod(),
    );
  }

  Padding newMethod() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(otp),
          const Text(
            'Enter the OTP sent to your mobile number',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OtpTextField(
            numberOfFields: 6,
            borderColor: const Color(0xFF512DA8),
            showFieldAsBox: true,
            onCodeChanged: (String code) {},
            onSubmit: (String verificationCode) {
              inputOtp = verificationCode;
              _verifyOtp();
            },
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _resendOtp,
            child: const Text(
              'Resend OTP',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: _verifyOtp,
          //   child: const Text('Verify OTP'),
          // ),
        ],
      ),
    );
  }
}
