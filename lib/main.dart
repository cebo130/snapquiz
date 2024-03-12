import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snapquiz/Testing/socialise/home_page.dart';
import 'package:snapquiz/pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("Firebase initialized successfully!**********************************________-------------**************");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Spin(),
    );
  }
}
