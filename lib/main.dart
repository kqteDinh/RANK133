import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank133/RegisterScreen.dart';
import 'package:rank133/homeScreen.dart';
import 'package:rank133/loginScreen.dart';
import 'package:rank133/provider/user.dart';

 
void main() => runApp(const MyApp());
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'RANKd Eats App';
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: User())
      ],
      child: Consumer<User>(builder: (ctx, auth, _) => MaterialApp(
        title: _title,
        home: LoginScreen(),
        routes: {
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          LoginScreen.routeName:(ctx) => LoginScreen(),
          HomeScreen.routeName:(ctx) => HomeScreen(),
          // RestaurantScreen.routeName:(ctx) => RestaurantScreen(),
        },
      ),)
    );
  }
}