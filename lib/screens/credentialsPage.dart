import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'homePage.dart';

class CredentialsPage extends StatefulWidget {
  final String userId;
  final String deviceId;
  final String fullName;
  final BluetoothDevice selectedDevice;
  final String email;

  CredentialsPage({
    required this.userId,
    required this.deviceId,
    required this.fullName,
    required this.email,
    required this.selectedDevice,
  });

  @override
  _CredentialsPageState createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  BluetoothCharacteristic? _ssidChar;
  BluetoothCharacteristic? _passwordChar;
  BluetoothCharacteristic? _userChar;
  BluetoothCharacteristic? _deviceChar;

  @override
  void initState() {
    super.initState();
    _connectToDevice();
  }

  Future<void> _connectToDevice() async {
    await widget.selectedDevice.connect();
    List<BluetoothService> services =
        await widget.selectedDevice.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() ==
            "6e400002-b5a3-f393-e0a9-e50e24dcca9e") {
          _ssidChar = characteristic;
        } else if (characteristic.uuid.toString() ==
            "6e400003-b5a3-f393-e0a9-e50e24dcca9e") {
          _passwordChar = characteristic;
        } else if (characteristic.uuid.toString().startsWith("6e400004")) {
          _userChar = characteristic;
        } else if (characteristic.uuid.toString().startsWith("6e400005")) {
          _deviceChar = characteristic;
        }
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Connected to ${widget.selectedDevice.name}')),
    );
  }

  Future<void> _sendCredentials() async {
    if (_ssidChar == null ||
        _passwordChar == null ||
        _userChar == null ||
        _deviceChar == null) return;

    await _ssidChar!.write(_ssidController.text.codeUnits);
    await _passwordChar!.write(_passwordController.text.codeUnits);
    await _userChar!.write(widget.userId.codeUnits);
    await _deviceChar!.write(widget.deviceId.codeUnits);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Credentials and identifiers sent to ESP32')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          userId: widget.userId,
          deviceId: widget.deviceId,
          fullName: widget.fullName,
          email: widget.email,
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
        padding: const EdgeInsets.all(36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Enter WiFi \nCredentials',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 36,
                color: const Color(0xff252427),
                fontWeight: FontWeight.w600,
              ),
              softWrap: false,
            ),
            SizedBox(height: 20),
            buildTextField(
              controller: _ssidController,
              labelText: 'SSID',
            ),
            SizedBox(height: 20),
            buildTextField(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
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
                onPressed: _sendCredentials,
                child: const Text('Send Credentials'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
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
          borderSide: const BorderSide(
            color: Color(0xff252427),
            width: 1.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
