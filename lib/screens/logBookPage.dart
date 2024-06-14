import 'package:flutter/material.dart';

import 'basePage.dart';

class LogBookPage extends StatelessWidget {
  final String userId;
  final String deviceId;
  final String fullName;
  final String email;

  LogBookPage(
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
      selectedIndex: 1,
      child: Center(
        child: Text(
          'LogBook Page\nUser ID: $userId\nDevice ID: $deviceId',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
