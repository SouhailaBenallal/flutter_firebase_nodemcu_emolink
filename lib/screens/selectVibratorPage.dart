import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectVibratorPage extends StatefulWidget {
  final String userId;
  final String associateUserId;
  final String associateFullName;

  SelectVibratorPage({
    required this.userId,
    required this.associateUserId,
    required this.associateFullName,
  });

  @override
  _SelectVibratorPageState createState() => _SelectVibratorPageState();
}

class _SelectVibratorPageState extends State<SelectVibratorPage> {
  String? selectedVibrator;

  final List<Map<String, String>> predefinedVibrators = [
    {'name': 'Vibrator 1', 'pattern': '100,200,100'},
    {'name': 'Vibrator 2', 'pattern': '200,100,200'},
    {'name': 'Vibrator 3', 'pattern': '300,100,100'},
  ];

  Future<void> updateAssociateVibrator() async {
    if (selectedVibrator == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a vibrator.'),
      ));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'associate.vibrator': selectedVibrator,
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.associateUserId)
          .update({
        'associate.vibrator': selectedVibrator,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Vibrator updated successfully.'),
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating vibrator: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff252427)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Select a Vibrator',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Color(0xff252427),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const Text(
              'Choose a vibrator pattern for your associate.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Color(0xff252427),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              isExpanded: true,
              hint: const Text('Select a vibrator'),
              value: selectedVibrator,
              items: predefinedVibrators.map((vibrator) {
                return DropdownMenuItem<String>(
                  value: vibrator['name'],
                  child: Text(vibrator['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVibrator = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(
                    color: Color(0xff252427),
                    width: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 70.0,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffff0000),
                    Color(0xffe200ff),
                    Color(0xff0027ff),
                    Color(0xff14dbec),
                    Color(0xffb1ff00),
                    Color(0xffffeb00),
                    Color(0xffff8900),
                    Color(0xffff0000)
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: updateAssociateVibrator,
                child: const Text('Update Vibrator'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
