import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/colorsSenseAdd.dart';

class AssociateListPage extends StatelessWidget {
  final String userId;

  AssociateListPage({required this.userId});

  Future<List<Map<String, String>>> fetchAssociates() async {
    List<Map<String, String>> associates = [];
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists && snapshot.data() != null) {
      var data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('associate')) {
        var associateData = data['associate'];
        associates.add({
          'fullName': associateData['fullName'] ?? '',
          'userId': associateData['userId'] ?? '',
          'deviceId': associateData['deviceId'] ?? '',
        });
      }
    }
    return associates;
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xff252427)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            FutureBuilder<List<Map<String, String>>>(
              future: fetchAssociates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No associates found'));
                } else {
                  var associates = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: associates.length,
                    itemBuilder: (context, index) {
                      var associate = associates[index];
                      return _buildAssociateTile(
                        context,
                        associate['fullName'] ?? 'Unknown',
                        associate['userId']!,
                        associate['deviceId']!,
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssociateTile(
      BuildContext context, String fullName, String userId, String deviceId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ColorsSenseAdd(
              userId: this.userId,
              deviceId: deviceId,
              associateUserId: userId,
              associateFullName: fullName,
            ),
          ),
        );
      },
      child: Container(
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
              fullName,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: const Color(0xff808080)),
          ],
        ),
      ),
    );
  }
}
