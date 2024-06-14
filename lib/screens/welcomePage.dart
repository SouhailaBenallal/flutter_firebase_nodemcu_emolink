import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase_nodemcu/screens/landingPage.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool positive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Center(
            child: Image.asset(
              'images/emolink.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Where your heart \non your sleeve',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: buildToggleSwitch(),
          ),
        ],
      ),
    );
  }

  Widget buildToggleSwitch() {
    return AnimatedToggleSwitch<bool>.dual(
      current: positive,
      first: false,
      second: true,
      spacing: 50.0,
      style: const ToggleStyle(
        borderColor: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1.5),
          ),
        ],
      ),
      borderWidth: 5.0,
      height: 55,
      onChanged: (b) {
        setState(() => positive = b);
        if (b) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandingPage(),
            ),
          );
        }
      },
      styleBuilder: (b) => ToggleStyle(
        indicatorColor: b ? Colors.white : Colors.black,
        backgroundGradient: b
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 17, 0),
                  Color.fromARGB(255, 255, 0, 85),
                  Color.fromARGB(255, 255, 0, 212),
                  Color.fromARGB(255, 55, 0, 255),
                  Color.fromARGB(255, 0, 255, 255),
                  Color.fromARGB(255, 43, 255, 0),
                  Color.fromARGB(255, 255, 230, 0),
                  Color.fromARGB(255, 255, 123, 0),
                  Color.fromARGB(255, 255, 17, 0)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : const LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
      ),
      iconBuilder: (value) => value
          ? const Icon(Icons.keyboard_double_arrow_left_rounded,
              color: Colors.black)
          : const Icon(Icons.keyboard_double_arrow_right_rounded,
              color: Colors.white),
      textBuilder: (value) => value
          ? const Center(child: Text(''))
          : const Center(child: Text('Start')),
    );
  }
}
