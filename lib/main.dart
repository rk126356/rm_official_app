import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/screens/auth/login_screen.dart';
import 'package:rm_official_app/screens/auth/register_screen.dart';

import 'const/colors.dart';
import 'provider/resend_otp_timer_provider.dart';
import 'provider/user_provider.dart';
import 'screens/auth/send_otp_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ResendTimerProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RM MATKA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'LilitaOne'),
          displayMedium: TextStyle(fontFamily: 'LilitaOne'),
          displaySmall: TextStyle(fontFamily: 'LilitaOne'),
          headlineMedium: TextStyle(fontFamily: 'LilitaOne'),
          headlineSmall: TextStyle(fontFamily: 'LilitaOne'),
          titleLarge: TextStyle(fontFamily: 'LilitaOne'),
          titleMedium: TextStyle(fontFamily: 'LilitaOne'),
          titleSmall: TextStyle(fontFamily: 'LilitaOne'),
          bodyLarge: TextStyle(fontFamily: 'LilitaOne'),
          bodyMedium: TextStyle(fontFamily: 'LilitaOne'),
          bodySmall: TextStyle(fontFamily: 'LilitaOne'),
          labelLarge: TextStyle(fontFamily: 'LilitaOne'),
          labelSmall: TextStyle(fontFamily: 'LilitaOne'),
        ),
      ),
      home: const LoginScreen(
        refresh: true,
      ),
    );
  }
}
