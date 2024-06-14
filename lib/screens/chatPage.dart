import 'package:flutter/material.dart';

import 'basePage.dart';

class ChatPage extends StatelessWidget {
  final String userId;
  final String deviceId;
  final String fullName;
  final String email;

  ChatPage(
      {required this.userId,
      required this.deviceId,
      required this.fullName,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      userId: userId,
      deviceId: deviceId,
      fullName: fullName,
      email: email,
      selectedIndex: 2,
      child: Center(
        child: Text(
          'Chat Page\nUser ID: $userId\nDevice ID: $deviceId',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
