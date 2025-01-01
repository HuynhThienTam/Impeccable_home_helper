import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:impeccablehome_helper/auth/auth.dart';
import 'package:impeccablehome_helper/resources/authenticatiom_method.dart';
import 'package:impeccablehome_helper/resources/booking_method.dart';
import 'package:impeccablehome_helper/screens/apprroval_waiting_screen.dart';
import 'package:impeccablehome_helper/screens/ec_providing_screen.dart';
import 'package:impeccablehome_helper/screens/id_providing_screen.dart';
import 'package:impeccablehome_helper/screens/info_providing_screen.dart';
import 'package:impeccablehome_helper/screens/onboarding_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        AndroidProvider.playIntegrity, // or AndroidProvider.safetyNet
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
       providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationMethods()),
        ChangeNotifierProvider(create:(_)=>BookingMethods()),
        // ChangeNotifierProvider(create: (_) => HelperDetailsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF66CCFF)),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}


