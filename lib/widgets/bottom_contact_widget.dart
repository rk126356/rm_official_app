// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rm_official_app/utils/url_launcher.dart';
import 'package:rm_official_app/widgets/success_snackbar_widget.dart';
import 'package:http/http.dart' as http;

import '../const/colors.dart';

class BottomContact extends StatefulWidget {
  const BottomContact({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomContact> createState() => _BottomContactState();
}

class _BottomContactState extends State<BottomContact> {
  String phoneNumber = '+917474636464';
  String whatsAppNumber = '+917474636464';
  bool _upiButtonLoading = false;

  void fetchContactData() async {
    const apiUrl = 'https://rmmatka.com/ravan/api/home-page';

    setState(() {
      _upiButtonLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          phoneNumber = data['data']['contact']['contact_no'];
          whatsAppNumber = data['data']['contact']['watsapp_no'];
        }
      } else {
        showCoolSuccessSnackbar(context, 'Error: No network available');
      }
    } catch (e) {
      showCoolSuccessSnackbar(context, 'Error: $e');
    }

    setState(() {
      _upiButtonLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchContactData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: _upiButtonLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.redType),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      phoneNumber,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => open('tel:$phoneNumber'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3),
                          color: Colors.blue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.phone,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/rm_logo.png',
                        width: 80,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => open('https://wa.me/$whatsAppNumber'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3),
                          color: Colors.green,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
