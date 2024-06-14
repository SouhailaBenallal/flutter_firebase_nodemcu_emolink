import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_nodemcu/screens/homePage.dart';
import 'package:flutter_firebase_nodemcu/screens/signinPage.dart';
import 'package:flutter_firebase_nodemcu/screens/welcomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA20ym16w61KuSxf2j_i4c7figf6FbcnPo',
        appId: '1:873323782454:android:4d03237afc376c789cd397',
        messagingSenderId: '873323782454',
        projectId: 'finalworkemolink-468ad',
        storageBucket: 'finalworkemolink-468ad.appspot.com',
        databaseURL:
            'https://finalworkemolink-468ad-default-rtdb.europe-west1.firebasedatabase.app',
      ),
    );
    runApp(const MyApp());
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key ?? const Key('myAppKey'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/welcomepage': (BuildContext context) => WelcomePage(title: ''),
        '/signin': (BuildContext context) => SignInPage(),
        '/homepage': (BuildContext context) => HomePage(
              userId: '',
              deviceId: '',
              fullName: '',
              email: '',
            ),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      home: WelcomePage(
        title: '',
      ),
    );
  }
}
