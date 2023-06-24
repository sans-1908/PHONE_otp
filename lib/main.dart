import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_otp/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import 'screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //linking flutter engine
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider
    (
      providers: [
        ChangeNotifierProvider(create: (_)=>AuthProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
      ),
    );
  }
}