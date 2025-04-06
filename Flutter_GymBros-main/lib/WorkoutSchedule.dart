import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutExercisesPage extends StatefulWidget {
  const WorkoutExercisesPage({super.key});

  @override
  _WorkoutExercisesPageState createState() => _WorkoutExercisesPageState();
}

class _WorkoutExercisesPageState extends State<WorkoutExercisesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _exerciseNameController = TextEditingController();
  final List<TextEditingController> _weightControllers = [];
  final List<TextEditingController> _repsControllers = [];

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> _addExerciseToFirestore(
      String name, List<Map<String, dynamic>> sets) async {
    if (_userId.isEmpty) return;

    await _firestore.collection('exercises').add({
      'userId': _userId,
      'name': name,
      'sets': sets,
    });
  }

  Future<void> _updateExerciseInFirestore(
      String docId, String name, List<Map<String, dynamic>> sets) async {
    if (_userId.isEmpty) return;

    await _firestore.collection('exercises').doc(docId).update({
      'name': name,
      'sets': sets,
    });
  }

  Future<void> _deleteExerciseFromFirestore(String docId) async {
    if (_userId.isEmpty) return;

    await _firestore.collection('exercises').doc(docId).delete();
  }

  void _showAddOrEditExerciseDialog({
    bool isEditing = false,
    String? docId,
    String? initialName,
    List<Map<String, dynamic>>? initialSets,
  }) {
    if (isEditing && initialSets != null) {
      _exerciseNameController.text = initialName ?? '';
      _weightControllers.clear();
      _repsControllers.clear();

      for (var set in initialSets) {
        _weightControllers
            .add(TextEditingController(text: set['weight'].toString()));
        _repsControllers
            .add(TextEditingController(text: set['reps'].toString()));
      }
    } else {
      _exerciseNameController.clear();
      _weightControllers.clear();
      _repsControllers.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void addNewSet() {
              _weightControllers.add(TextEditingController());
              _repsControllers.add(TextEditingController());
              setState(() {});
            }

            void removeSet(int index) {
              _weightControllers.removeAt(index);
              _repsControllers.removeAt(index);
              setState(() {});
            }

            return AlertDialog(
              title: Text(isEditing ? 'Edit Exercise' : 'Add Exercise'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _exerciseNameController,
                      decoration:
                          const InputDecoration(labelText: 'Exercise Name'),
                    ),
                    const SizedBox(height: 10),
                    ..._weightControllers.asMap().entries.map((entry) {
                      final int index = entry.key;
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _weightControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Set ${index + 1} Weight (kg)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _repsControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Set ${index + 1} Reps',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeSet(index),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: addNewSet,
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Set'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final name = _exerciseNameController.text.trim();
                    final List<Map<String, dynamic>> sets = List.generate(
                      _weightControllers.length,
                      (i) => {
                        'weight': double.tryParse(
                                _weightControllers[i].text.trim()) ??
                            0.0,
                        'reps':
                            int.tryParse(_repsControllers[i].text.trim()) ?? 0,
                      },
                    );

                    if (name.isNotEmpty && sets.isNotEmpty) {
                      if (isEditing && docId != null) {
                        await _updateExerciseInFirestore(docId, name, sets);
                      } else {
                        await _addExerciseToFirestore(name, sets);
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text(isEditing ? 'Save' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Exercises'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('exercises')
            .where('userId', isEqualTo: _userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No exercises added.'));
          }

          final exercises = snapshot.data!.docs;

          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final doc = exercises[index];
              final exercise = doc.data() as Map<String, dynamic>;
              final sets = List<Map<String, dynamic>>.from(exercise['sets']);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ExpansionTile(
                  title: Text(exercise['name']),
                  subtitle: Text('Sets: ${sets.length}'),
                  children: [
                    ...sets.asMap().entries.map((entry) {
                      final setIndex = entry.key;
                      final set = entry.value;
                      return ListTile(
                        title: Text(
                            'Set ${setIndex + 1}: Weight: ${set['weight']} kg, Reps: ${set['reps']}'),
                      );
                    }),
                    OverflowBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _showAddOrEditExerciseDialog(
                            isEditing: true,
                            docId: doc.id,
                            initialName: exercise['name'],
                            initialSets: sets,
                          ),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                        TextButton.icon(
                          onPressed: () => _deleteExerciseFromFirestore(doc.id),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOrEditExerciseDialog(isEditing: false);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
