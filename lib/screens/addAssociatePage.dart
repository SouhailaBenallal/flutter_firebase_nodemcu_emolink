import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/selectVibratorPage.dart';

class AddAssociatePage extends StatefulWidget {
  final String userId;
  final String fullName;
  final String deviceId;

  AddAssociatePage({
    required this.userId,
    required this.fullName,
    required this.deviceId,
  });

  @override
  _AddAssociatePageState createState() => _AddAssociatePageState();
}

class _AddAssociatePageState extends State<AddAssociatePage> {
  final TextEditingController emailController = TextEditingController();

  Future<void> addAssociate() async {
    final String email = emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter email.'),
      ));
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final userId = userDoc.id;
        final userData = userDoc.data() as Map<String, dynamic>;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'associate': {
            'userId': userId,
            'fullName': userData['fullName'],
          }
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'associate': {
            'userId': widget.userId,
            'fullName': widget.fullName,
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Associate added successfully.'),
        ));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectVibratorPage(
              userId: widget.userId,
              associateUserId: userId,
              associateFullName: userData['fullName'],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not found.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error adding associate: $e'),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Add Associate',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 36,
                color: Color(0xff252427),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xffa5a3a3),
                ),
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
                onPressed: addAssociate,
                child: const Text('Add Associate'),
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
