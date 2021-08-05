import 'package:book_tracker_app/screens/login_page.dart';
import 'package:book_tracker_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User firebaseUser = FirebaseAuth.instance.currentUser;
    Widget widget;

    if (firebaseUser != null) {
      print(firebaseUser.email);
      widget = MainScreenPage();
    } else {
      widget = LoginPage();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: widget,
    );
  }
}
