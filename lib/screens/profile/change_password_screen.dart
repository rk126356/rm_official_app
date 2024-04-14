import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:rm_official_app/widgets/fade_red_heading_widget.dart';
import 'package:rm_official_app/widgets/heading_logo_widget.dart';
import 'package:rm_official_app/widgets/heading_title_widget.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/widgets/success_snackbar_widget.dart';
import 'package:rm_official_app/widgets/white_side_heading_widget.dart';

import '../../const/colors.dart';
import '../../provider/user_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> changePassword() async {
    setState(() {
      _isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    const apiUrl = 'https://rmmatka.com/app/api/change-password';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'user_id': userProvider.user.id,
          'current_password': currentPasswordController.text,
          'new_password': newPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['error'] == false) {
          // Password changed successfully
          // ignore: use_build_context_synchronously
          showCoolSuccessSnackbar(context, 'Password changed successfully');
        } else {
          // Handle API error
          // ignore: use_build_context_synchronously
          showCoolErrorSnackbar(context, result['message']);
        }
      } else {
        // Handle HTTP error
        // ignore: use_build_context_synchronously
        showCoolErrorSnackbar(
            context, 'Error occurred while changing password.');
      }
    } catch (e) {
      // Handle network or other errors
      // ignore: use_build_context_synchronously
      showCoolErrorSnackbar(
          context, 'Error occurred while connecting to the server.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.redType,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadingLogo(),
            const SizedBox(height: 20),
            const FadeRedHeading(title: 'Change Password'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 201, 121),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CURRENT PASSWORD',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: currentPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Current Password',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'NEW PASSWORD',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      obscureText: true,
                      controller: newPasswordController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Enter New Password',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'CONFIRM NEW PASSWORD',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      obscureText: true,
                      controller: confirmNewPasswordController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Confirm New Password',
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: changePassword,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                    ),
                    child: const Text(
                      'CHANGE PASSWORD',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            const SizedBox(height: 15),
            const BottomContact(),
          ],
        ),
      ),
    );
  }
}
