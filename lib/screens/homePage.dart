import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/addAssociatePage.dart';
import 'package:flutter_firebase_nodemcu/screens/associateListPage.dart';

import 'basePage.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final String deviceId;
  final String fullName;
  final String email;

  HomePage({
    required this.userId,
    required this.deviceId,
    required this.fullName,
    required this.email,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? associateName;
  String? associateUserId;
  String? associateDeviceId;
  late DocumentReference associateRef;

  @override
  void initState() {
    super.initState();
    _setupAssociateListener();
  }

  void _setupAssociateListener() {
    associateRef =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);
    associateRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('associate')) {
          var associateData = data['associate'];
          setState(() {
            associateName = associateData['fullName'];
            associateUserId = associateData['userId'];
            associateDeviceId = associateData['deviceId'];
          });
        } else {
          setState(() {
            associateName = null;
            associateUserId = null;
            associateDeviceId = null;
          });
        }
      }
    });
  }

  Future<void> _addAssociate(String email) async {
    try {
      Map<String, String> associateInfo = await getUserInfoByEmail(email);
      await ensureUserDocumentExists(
          widget.userId, widget.fullName, widget.deviceId);

      await associateRef.update({
        'associate': {
          'fullName': associateInfo['fullName'],
          'userId': associateInfo['userId'],
          'deviceId': associateInfo['deviceId'],
        }
      });

      await ensureUserDocumentExists(associateInfo['userId']!,
          associateInfo['fullName']!, associateInfo['deviceId']!);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(associateInfo['userId'])
          .update({
        'associate': {
          'fullName': widget.fullName,
          'userId': widget.userId,
          'deviceId': widget.deviceId,
        }
      });
    } catch (e) {
      print('Error adding associate: $e');
    }
  }

  Future<void> ensureUserDocumentExists(
      String userId, String fullName, String deviceId) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      await userRef.set({
        'fullName': fullName,
        'email': '',
        'gender': '',
        'deviceId': deviceId,
      });
    }
  }

  Future<Map<String, String>> getUserInfoByEmail(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var userDoc = snapshot.docs.first;
      var userData = userDoc.data() as Map<String, dynamic>;

      if (userData.containsKey('deviceId')) {
        return {
          'fullName': userData['fullName'],
          'userId': userDoc.id,
          'deviceId': userData['deviceId'],
        };
      } else {
        throw Exception('No devices found for user');
      }
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      userId: widget.userId,
      deviceId: widget.deviceId,
      fullName: widget.fullName,
      email: widget.email,
      selectedIndex: 0,
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
              left: 20,
              child: GestureDetector(
                onTap: associateName != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AssociateListPage(userId: widget.userId),
                          ),
                        );
                      }
                    : null,
                child: Opacity(
                  opacity: associateName == null ? 0.1 : 1.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildGradientCircle(size: 60),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildGradientCircle(),
                              _buildUserAvatar(
                                widget.fullName,
                                Icons.person,
                                Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.fullName,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildGradientCircle(),
                              if (associateName == null)
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddAssociatePage(
                                          userId: widget.userId,
                                          fullName: widget.fullName,
                                          deviceId: widget.deviceId,
                                        ),
                                      ),
                                    );
                                    if (result != null && result is String) {
                                      await _addAssociate(result);
                                    }
                                  },
                                  child: _buildUserAvatar(
                                    'Add Associate',
                                    Icons.add,
                                    const Color.fromARGB(255, 236, 236, 236),
                                  ),
                                )
                              else
                                _buildUserAvatar(
                                  associateName!,
                                  associateName![0],
                                  Colors.grey,
                                  isInitial: true,
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            associateName == null
                                ? 'Add Associate'
                                : associateName!,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  if (associateName == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Looks like there's not much happening for now. As soon as one of your partners connects, there will be some text here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff252427),
                        ),
                      ),
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

  Widget _buildGradientCircle({double size = 135}) {
    return Container(
      width: size,
      height: size,
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
