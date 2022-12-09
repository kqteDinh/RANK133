import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank133/RegisterScreen.dart';
import 'package:rank133/homeScreen.dart';
import 'package:rank133/loginScreen.dart';

import 'firebase_options.dart';
 
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'RANKd Eats App';
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: _getLandingPage(),
        routes: {
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          LoginScreen.routeName:(ctx) => LoginScreen(),
          HomeScreen.routeName:(ctx) => HomeScreen(),
          // RestaurantScreen.routeName:(ctx) => RestaurantScreen(),
        },
      );
  }
  
  _getLandingPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.providerData.length == 1) { // logged in using email and password
            return snapshot.data?.email != null
              ? HomeScreen()
              : LoginScreen();
        } else { // logged in using other providers
          return HomeScreen();
        }
      } else {
        return LoginScreen();
      }
    },
  );
  }
}