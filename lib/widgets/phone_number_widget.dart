// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/widgets/success_snackbar_widget.dart';

import '../const/colors.dart';
import '../utils/url_launcher.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({
    Key? key,
  }) : super(key: key);

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  String phoneNumber = '';
  String whatsAppNumber = '';

  void fetchContactData() async {
    const apiUrl = 'https://rmmatka.com/app/api/home-page';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          setState(() {
            phoneNumber = data['data']['contact']['contact_no'];
            whatsAppNumber = data['data']['contact']['watsapp_no'];
          });
        }
      } else {
        showCoolSuccessSnackbar(context, 'Error: No network available');
      }
    } catch (e) {
      showCoolSuccessSnackbar(context, 'Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchContactData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => open('tel:$phoneNumber'),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: const FaIcon(
              FontAwesomeIcons.phone,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: 220,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.redType),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: phoneNumber.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Text(
                    phoneNumber,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
          ),
        ),
        GestureDetector(
          onTap: () => open('https://wa.me/$whatsAppNumber'),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: const FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
