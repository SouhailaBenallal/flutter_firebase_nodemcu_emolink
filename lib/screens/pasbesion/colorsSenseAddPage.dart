import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/iotemokinkscreen.dart';

class ColorsSenseChooseWords extends StatelessWidget {
  final String userId;
  final String deviceId;

  ColorsSenseChooseWords(
      {Key? key, required this.userId, required this.deviceId})
      : super(key: key);

  final TextEditingController _wordController = TextEditingController();

  void _saveWord(BuildContext context) async {
    String word = _wordController.text;

    if (word.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('words')
            .add({'word': word});
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Word saved successfully')));
        _wordController.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Iotemokinkscreen(userId: userId, deviceId: deviceId)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save word: $e')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a word')));
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
              'Write Your Text',
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
            top: MediaQuery.of(context).size.height * 0.5408 - 26.0,
            child: Container(
              height: 52.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(width: 1.0, color: const Color(0xff252427)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    controller: _wordController,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: const Color.fromARGB(255, 165, 165, 165),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a word',
                    ),
                  ),
                ),
              ),
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
                onPressed: () => _saveWord(context),
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
