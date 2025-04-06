import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gymbros/Login.dart';
import 'package:flutter_gymbros/Notification.dart';
import 'package:flutter_gymbros/Nutrition.dart';
import 'package:flutter_gymbros/WorkoutSchedule.dart';
import 'package:flutter_gymbros/bodyMeasurements.dart';
import 'package:flutter_gymbros/homePage.dart';
import 'package:flutter_gymbros/signup.dart';
import 'package:flutter_gymbros/foodBlog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gymbros/Settings.dart';
import 'package:flutter_gymbros/Privacy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'LoginPage': (context) => const LoginPage(),
        "HomePage": (context) => const Homepage(),
        "SignUp": (context) => const Signup(),
        "Nutrition": (context) => const Nutrition(),
        "bodyMeasurment": (context) => const Bodymeasurements(),
        "FoodBlog": (context) => const FoodBlog(),
        "Settings": (context) => const SettingsPage(),
        "Workout": (context) => const WorkoutExercisesPage(),
        "Notificaion": (context) => const NotificationPage(),
        "Privacy": (context) => const PrivacyPage(),
      },
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const Homepage(),
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        useMaterial3: false,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
