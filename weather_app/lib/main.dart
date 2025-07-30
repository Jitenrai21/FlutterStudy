import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB6UoUhmpc6-zb3iwqkpGlOIp8NGmcpUIY",
      authDomain: "my-weather-app-6da7a.firebaseapp.com",
      projectId: "my-weather-app-6da7a",
      storageBucket: "my-weather-app-6da7a.appspot.com",
      messagingSenderId: "361660269432",
      appId: "1:361660269432:web:895cf01de337930dd63e8d", 
    ),
  );

  } else {
    await Firebase.initializeApp(); // Android/iOS will read from google-services.json
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JKR Weather App',
      theme: ThemeData.dark(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}
