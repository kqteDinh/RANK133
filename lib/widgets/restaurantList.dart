import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rank133/Colors/appColors.dart';

class RestaurantList extends StatefulWidget {
  static const routeName = '/home';
  const RestaurantList({Key? key, User? user}) : super(key: key);
  
  @override
  _RestaurantListState createState() => _RestaurantListState();

}

class _RestaurantListState extends State<RestaurantList> {
  final CollectionReference _cafes = FirebaseFirestore.instance.collection('CafeName');
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: StreamBuilder(
        // backgroundColor: screenBackgroundColor,
        // child: _widgetOptions.elementAt(_selectedIndex),
        stream: _cafes.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    leading: Image.network(documentSnapshot["Images"][0]),
                    title: Text(documentSnapshot["Name"]),
                    subtitle: Text(documentSnapshot["Address"]),
                  ),
                );
              }
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

