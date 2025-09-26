import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pro4/appBrain.dart';
import 'package:pro4/screens/HomeScreen.dart';
import 'package:pro4/screens/SignupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final AppBrain appbrain = AppBrain();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("Firebase initialized");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser == null ? SignupScreen() : HomeScreen()
    );
  }
}