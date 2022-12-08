import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rank133/Colors/appColors.dart';
import 'package:rank133/profile.dart';
import 'package:rank133/widgets/restaurantList.dart';



class RestrauntScreen extends StatefulWidget {
  // final String documentId;

  RestrauntScreen(AsyncSnapshot<QuerySnapshot> streamSnapshot);
  // static const routeName = '/home';
  // const RestrauntScreen({Key? key, User? user}) : super(key: key);
  @override
 _RestrauntScreenState createState() => _RestrauntScreenState();

}



class _RestrauntScreenState extends State<RestrauntScreen> {
  final CollectionReference _cafes = FirebaseFirestore.instance.collection("CafeName");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: genericAppBarColor,
        title: const Text(
          'Cafe Name',
          style: TextStyle(
            color: Colors.black54,
          ),
          ),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        // backgroundColor: screenBackgroundColor,
        // child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}

