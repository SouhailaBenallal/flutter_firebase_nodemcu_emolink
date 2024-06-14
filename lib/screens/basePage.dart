import 'package:flutter/material.dart';

import 'chatPage.dart';
import 'homePage.dart';
import 'logBookPage.dart';
import 'settingsPage.dart';

class BasePage extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final String userId;
  final String deviceId;
  final String fullName;
  final String email;

  BasePage(
      {required this.child,
      required this.selectedIndex,
      required this.userId,
      required this.deviceId,
      required this.fullName,
      required this.email});

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  void _onItemTapped(int index) {
    if (index == widget.selectedIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = HomePage(
            userId: widget.userId,
            deviceId: widget.deviceId,
            fullName: widget.fullName,
            email: widget.email);
        break;
      case 1:
        page = LogBookPage(
          userId: widget.userId,
          deviceId: widget.deviceId,
          fullName: widget.fullName,
          email: widget.email,
        );
        break;
      case 2:
        page = ChatPage(
          userId: widget.userId,
          deviceId: widget.deviceId,
          fullName: widget.fullName,
          email: widget.email,
        );
        break;
      case 3:
        page = SettingsPage(
            userId: widget.userId,
            deviceId: widget.deviceId,
            fullName: widget.fullName,
            email: widget.email);
        break;
      default:
        page = HomePage(
            userId: widget.userId,
            deviceId: widget.deviceId,
            fullName: widget.fullName,
            email: widget.email);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'LogBook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
