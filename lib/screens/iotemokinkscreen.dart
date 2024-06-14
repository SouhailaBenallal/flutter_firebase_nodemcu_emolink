import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class Iotemokinkscreen extends StatefulWidget {
  final String userId;
  final String deviceId;

  Iotemokinkscreen({required this.userId, required this.deviceId});

  @override
  IotemokinkscreenState createState() => IotemokinkscreenState();
}

class IotemokinkscreenState extends State<Iotemokinkscreen> {
  late final DatabaseReference dbRef;
  List<Color> selectedColors = [Colors.white];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://finalworkemolink-468ad-default-rtdb.europe-west1.firebasedatabase.app',
    ).ref();
  }

  Future<void> _sendColors() async {
    List<String> colorsHex = selectedColors
        .map(
            (color) => color.value.toRadixString(16).substring(2).toUpperCase())
        .toList();

    try {
      await dbRef
          .child("users")
          .child(widget.userId)
          .child("devices")
          .child(widget.deviceId)
          .set({
        "colors": colorsHex,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Colors sent successfully')),
      );
      print('Colors written to Firebase');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending colors: $e')),
      );
    }
  }

  void _showColorPickerDialog(int index) async {
    Color? color = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose a color for segment ${index + 1}'),
        content: CircleColorPicker(
          onChanged: (color) {
            setState(() {
              selectedColors[index] = color;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedColors[index]);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );

    if (color != null) {
      setState(() {
        selectedColors[index] = color;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Your Colors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleColorPicker(
              onChanged: (color) {
                setState(() {
                  selectedColors[0] = color;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < selectedColors.length; i++)
                  GestureDetector(
                    onTap: () => _showColorPickerDialog(i),
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selectedColors[i],
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColors.add(Colors.white);
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendColors,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
