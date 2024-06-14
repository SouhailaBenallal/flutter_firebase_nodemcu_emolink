import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/signinPage.dart';
import 'package:flutter_firebase_nodemcu/screens/signupPage.dart';

class LandingPage extends StatelessWidget {
  LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: -30,
            right: -31,
            top: -34,
            child: Container(
              height: 283,
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
          ),
          Positioned(
            top: 230,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xfff7f5f5),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    'images/emolink.png',
                    fit: BoxFit.contain,
                    height: 120,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Welcome to EmoLink. Our app connects to \nyour bracelet, sending light signals to \nconvey your emotions in real-time. \nEmoLink: Wear your heart on your sleeve.',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 270,
                    height: 70,
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
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
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
                  const SizedBox(height: 20),
                  Container(
                    width: 270,
                    height: 70,
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
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: const Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
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
          ),
        ],
      ),
    );
  }
}
