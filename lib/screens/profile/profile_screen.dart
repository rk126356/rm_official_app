// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/controllers/fetch_balance_controller.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:rm_official_app/widgets/success_snackbar_widget.dart';

import '../../models/user_model.dart';
import '../../provider/user_provider.dart';
import '../navigation/drawer_nav_bar.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.isRoute}) : super(key: key);

  final bool isRoute;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phoneNumber;
  File? _image;
  bool _isLoading = false;

  Future _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  String apiUrl = 'https://rmmatka.com/app/api/update-profile';

  Future<void> fetchUser(String userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
        final user = UserModel.fromJson(data['data']);
        user.id = userProvider.user.id;
        userProvider.setUser(user);
      } else {}
    } catch (e) {}
  }

  Future<void> updateProfile() async {
    if (_image == null) {
      showCoolErrorSnackbar(context, 'Please select a profile image');
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      MultipartFile? imageFile;
      if (_image != null) {
        String fileName = _image!.path.split('/').last;
        imageFile = await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          filename: fileName,
        );
      }

      // Prepare request body
      Map<String, String> requestBody = {
        'user_id': userProvider.user.id,
        'name': userProvider.user.name,
        'mobile': _phoneNumber,
      };

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields.addAll(requestBody)
        ..files.add(imageFile!);

      // Send request
      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          showCoolSuccessSnackbar(context, data['message']);
          await fetchUser(userProvider.user.id);
          fetchBalance(context);
          Navigator.pop(context);
        } else {
          showCoolErrorSnackbar(context, data['message']);
        }
      } else {
        showCoolErrorSnackbar(context, 'Check your internet connection');
      }
    } catch (e) {
      showCoolErrorSnackbar(context, 'Error: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _name = userProvider.user.name;
      _phoneNumber = userProvider.user.mobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      drawer: widget.isRoute ? null : const NavBar(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.redType,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(75.0),
                            ),
                            child: GestureDetector(
                              onTap: _getImage,
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: ClipOval(
                                  child: _image != null
                                      ? Image.file(_image!)
                                      : userProvider.user.image.isNotEmpty
                                          ? Image.network(
                                              'https://rmmatka.com/app/${userProvider.user.image}')
                                          : Image.asset(
                                              'assets/images/avatar.png'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: _getImage,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: _name,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onChanged: (value) => _name = value!,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: _phoneNumber,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            onChanged: (value) => _phoneNumber = value!,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: updateProfile,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: const Text(
                          'UPDATE PROFILE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
