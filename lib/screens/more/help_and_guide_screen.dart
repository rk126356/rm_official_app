// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/error_snackbar_widget.dart';

class HelpAndGuideScreen extends StatefulWidget {
  const HelpAndGuideScreen({Key? key}) : super(key: key);

  @override
  State<HelpAndGuideScreen> createState() => _HelpAndGuideScreenState();
}

class _HelpAndGuideScreenState extends State<HelpAndGuideScreen> {
  late WebViewController _webViewController;
  String htmlContent = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await http.get(Uri.parse('https://rmmatka.com/app/api/how-to-play'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (!data['error']) {
        final String instructionHtml = data['data']['instruction'];
        setState(() {
          htmlContent = instructionHtml;
        });

        _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..loadHtmlString(htmlContent);
      } else {
        showCoolErrorSnackbar(context, data['message']);
      }
    } else {
      showCoolErrorSnackbar(context, 'Check your internet connection');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'HOW TO PLAY',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Builder(
                builder: (BuildContext context) {
                  return WebViewWidget(
                    controller: _webViewController,
                  );
                },
              ),
            ),
    );
  }
}
