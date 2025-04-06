import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double? totalCalories;
  String? userName; // To store the user's name

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      double weight = data?['weight'] ?? 0.0;
      double height = data?['height'] ?? 0.0;
      String activityLevel = data?['activityLevel'] ?? "Low";
      userName = data?['name'] ?? "User"; // Retrieve the user's name

      double activityMultiplier = activityLevel == "High"
          ? 1.9
          : activityLevel == "Moderate"
              ? 1.55
              : 1.2;

      double bmr = (10 * weight) +
          (6.25 * height) -
          (5 * 25) +
          5; // Example age and male gender

      setState(() {
        totalCalories = bmr * activityMultiplier;
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed("HomePage");
        break;
      case 1:
        Navigator.of(context).pushNamed("Notificaion");
        break;
      case 2:
        Navigator.of(context).pushNamed("Settings");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AG Bros"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.fitness_center),
          onPressed: () {
            // Functionality for the gym icon
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('LoginPage');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign out...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Card in the top left
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://clipground.com/images/cartoon-muscle-man-clipart-6.jpg',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        userName ?? "Loading...", // Display user's name
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        totalCalories != null
                            ? "Calories: ${totalCalories!.toStringAsFixed(2)}"
                            : "Loading...",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Row with 3 cards
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard('Nutrition', Icons.restaurant, () {
                Navigator.of(context).pushNamed("Nutrition");
              }),
              const SizedBox(width: 20),
              _buildCard('Workout Schedule', Icons.fitness_center, () {
                Navigator.of(context).pushNamed("Workout");
              }),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  // Helper method to create a card widget
  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
