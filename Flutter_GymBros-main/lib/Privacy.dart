import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  String? userId;
  String? decryptedPassword;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch User ID and Decrypted Password
  Future<void> fetchUserData() async {
    try {
      // Get the current user ID from Firebase Auth
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
        print("User ID: $userId");

        // Fetch encrypted password from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final encryptedPassword = userDoc.data()?['password'];
          print("Encrypted Password from Firestore: $encryptedPassword");

          if (encryptedPassword != null) {
            // Decrypt the password (replace with your decryption logic)
            decryptedPassword = decryptPassword(encryptedPassword);
            print("Decrypted Password: $decryptedPassword");
          } else {
            print("No password field found in Firestore.");
          }
        } else {
          print("User document does not exist in Firestore.");
        }

        setState(() {}); // Update UI
      } else {
        print("No user is currently logged in.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Mock decryption function (replace with your decryption logic)
  String decryptPassword(String encryptedPassword) {
    // Replace this with the actual decryption logic
    return String.fromCharCodes(
        encryptedPassword.codeUnits.map((e) => e - 1)); // Example decryption
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("User ID: ${userId ?? "Loading..."}"),
            const SizedBox(height: 10),
            Text("Decrypted Password: ${decryptedPassword ?? "Loading..."}"),
            const SizedBox(height: 20),
            const Text(
              "Note: Keep your information private and secure.",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
