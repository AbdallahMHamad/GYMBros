import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Bodymeasurements extends StatefulWidget {
  const Bodymeasurements({super.key});

  @override
  State<Bodymeasurements> createState() => _bodyMeasurementsState();
}

class _bodyMeasurementsState extends State<Bodymeasurements> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipController = TextEditingController();

  String _selectedActivityLevel = "Low"; // Default activity level

  Future<void> _saveMeasurements() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Save the data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'height': double.tryParse(_heightController.text) ?? 0.0,
        'weight': double.tryParse(_weightController.text) ?? 0.0,
        'chest': double.tryParse(_chestController.text) ?? 0.0,
        'waist': double.tryParse(_waistController.text) ?? 0.0,
        'hip': double.tryParse(_hipController.text) ?? 0.0,
        'activityLevel': _selectedActivityLevel,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Measurements saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving measurements: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.straighten,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 10),
            Text("Body Measurements"),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              title: "Enter Your Measurements",
              child: Column(
                children: [
                  _buildMeasurementField(
                    controller: _heightController,
                    label: "Height (cm)",
                    icon: Icons.height,
                    hint: "Enter your height",
                  ),
                  const SizedBox(height: 20),
                  _buildMeasurementField(
                    controller: _weightController,
                    label: "Weight (kg)",
                    icon: Icons.monitor_weight,
                    hint: "Enter your weight",
                  ),
                  const SizedBox(height: 20),
                  _buildMeasurementField(
                    controller: _chestController,
                    label: "Chest (cm)",
                    icon: Icons.straighten,
                    hint: "Enter your chest size",
                  ),
                  const SizedBox(height: 20),
                  _buildMeasurementField(
                    controller: _waistController,
                    label: "Waist (cm)",
                    icon: Icons.straighten,
                    hint: "Enter your waist size",
                  ),
                  const SizedBox(height: 20),
                  _buildMeasurementField(
                    controller: _hipController,
                    label: "Hip (cm)",
                    icon: Icons.straighten,
                    hint: "Enter your hip size",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Determine Activity Level",
              child: Column(
                children: [
                  _buildRadioButton(
                      "Low", "Minimal activity or sedentary lifestyle"),
                  _buildRadioButton(
                      "Moderate", "Moderate exercise 3-5 days per week"),
                  _buildRadioButton("High", "Intense exercise or physical job"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _saveMeasurements();
                  Navigator.of(context).pop(); // Return to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save Details",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.lightBlue),
            filled: true,
            fillColor: Colors.grey[200],
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildRadioButton(String value, String description) {
    return ListTile(
      leading: Radio<String>(
        value: value,
        groupValue: _selectedActivityLevel,
        onChanged: (String? newValue) {
          setState(() {
            _selectedActivityLevel = newValue!;
          });
        },
      ),
      title: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
    );
  }
}
