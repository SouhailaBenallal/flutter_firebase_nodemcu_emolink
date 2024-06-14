import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/homePage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        User? user = userCredential.user;

        if (user != null) {
          DocumentSnapshot userData =
              await _firestore.collection('users').doc(user.uid).get();
          String userId = userData['userId'];
          String deviceId = userData['deviceId'];
          String fullName = userData['fullName'];
          String email = userData['email'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                  userId: userId,
                  deviceId: deviceId,
                  fullName: fullName,
                  email: email),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffbfafa),
      body: Stack(
        children: <Widget>[
          buildGradientContainer(),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            top: 230.0,
            child: buildSignInForm(context),
          ),
        ],
      ),
    );
  }

  Widget buildGradientContainer() {
    return Positioned(
      left: -18.0,
      right: -18.0,
      top: 0.0,
      child: Container(
        height: 377.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.909, 0.0),
            end: Alignment(0.894, 0.0),
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
            stops: [0.0, 0.153, 0.291, 0.438, 0.591, 0.754, 0.897, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff7f5f5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.0),
          topRight: Radius.circular(6.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildBackButton(context),
                SizedBox(height: 10.0),
                buildWelcomeText(),
                SizedBox(height: 30.0),
                buildTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20.0),
                buildTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 30.0),
                buildSignInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: const Color(0xff252427)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget buildWelcomeText() {
    return Text(
      'Welcome\nBack',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 36,
        color: const Color(0xff252427),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: const Color(0xffa5a3a3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: const Color(0xff252427),
            width: 1.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (labelText == 'Email' &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget buildSignInButton(BuildContext context) {
    return Container(
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
        onPressed: () => _signIn(context),
        child: const Text('Sign In'),
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      ),
    );
  }
}
