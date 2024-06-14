import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/IdentityDetailsPage.dart';

import 'basePage.dart';

class SettingsPage extends StatelessWidget {
  final String userId;
  final String deviceId;
  final String fullName;
  final String email;

  SettingsPage({
    required this.userId,
    required this.deviceId,
    required this.fullName,
    required this.email,
  });

  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      userId: userId,
      deviceId: deviceId,
      fullName: fullName,
      email: email,
      selectedIndex: 3,
      child: Scaffold(
        backgroundColor: const Color(0xfff7f5f5),
        body: Stack(
          children: [
            Positioned(
              top: 20,
              left: MediaQuery.of(context).size.width / 2 - 20,
              child: Image.asset(
                'images/emolink.png',
                height: 40,
              ),
            ),
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildGradientCircle(),
                        _buildUserAvatar(fullName, Icons.person, Colors.black),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSettingsOption(
                    context,
                    'Identity Details',
                    Icons.account_circle,
                    IdentityDetailsPage(
                        userId: userId, fullName: fullName, email: email),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String text, dynamic iconOrInitial, Color color,
      {bool isInitial = false}) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: color,
      child: isInitial
          ? Text(
              iconOrInitial,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 40,
                color: Colors.white,
              ),
            )
          : Icon(iconOrInitial, size: 60, color: Colors.white),
    );
  }

  Widget _buildGradientCircle() {
    return Container(
      width: 135,
      height: 135,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, String text, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () => navigateTo(context, page),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 36),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffefefef),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
