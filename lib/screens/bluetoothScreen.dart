import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'credentialsPage.dart';

class BluetoothPage extends StatefulWidget {
  final String userId;
  final String deviceId;
  final String fullName;
  final String email;

  BluetoothPage(
      {required this.userId,
      required this.deviceId,
      required this.fullName,
      required this.email});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  List<ScanResult> _scanResults = [];
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    _flutterBlue.startScan(timeout: Duration(seconds: 4));
    _flutterBlue.scanResults.listen((results) {
      setState(() {
        _scanResults = results.where((r) => r.device.name.isNotEmpty).toList();
      });
    });
  }

  void _selectDevice(BluetoothDevice device) {
    setState(() {
      _selectedDevice = device;
    });
  }

  void _navigateToCredentialsPage() {
    if (_selectedDevice == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CredentialsPage(
          userId: widget.userId,
          deviceId: widget.deviceId,
          fullName: widget.fullName,
          email: widget.email,
          selectedDevice: _selectedDevice!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f5f5),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color(0xff252427)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Connection \nBracelet',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 36,
                  color: const Color(0xff252427),
                  fontWeight: FontWeight.w600,
                ),
                softWrap: false,
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _startScan,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.bluetooth, size: 50, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_scanResults.isNotEmpty)
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: _buildDeviceCircles(),
                  ),
                ),
              SizedBox(height: 20),
              Container(
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
                  onPressed: _navigateToCredentialsPage,
                  child: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
    );
  }

  List<Widget> _buildDeviceCircles() {
    List<Widget> circles = [];
    final int itemCount = _scanResults.length;
    final double radius = 100;
    final double angleStep = 2 * pi / itemCount;

    for (int i = 0; i < itemCount; i++) {
      final double angle = i * angleStep;
      final double dx = radius * cos(angle);
      final double dy = radius * sin(angle);

      circles.add(Positioned(
        left: 150 + dx,
        top: 150 + dy,
        child: GestureDetector(
          onTap: () => _selectDevice(_scanResults[i].device),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: _selectedDevice == _scanResults[i].device
                    ? const Color.fromARGB(255, 216, 216, 216)
                    : Colors.grey,
                child: Icon(
                  _scanResults[i].device.name == 'EmolinkTest'
                      ? Icons.watch
                      : Icons.warning,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                _scanResults[i].device.name,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return circles;
  }
}
