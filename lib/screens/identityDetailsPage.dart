import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IdentityDetailsPage extends StatelessWidget {
  final String userId;
  final String fullName;
  final String email;

  IdentityDetailsPage({
    required this.userId,
    required this.fullName,
    required this.email,
  });

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/signin');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to logout: $e'),
        ),
      );
    }
  }

  void _deleteAccount(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      await FirebaseAuth.instance.currentUser?.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account deleted successfully'),
        ),
      );

      Navigator.of(context).pushReplacementNamed('/signin');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f5f5),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'images/emolink.png',
                height: 40,
              ),
            ),
            SizedBox(height: 30),
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
            SizedBox(height: 30),
            _buildInfoContainer('Username', fullName),
            _buildInfoContainer('Email', email),
            _buildActionContainer('Logout',
                const Color.fromARGB(255, 0, 255, 13), () => _logout(context)),
            _buildActionContainer(
                'Delete Account', Colors.red, () => _deleteAccount(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 36),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffefefef),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: const Color(0xff000000),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: const Color(0xff808080),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionContainer(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 36),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffefefef),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
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
}
