import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/bluetoothScreen.dart';

class ProvidingBluetooth extends StatelessWidget {
  final String userId;
  final String deviceId;
  final String fullName;
  final String email;

  ProvidingBluetooth(
      {required this.userId,
      required this.deviceId,
      required this.fullName,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f5f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40.0),
            IconButton(
              icon: Icon(Icons.arrow_back, color: const Color(0xff252427)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 40.0),
            Text(
              'Thanks for \nproviding your \ninformation! \n',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 36,
                color: const Color(0xff252427),
                fontWeight: FontWeight.w600,
              ),
              softWrap: false,
            ),
            SizedBox(height: 20.0),
            Text(
              'Now, let me guide you through \nhow to connect with your \nbracelet.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: const Color(0xff252427),
                fontWeight: FontWeight.w600,
              ),
              softWrap: false,
            ),
            SizedBox(height: 20.0),
            Center(
              child: Image.asset(
                'images/bluetooth.png',
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
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
                    const Color(0xffff0000)
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BluetoothPage(
                        userId: userId,
                        deviceId: deviceId,
                        fullName: fullName,
                        email: email,
                      ),
                    ),
                  );
                },
                child: const Text('Continue'),
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
