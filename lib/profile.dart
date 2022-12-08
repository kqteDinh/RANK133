import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rank133/Colors/appColors.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/home';
  const ProfileScreen({Key? key, User? user}) : super(key: key);
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    return Text(
      'kahfasd',
    );
  }
}

