import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ColorsSenseAdd extends StatefulWidget {
  final String userId;
  final String deviceId;
  final String associateUserId;
  final String associateFullName;

  ColorsSenseAdd({
    required this.userId,
    required this.deviceId,
    required this.associateUserId,
    required this.associateFullName,
  });

  @override
  ColorsSenseAddState createState() => ColorsSenseAddState();
}

class ColorsSenseAddState extends State<ColorsSenseAdd> {
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
          .child(widget.associateUserId)
          .child("devices")
          .child(widget.deviceId)
          .child("colors")
          .set(colorsHex);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Colors sent to associate successfully')),
      );
      print('Colors written to Firebase for associate');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending colors: $e')),
      );
    }
  }

  Future<void> _showColorPickerDialog(int index) async {
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
      backgroundColor: const Color(0xfff7f5f5),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 38.0,
            top: 106.0,
            child: Text(
              'Choose Colors',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 36,
                color: const Color(0xff252427),
                fontWeight: FontWeight.w600,
              ),
              softWrap: false,
            ),
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: const Color(0xff252427)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            left: 38.0,
            right: 37.0,
            top: MediaQuery.of(context).size.height * 0.40,
            child: Column(
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
              ],
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              width: double.infinity,
              height: 70.0,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xffff0000),
                    const Color(0xffe200ff),
                    const Color(0xff0027ff),
                    const Color(0xff14dbec),
                    const Color(0xffb1ff00),
                    const Color(0xffffeb00),
                    const Color(0xffff8900),
                    const Color(0xffff0000),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: _sendColors,
                child: const Text('Save'),
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
          ),
        ],
      ),
    );
  }
}
