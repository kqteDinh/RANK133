import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rank133/Colors/appColors.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key, User? user}) : super(key: key);
  
  @override
   @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: genericAppBarColor,
        title: const Text(
          'RANKd Eats',
          style: TextStyle(
            color: Colors.black54,
          ),
          ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: iconsColor,
            onPressed: (){
                
            },
            )
        ],

      ),
      body: Scaffold(
        backgroundColor: screenBackgroundColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: genericAppBarColor,
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
      ]),
    );
  }
}

