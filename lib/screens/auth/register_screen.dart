import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/provider/user_provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';
import '../../widgets/error_snackbar_widget.dart';
import '../navigation/bottom_navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.mobile});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

  final String mobile;
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';
  bool _isLoading = false;
  late UserModel user;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      const String apiUrl = 'https://rmmatka.com/ravan/api/signup';

      Map<String, String> body = {
        'name': _name,
        'mobile': widget.mobile,
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
      _isLoading = false;
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
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
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
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
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
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
                              _isLoading
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
                      style: TextStyle(fontSize: 14, color: AppColors.blueType),
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
}
