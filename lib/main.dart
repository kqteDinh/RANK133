import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rank133/loginScreen.dart';
import 'package:rank133/provider/provider.dart';
 
void main() => runApp(const MyApp());
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  static const String _title = 'App';
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: User())
      ],
      child: MaterialApp(
        title: "RANKd Eats App",
        home: LoginScreen()
      ),
    );
  }
}